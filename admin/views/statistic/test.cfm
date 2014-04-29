<cfoutput>
<cfparam name="FORM.StartDate" default="#now()#">
<cfparam name="FORM.EndDate" default="#now()#">
<cfquery name="qGetOptionalRevenue" result="result">
    SELECT
    	day(orderDate) as aday,
    	monthname(orderDate) as amonth,
        year(orderDate) as ayear,
        SUM(total) as total
    FROM `happy_water`.`order`
    WHERE orderdate BETWEEN <cfqueryparam cfsqltype="string" value="#DateFormat(FORM.StartDate, "yyyy-mm-dd")#"> AND <cfqueryparam cfsqltype="string" value="#DateFormat(FORM.endDate, "yyyy-mm-dd")#">
    GROUP BY aday, amonth, ayear
    ORDER BY orderDate
</cfquery>

</cfoutput>
<script>
  $(function() {
    $( "#startDate" ).datepicker({
      defaultDate: "",
      changeMonth: true,
      changeYear: true,
      numberOfMonths: 1,
      onClose: function( selectedDate ) {
        $( "#endDate" ).datepicker( "option", "minDate", selectedDate );
      }
    });
    $( "#endDate" ).datepicker({
      defaultDate: "+1w",
      changeMonth: true,
      changeYear: true,
      numberOfMonths: 1,
      onClose: function( selectedDate ) {
        $( "#startDate" ).datepicker( "option", "maxDate", selectedDate );

      }
    });
  });
</script>
<cfoutput>
	<form method="Post">
		<label for="from">From</label>
		<input type="text" id="startDate" name="startDate">
		<label for="to">to</label>
		<input type="text" id="endDate" name="endDate">
		<input type ="Submit" value="submit">
	</form>

	<div id="optionalRevenue" style="min-width: 310px; height: 400px; margin: 0 auto"></div>


<script type="text/javascript">
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
</script>
</cfoutput>