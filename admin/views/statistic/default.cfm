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

<!--- Prepair dataset for chart --->
<cfset Ox = "">
<cfset Oy = "">
<cfset index = 0>
<cfloop query="qGetRevenue">
    <cfset index = index + 1>
    <cfset Ox = Ox & #qGetRevenue.amonth# & ', ' & #qGetRevenue.ayear#>
    <cfset Oy = Oy & #qGetRevenue.total#>
    <cfif #index# NEQ #result.RECORDCOUNT#>
        <cfset Ox = Ox & ";">
        <cfset Oy = Oy & ";">
    </cfif>
</cfloop>

<!--- Use hidden type input for dataset saving and accessing it in JS --->
<input type="hidden" id="xAxis" value="#Ox#"> 
<input type="hidden" id="yAxis" value="#Oy#">


<!--- Script draw chart --->
<script language="javascript">
$(function () {
    var index = $("##xAxis").val().split(";");
    var values = $("##yAxis").val().split(";");
    for (i in values ) {
        values[i] = parseInt(values[i], 10);
    }
    console.log(index);
    console.log(values);

    $('##revenue').highcharts({
        chart: {
        },
        title: {
            text: 'Revenue Statistic'
        },
        xAxis: {
            categories: index
        },
        tooltip: {
            valueSuffix: 'USD'
        },
        labels: {
            items: [{
                html: ' Revenue consumption',
                style: {
                    left: '40px',
                    top: '8px',
                    color: 'black'
                }
            }]
        },
        series: [{
            name: 'Revenue',
            data: values
        }]
    });    
});
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
                    text: 'Quantity(unit)'
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
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false
        },
        title: {
            text: 'Top Group-Product Sell in week'
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

<body>
    <div class="row clearfix">        
        <div class="col-md-12 column">
            <!--- Use tab table --->
            <div class="tabbable" id="tabs-794103">
                <ul class="nav nav-tabs">
                    <li class="active">
                        <a href="##panel-625444" data-toggle="tab">Revenue</a>
                    </li>
                    <li>
                        <a href="##panel-932305" data-toggle="tab">Top Users</a>
                    </li>
                </ul>
                <!--- Tab contend --->
                <div class="tab-content">
                    <!--- Tab Revenue --->
                    <div class="tab-pane active" id="panel-625444">
                        <div id="revenue" style="width:100%; height:400px;"></div>
                    </div>
                    <!--- Tab Top Users --->
                    <div class="tab-pane" id="panel-932305">
                        <div class="container wrap main">
                            <table id="table_top_user" class="display">
                                <thead>
                                    <tr>
                                        <th>User ID</th>
                                        <th>First Name</th>
                                        <th>Last Name</th>
                                        <th>DOB</th>
                                        <th>Email</th>
                                        <th>Address</th>
                                        <th>Count</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <cfloop query="getUsers">
                                        <tr id="#getUsers.userID#" class="trr">
                                            <td>#getUsers.userID#</td>
                                            <td>#getUsers.firstname#</td>
                                            <td>#getUsers.lastname#</td>
                                            <td>#dateFormat(getUsers.dateofbirth, "short")#</td>
                                            <td>#getUsers.email#</td>
                                            <td>#getUsers.address#</td>
                                            <td>#getUsers.total# &dollar; </td>
                                        </tr>
                                    </cfloop>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>  <!--- End tab content --->
            </div>  <!--- End tab table --->
        </div>
        <div class="col-md-12 column">
            <div class="tabbable" id="tabs-111222">
                <ul class="nav nav-tabs">
                    <li class="active">
                        <a href="##panel-123123" data-toggle="tab">BestSeller</a>
                    </li>
                    <li>
                        <a href="##panel-123456" data-toggle="tab">Top Group-Product</a>
                    </li>
                </ul>
                <div class="tab-content">
                    <div class="tab-pane active" id="panel-123123">
                        <div id="con1" style="width:900px; height:400px; margin: 0 auto"></div>
                    </div>
                    <div class="tab-pane" id="panel-123456">
                        <div id="con2" style="min-width: 700px; height: 400px; max-width: 600px; margin: 0 auto"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>  
</body>
</cfoutput>
<cfdump eval=qTop>
<cfdump eval=qBest>