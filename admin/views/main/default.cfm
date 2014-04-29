<cfoutput>
<!--- Get the general revenue statistic --->
<cfquery name="qGetRevenue" result="result">
    SELECT monthname(orderDate) as amonth,
         year(orderDate) as ayear,
         SUM(total) as total
    FROM `happy_water`.`order`
    WHERE orderdate BETWEEN DATE_SUB(CURDATE(), INTERVAL 12 MONTH) AND CURDATE()
    GROUP BY amonth, ayear
    ORDER BY orderDate
</cfquery>

<!--- Get the top 5 users have highest sum of value in order  --->
<cfquery name="getUsers">
    SELECT u.userId, u.firstname, u.lastname, u.address, u.dateofbirth, u.email, SUM(o.total) as total
    FROM happy_water.`user` u INNER JOIN happy_water.`order` o ON u.userId=o.userId
    GROUP BY u.userId
    ORDER BY total DESC LIMIT 5
</cfquery>

<cfquery name="qTop" result="top">
    select category.categoryName, sum(orderdetail.quantity) as quantity, sum(`orderdetail`.price) as total, `order`.orderDate
    from category left join product on category.categoryID = product.categoryID
    left join orderdetail on product.productID = orderdetail.productID
    left join `order` on `order`.orderID = orderdetail.orderID
    WHERE orderdetail.quantity is not null and orderDate BETWEEN DATE_SUB(CURDATE(), INTERVAL 7 DAY) AND CURDATE()
    group BY category.categoryName
    order by quantity desc
</cfquery>

<cfquery name="qBest" result="best">
    select product.productName, sum(orderdetail.quantity) as quantity, `order`.orderDate
    from product left join orderdetail on product.productID = orderdetail.productID
    left join `order` on `order`.orderID = orderdetail.orderID
    WHERE orderdetail.quantity is not null and orderDate BETWEEN DATE_SUB(CURDATE(), INTERVAL 7 DAY) AND CURDATE()
    group BY product.productID
    order by quantity desc
    limit 5
</cfquery>
<cfquery name="qBestDay" result="bestday">
    select product.productName, sum(orderdetail.quantity) as quantity, `order`.orderDate
    from product left join orderdetail on product.productID = orderdetail.productID
    left join `order` on `order`.orderID = orderdetail.orderID
    WHERE orderdetail.quantity is not null and orderDate BETWEEN DATE_SUB(CURDATE(), INTERVAL 1 DAY) AND CURDATE()
    group BY product.productID
    order by quantity desc
    limit 5
</cfquery>

<script language="javascript">
$(function () {
        $('##con1').highcharts({
            chart: {
                type: 'column'
            },
            title: {
                text: 'BestSeller in Week'
            },
            // subtitle: {
            //     text: 'Source: WorldClimate.com'
            // },
            xAxis: {
                categories: 
                [
                    <cfloop query="qBest">
                        '#qBest.productName#',
                    </cfloop>
                ]
            },
            yAxis: {
                min: 0,
                title: {
                    text: 'Quantity (Unit)'
                }
            },
            tooltip: {
                headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                    '<td style="padding:0"><b>{point.y:.1f} unit</b></td></tr>',
                footerFormat: '</table>',
                shared: true,
                useHTML: true
            },
            plotOptions: {
                column: {
                    pointPadding: 0.2,
                    borderWidth: 0
                }
            },
            series: [{
                name: 'Sale',
                data: 
                [
                    <cfloop query="qBest">
                        #qBest.quantity#,
                    </cfloop>
                ]
    
            }]
        });
    });

$(function () {
        $('##con2').highcharts({
            chart: {
                type: 'column'
            },
            title: {
                text: 'BestSeller in Day'
            },
            // subtitle: {
            //     text: 'Source: WorldClimate.com'
            // },
            xAxis: {
                categories: 
                [
                    <cfloop query="qBestDay">
                        '#qBestDay.productName#',
                    </cfloop>
                ]
            },
            yAxis: {
                min: 0,
                title: {
                    text: 'Quantity (Unit)'
                }
            },
            tooltip: {
                headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                    '<td style="padding:0"><b>{point.y:.1f} unit</b></td></tr>',
                footerFormat: '</table>',
                shared: true,
                useHTML: true
            },
            plotOptions: {
                column: {
                    pointPadding: 0.2,
                    borderWidth: 0
                }
            },
            series: [{
                name: 'Sale',
                data: 
                [
                    <cfloop query="qBestDay">
                        #qBestDay.quantity#,
                    </cfloop>
                ]
    
            }]
        });
    });
    $(function () {
    $('##con3').highcharts({
        chart: {
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false
        },
        title: {
            text: 'Top Group-Product in week'
        },
        tooltip: {
            pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
        },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: {
                    enabled: true,
                    format: '<b>{point.name}</b>: {point.percentage:.1f} %',
                    style: {
                        color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                    }
                }
            }
        },
        series: [{
            type: 'pie',
            name: 'Group-Product',
            
            data: 
            [
                <cfloop query="qTop">
                    ['#qTop.categoryName#', #qTop.quantity#],
                </cfloop>
            ]         
        }]
    });
});
</script>

<script language="javascript">
    $(function () {
        $('##user_product').highcharts({
            chart: {
                zoomType: 'xy'
            },
            title: {
                text: 'Statistic user and profit in current month'
            },
            subtitle: {
                text: 'Source: Happy-Water'
            },
            xAxis: [{
                categories: [
                <cfloop from="1" to="#DatePart('d', #Now()#)#" step="1" index="i">
                    #i#,
                </cfloop>

                ]
            }],
            yAxis: [{ // Primary yAxis
                labels: {
                    format: '{value}C',
                    style: {
                        color: Highcharts.getOptions().colors[1]
                    }
                },
                title: {
                    text: 'Profit',
                    style: {
                        color: Highcharts.getOptions().colors[1]
                    }
                }
            }, { // Secondary yAxis
                title: {
                    text: 'User',
                    style: {
                        color: Highcharts.getOptions().colors[0]
                    }
                },
                labels: {
                    format: '{value} User',
                    style: {
                        color: Highcharts.getOptions().colors[0]
                    }
                },
                opposite: true
            }],
            tooltip: {
                shared: true
            },
            legend: {
                layout: 'vertical',
                align: 'left',
                x: 120,
                verticalAlign: 'top',
                y: 100,
                floating: true,
                backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '##FFFFFF'
            },
            series: [{
                name: 'User',
                type: 'column',
                yAxis: 1,
                data: [<cfloop from="1" to="#day(#Now()#)#" index="k">
                    
                <cfquery name="count" result="result">
                    select * from user where DATE_FORMAT(RegisterDate,'%Y-%m-%d') = DATE_FORMAT(#createDate(#year(#Now()#)#,#month(#Now()#)#,#k#)#,'%Y-%m-%d')
                </cfquery>

                #result.RECORDCOUNT#,

                </cfloop>],
                tooltip: {
                    valueSuffix: ' user'
                }
    
            }, {
                name: 'Profit',
                type: 'spline',
                data: [
                    7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6

                      ],
                tooltip: {
                    valueSuffix: '°C'
                }
            }]
        });
    });
    </script>

<body>
    <div class="col-md-12 column">
        <div class="tabbable" id="tabs-111222">
            <ul class="nav nav-tabs">
                <li class="active">
                    <a href="##panel-123123" data-toggle="tab">BestSeller</a>
                </li>
                <li>
                    <a href="##panel-123456" data-toggle="tab">BestSeller in Week</a>
                </li>
                <li>
                    <a href="##panel-123789" data-toggle="tab">Top Group-Product</a>
                </li>
                <li>
                    <a href="##panel-test" data-toggle="tab">test</a>
                </li>
            </ul>
            <div class="tab-content">
                <div class="tab-pane active" id="panel-123123">
                    <div id="con2" style="width:900px; height:400px; margin: 0 auto"></div>
                </div>
                <div class="tab-pane" id="panel-123456">
                    <div id="con1" style="width:900px; height:400px; margin: 0 auto"></div>
                </div>
                <div class="tab-pane" id="panel-123789">
                    <div id="con3" style="min-width: 700px; height: 400px; max-width: 600px; margin: 0 auto"></div>
                </div>
                <div class="tab-pane" id="panel-test">
                    <div id="user_product" style="min-width: 700px; height: 400px; max-width: 600px; margin: 0 auto">
                    </div>

                   #year(#Now()#)#
                   #month(#Now()#)#
                   #day(#Now()#)#
                   #DateAdd('d', 2, #Now()#)#
                <!--- <cfloop from="1" to="#DatePart('d', #Now()#)#" step="1" index="i">
                    #i#,
                </cfloop>
                 --->
                #Dateformat(#now()#,"yyyy-mm-dd")#

                <!--- <cfloop from="1" to="#day(#Now()#)#" index="k">
                    
                <cfquery name="count" result="result">
                    select * from user where DATE_FORMAT(RegisterDate,'%Y-%m-%d') = DATE_FORMAT(#createDate(#year(#Now()#)#,#month(#Now()#)#,#k#)#,'%Y-%m-%d')
                </cfquery>

                #result.RECORDCOUNT#,

                </cfloop> --->
                #count.RegisterDate#
                
                #createDate("2014","04",29)#

                </div>
            </div>
        </div>
    </div>
    </body>
</cfoutput>