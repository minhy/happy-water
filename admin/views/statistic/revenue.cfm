<cfoutput>
<!--- Get general revenue statistic (by year) --->
<cfquery name="qGetYearRevenue" result="result">
    SELECT year(orderdate) as year, SUM(total) as total
    FROM happy_water.`order`
    GROUP BY year
</cfquery>

<!--- Get monthtly revenue statistic --->
<cfquery name="qGetYearRevenue" result="result">
    SELECT year(orderdate) as year, SUM(total) as total
    FROM happy_water.`order`
    GROUP BY year
</cfquery>

<!--- Get daily revenue statistic --->
<cfquery name="qGetYearRevenue" result="result">
    SELECT year(orderdate) as year, SUM(total) as total
    FROM happy_water.`order`
    GROUP BY year
</cfquery>

<cfset Ox = "">
<cfset Oy = "">
<cfset index = 0>
<cfloop query="qGetYearRevenue">
    <cfset index = index + 1>
    <cfset Ox = Ox & #qGetYearRevenue.year#>
    <cfset Oy = Oy & #qGetYearRevenue.total#>
    <cfif #index# NEQ #result.RECORDCOUNT#>
        <cfset Ox = Ox & ",">
        <cfset Oy = Oy & ",">
    </cfif>
</cfloop>

<input type="hidden" id="xAxis" value="#Ox#"> 
<input type="hidden" id="yAxis" value="#Oy#">

</cfoutput>

<script language="javascript">
$(function () {
    var index = $("#xAxis").val().split(",");
    var values = $("#yAxis").val().split(",");
    for (i in values ) {
        values[i] = parseInt(values[i], 10);
    }
    console.log(index);
    console.log(values);

    $('#foryear').highcharts({
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
<body>
	<div class="row clearfix">
        <div class="col-md-12 column">
            <div class="tabbable" id="tabs-794103">
                <ul class="nav nav-tabs">
                    <li>
                        <a href="##panel-625444" data-toggle="tab">Revenue for year</a>
                    </li>
                    <li class="active">
                        <a href="##panel-932305" data-toggle="tab">Revenue for month</a>
                    </li>
                    <li >
                        <a href="##panel-932300" data-toggle="tab">Revenue for day</a>
                    </li>
                </ul>
                <div class="tab-content">
                    <div class="tab-pane" id="panel-625444">
                        <div id="con1" style="width:800px; height:400px;">
                            <div id="foryear" style="width:100%; height:400px;"></div>
                        </div>
                    </div>
                    <div class="tab-pane active" id="panel-932305">
                        <div id="formonth" style="width:100%; height:400px;"></div>
                    </div>
                    <div class="tab-pane" id="panel-932300">
                        <div id="forday" style="width:100%; height:400px;"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>