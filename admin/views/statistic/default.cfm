<cfoutput>
<!--- Get the general revenue statistic --->
<cfquery name="qGetRevenue" result="result">
    SELECT monthname(orderDate) as amonth,
         year(orderDate) as ayear,
         SUM(total) as total
    FROM `order`
    WHERE orderdate BETWEEN DATE_SUB(CURDATE(), INTERVAL 12 MONTH) AND CURDATE()
    GROUP BY amonth, ayear
    ORDER BY orderDate
</cfquery>

<!--- Get the top 5 users have highest sum of value in order  --->
<cfquery name="qGetUsers">
    SELECT u.userId, u.firstname, u.lastname, u.address, u.dateofbirth, u.email, SUM(o.total) as total
    FROM `user` u INNER JOIN `order` o ON u.userId=o.userId
    GROUP BY u.userId
    ORDER BY total DESC LIMIT 5
</cfquery>

<!--- Get revenue statistic on the range chosen by user --->
<cfparam name="FORM.StartDate" default="#now()#">
<cfparam name="FORM.EndDate" default="#now()#">
<cfquery name="qGetOptionalRevenue">
    SELECT
        day(orderDate) as aday,
        monthname(orderDate) as amonth,
        year(orderDate) as ayear,
        SUM(total) as total
    FROM `order`
    WHERE orderdate BETWEEN <cfqueryparam cfsqltype="string" value="#DateFormat(FORM.StartDate, "yyyy-mm-dd")#"> AND <cfqueryparam cfsqltype="string" value="#DateFormat(FORM.EndDate, "yyyy-mm-dd")#">
    GROUP BY aday, amonth, ayear
    ORDER BY orderDate
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

<!--- Script draw chart --->
<script language="javascript">
$(function () {
    $('##revenue').highcharts({
        chart: {
        },
        title: {
            text: 'Revenue Statistic'
        },
        xAxis: {
            categories: [
                <cfloop query="qGetRevenue">
                    '#qGetRevenue.amonth#' + ', ' + '#qGetRevenue.ayear#',
                </cfloop>
            ]
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
            data: [
                <cfloop query="qGetRevenue">
                    #qGetRevenue.total#,
                </cfloop>
            ]
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
$(function () {
    $('##optionalRevenue').highcharts({
        chart: {
            type: 'column'
        },
        title: {
            text: 'Revenue'
        },
        xAxis: {
            categories: [
                <cfloop query="qGetOptionalRevenue">
                    '#qGetOptionalRevenue.amonth#' + ' ' + '#qGetOptionalRevenue.aday#' + ', ' + '#qGetOptionalRevenue.ayear#',
                </cfloop>
            ]
        },
        yAxis: {
            min: 0,
            title: {
                text: 'Revenue ($)'
            }
        },
        tooltip: {
            headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
            pointFormat: 
                '<td style="padding:0"><b>{point.y:.1f} $</b></td></tr>',
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
            name: '#qGetOptionalRevenue.amonth#' + ' ' + '#qGetOptionalRevenue.aday#' + ', ' + '#qGetOptionalRevenue.ayear#',
            data: [
                <cfloop query="qGetOptionalRevenue">
                    #qGetOptionalRevenue.total#,
                </cfloop>
            ]    
        }]
    });
});

$(document).ready(function(){
    $('##table_top_user').dataTable({
    "sPaginationType": "full_numbers"
    });
    $( "##startDate" ).datepicker({
        defaultDate: "",
        changeMonth: true,
        changeYear: true,
        numberOfMonths: 1,
        onClose: function( selectedDate ) {
        $( "##endDate" ).datepicker( "option", "minDate", selectedDate );
        }
    });
    $( "##endDate" ).datepicker({
        defaultDate: "+1w",
        changeMonth: true,
        changeYear: true,
        numberOfMonths: 1,
        onClose: function( selectedDate ) {
        $( "##startDate" ).datepicker( "option", "maxDate", selectedDate );
        }
    });
    $("##butSub").click(function(){
        $("##p11").removeClass("active");
        $("##panel-625444").removeClass("active");
        $("##p21").addClass("active");
        $("##panel-111111").addClass("active");
    });
});
</script>
<style>
    table, td, th
    {
        border:1px solid black;
    }
    th
    {
        background-color:black;
        color:white;
    }
</style>
<body>
    <div class="row clearfix">        
        <div class="col-md-12 column">
            <!--- Use tab table --->
            <div class="tabbable" id="tabs-794103">
                <ul class="nav nav-tabs">
                    <li id="p11">
                        <a href="##panel-625444" data-toggle="tab">Revenue</a>
                    </li>
                    <li>
                        <a href="##panel-932305" data-toggle="tab">Top Users</a>
                    </li>
                    <li id="p21" class="active">
                        <a href="##panel-111111" data-toggle="tab">Optional Statistic</a>
                    </li>
                </ul>
                <!--- Tab contend --->
                <div class="tab-content">
                    <!--- Tab Revenue --->
                    <div class="tab-pane " id="panel-625444">
                        <div id="revenue" style="width:100%; height:400px;"></div>
                    </div>
                    <!--- Tab Top Users --->
                    <div class="tab-pane" id="panel-932305">
                        <div class="container wrap main">
                            <table id="table_top_user" class="display">
                                <thead style="background-color: black;">
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
                                    <cfloop query="qGetUsers">
                                        <tr id="#qGetUsers.userID#" class="trr">
                                            <td>#qGetUsers.userID#</td>
                                            <td>#qGetUsers.firstname#</td>
                                            <td>#qGetUsers.lastname#</td>
                                            <td>#dateFormat(qGetUsers.dateofbirth, "short")#</td>
                                            <td>#qGetUsers.email#</td>
                                            <td>#qGetUsers.address#</td>
                                            <td>#qGetUsers.total# &dollar; </td>
                                        </tr>
                                    </cfloop>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="tab-pane active" id="panel-111111">
                        <br>
                        <form method="Post">
                            <label for="from">From</label>
                            <input type="text" id="startDate" name="startDate">
                            <label for="to">to</label>
                            <input type="text" id="endDate" name="endDate">
                            <input type ="Submit" value="Submit">
                        </form>
                        <div id="optionalRevenue" style="min-width: 310px; height: 400px; margin: 0 auto"></div>
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
                        <a href="##panel-123456" data-toggle="tab">BestSeller in Week</a>
                    </li>
                    <li>
                        <a href="##panel-123789" data-toggle="tab">Top Group-Product</a>
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
                </div>
            </div>
        </div>
    </div>  
</body>
</cfoutput>