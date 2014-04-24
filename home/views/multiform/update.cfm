<cfoutput>
	
<cftransaction isolation="serializable">
	<cfquery name="qUpdateUser" >
		update  user set groupre_id=<cfqueryparam sqltype="varchar" value="#URL.groupid#"/>
		WHERE userid = <cfqueryparam sqltype="integer" value="1"/>
	</cfquery>
</cftransaction>

<cflocation url="#getContextRoot()#"/>
</cfoutput>