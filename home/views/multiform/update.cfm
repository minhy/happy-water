<cfoutput>
	<cfdump eval=SESSION.userID/>
<cftransaction isolation="serializable">
	<cfquery name="qUpdateUser" >
		update  user set groupre_id=<cfqueryparam sqltype="varchar" value="#URL.groupid#"/>
		WHERE userid = <cfqueryparam sqltype="integer" value="#SESSION.userID#"/>
	</cfquery>
</cftransaction>

 <cflocation url="#getContextRoot()#/index.cfm/"/> 
</cfoutput>