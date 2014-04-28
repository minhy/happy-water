<cfoutput>
	<center><img src="#getContextRoot()#/home/images/error.png"></center>
	<cfif structKeyExists( request, 'failedAction' )>
	<p style="color:red">#request.exception.cause.message#</p>
	</cfif>
</cfoutput>