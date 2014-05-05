
<cftry>
	<cfset login="#getContextRoot()#/index.cfm/home:login"/>
	<cfif SESSION.UserID eq 0>
		<cflocation url=#login#/>
	</cfif>

	<cfif SESSION.Level neq 1 && 2>
		<cflocation url="#getContextRoot()#/index.cfm"/>
	</cfif>
	<cfcatch>
		<cflocation url=#login#/>
	</cfcatch>
</cftry>

<cfoutput>
	<center><img src="#getContextRoot()#/home/images/error.png"></center>
	<cfif structKeyExists( request, 'failedAction' )>
		<b>Action:</b> #request.failedAction#<br/>
	<cfelse>
		<b>Action:</b> unknown<br/>
	</cfif>
	<b>Error:</b> #request.exception.cause.message#<br/>
</cfoutput>