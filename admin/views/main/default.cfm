
<cfquery name="qUser" result="qUser">
    SELECT userID FROM USER 
</cfquery>
<cfquery name="qProduct" result="qProduct">
    SELECT productID FROM PRODUCT 
</cfquery>
<cfquery name="qArticle" result="qArticle">
    SELECT article_id FROM ARTICLE 
</cfquery>
<cfquery name="qProfit">
    select adate, SUM((oprice - iprice) * aquantity) as profit 
    from (select 
        product.productID as pro,
        product.originalprice as iprice, 
        orderdetail.price as oprice, 
        sum(orderdetail.quantity) as aquantity,
        `order`.`orderDate` as adate
    from product left join orderdetail on product.productID = orderdetail.productID left join `order` on `order`.orderID = orderdetail.orderID
    WHERE orderdetail.quantity is not null
    group BY product.productID) as demo
</cfquery>
<head>
<style>
.statis {
  margin: 10px 10px 10px 0px;
  font-family: Helvetica;
  font-size: 20px;
  background: linear-gradient(#F9F9F9, #C7C7C4);
  border:1px solid;
  border-radius: 20px;
  box-shadow: 5px 5px 5px #888888;
  text-align: center;
}
.statis img {
    margin: 10px 10px 10px 10px;
    width: 70px;
    height: 70px;
}

</style>

<cfoutput>

<script language="javascript">
    $(function () {
        $('##user_product_last').highcharts({
            chart: {
                zoomType: 'xy'
            },
            title: {
                text: 'Statistic user and profit in last          month'
            },
            subtitle: {
                text: 'Source: Happy-Water'
            },
            xAxis: [{
                categories: [
                <cfloop from="1" to="#DaysInMonth(#DateAdd('m', -1, #Now()#)#)#" step="1" index="i">
                    #i#,
                </cfloop>

                ]
            }],
            yAxis: [{ // Primary yAxis
                labels: {
                    format: '{value}$',
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
                type: 'spline',
                yAxis: 1,
                data: [<cfloop from="1" to="#DaysInMonth(#DateAdd('m', -1, #Now()#)#)#" index="k">
                    
                <cfquery name="count" result="result">
                    select * from user where DATE_FORMAT(RegisterDate,'%Y-%m-%d') = DATE_FORMAT(#createDate(#year(#Now()#)#,#month(#Now()#)#-1,#k#)#,'%Y-%m-%d')
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
                <cfloop from="1" to="#DaysInMonth(#DateAdd('m', -1, #Now()#)#)#" index="p">
                        <cfquery name="profit">
                    select SUM((aprice - oprice) * aquantity) as atotal 
from 
(select 
product.productID as aid, 
product.originalprice as oprice, 
orderdetail.price as aprice, 
sum(orderdetail.quantity) as aquantity, 
`order`.orderDate as oday
from product left join orderdetail on product.productID = orderdetail.productID left join `order` on `order`.orderID = orderdetail.orderID
WHERE orderdetail.quantity is not null and orderDate = DATE_FORMAT(#createDate(#year(#Now()#)#,#month(#Now()#)#-1,#p#)#,'%Y-%m-%d')
group BY product.productID) as demo
                </cfquery>
                <cfif #profit.atotal# EQ "">
                0,
                <cfelse>   
                #profit.atotal#, 
                </cfif>
                </cfloop>

                      ],
                tooltip: {
                    valueSuffix: '$'
                }
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
                text: 'Statistic user and profit in this month'
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
                    format: '{value}$',
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
                type: 'spline',
                yAxis: 1,
                data: [<cfloop from="1" to="#day(#Now()#)#" index="k">
                    //#DaysInMonth(#DateAdd('m', 1, #Now()#)#)#
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
                <cfloop from="1" to="#day(#Now()#)#" index="p">
                        <cfquery name="profit">
                    select SUM((aprice - oprice) * aquantity) as atotal 
from 
(select 
product.productID as aid, 
product.originalprice as oprice, 
orderdetail.price as aprice, 
sum(orderdetail.quantity) as aquantity, 
`order`.orderDate as oday
from product left join orderdetail on product.productID = orderdetail.productID left join `order` on `order`.orderID = orderdetail.orderID
WHERE orderdetail.quantity is not null and orderDate = DATE_FORMAT(#createDate(#year(#Now()#)#,#month(#Now()#)#,#p#)#,'%Y-%m-%d')
group BY product.productID) as demo
                </cfquery>
                <cfif #profit.atotal# EQ "">
                0,
                <cfelse>   
                #round(#profit.atotal#)#, 
                </cfif>
                </cfloop>

                      ],
                tooltip: {
                    valueSuffix: '$'
                }
            }]
        });
    });
    </script>


<body>
    <legend><h1>Dashboard</h1></legend>
    <div class="col-md-12 column">
        <div class="tabbable col-md-9 column" id="tabs-111222">
            <ul class="nav nav-tabs">
                <li class="active">
                    <a href="##panel-current" data-toggle="tab">Statistic current month</a>
                </li>
                <li>
                    <a href="##panel-last" data-toggle="tab">Statistic last month</a>
                </li>
            </ul>
            <div class="tab-content">
                <div class="tab-pane active" id="panel-current">
                    <div id="user_product" style="min-width: 700px; height: 400px; max-width: 600px; margin: 0 auto"> </div>
                </div>

                <div class="tab-pane" id="panel-last">
                    <div id="user_product_last" style="min-width: 700px; height: 400px; max-width: 600px; margin: 0 auto"></div>


                </div>

                  <!---  #year(#Now()#)#
                   #month(#Now()#)#
                   #day(#Now()#)#
                   #DateAdd('d', 2, #Now()#)# --->
                <!--- <cfloop from="1" to="#DatePart('d', #Now()#)#" step="1" index="i">
                    #i#,
                </cfloop>
                 --->
               <!---  #Dateformat(#now()#,"yyyy-mm-dd")# --->

                <!--- <cfloop from="1" to="#day(#Now()#)#" index="k">
                    
                <cfquery name="count" result="result">
                    select * from user where DATE_FORMAT(RegisterDate,'%Y-%m-%d') = DATE_FORMAT(#createDate(#year(#Now()#)#,#month(#Now()#)#,#k#)#,'%Y-%m-%d')
                </cfquery>

                #result.RECORDCOUNT#,

                </cfloop> --->
                
                
                
                <!--- <cfdump eval = profit> --->
               <!---  #count.RegisterDate#
                
                #createDate("2014","04",29)# --->

            </div>
        </div>
        <div class="col-md-3 column">
                <div class="statis">
                    <img title="User" src="#getContextRoot()#/images/dashboard/user.png"  />#qUser.RECORDCOUNT#
                </div>
                <div class="statis">
                    <img title="Profit" src="#getContextRoot()#/images/dashboard/dollar.png" />#Round(#qProfit.profit#)#
                </div>
                <div class="statis">
                    <img title="Product" src="#getContextRoot()#/images/dashboard/shopping.png" />#qProduct.RECORDCOUNT#
                </div>
                <div class="statis">
                    <img title="Article" src="#getContextRoot()#/images/dashboard/article.png" />#qArticle.RECORDCOUNT#
                </div>
            </div>
    </div>

    </body>
</cfoutput>