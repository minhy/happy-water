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
</cfoutput>

<!--- Script draw chart --->
<script language="javascript">
$(function () {
    var index = $("#xAxis").val().split(";");
    var values = $("#yAxis").val().split(";");
    for (i in values ) {
        values[i] = parseInt(values[i], 10);
    }
    console.log(index);
    console.log(values);

    $('#revenue').highcharts({
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
</script>
<cfoutput>
<body>
    <div class="row clearfix">        
        <div class="col-md-12 column">
            <!--- Use tab table --->
            <div class="tabbable" id="tabs-794103">
                <ul class="nav nav-tabs">
                    <li>
                        <a href="##panel-625444" data-toggle="tab">Revenue</a>
                    </li>
                    <li class="active">
                        <a href="##panel-932305" data-toggle="tab">Top Users</a>
                    </li>
                </ul>
                <!--- Tab contend --->
                <div class="tab-content">
                    <!--- Tab Revenue --->
                    <div class="tab-pane" id="panel-625444">
                        <div id="revenue" style="width:100%; height:400px;"></div>
                    </div>
                    <!--- Tab Top Users --->
                    <div class="tab-pane active" id="panel-932305">
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
    </div>  
</body>
</cfoutput>