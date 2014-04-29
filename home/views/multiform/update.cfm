<cfoutput>
	
<cftransaction isolation="serializable">
	<cfquery name="qUpdateUser" >
		update  user set groupre_id=<cfqueryparam sqltype="varchar" value="#URL.groupid#"/>
		WHERE userid = <cfqueryparam sqltype="integer" value="#SESSION.userID#"/>
	</cfquery>
</cftransaction>

<cfif #URL.groupid# eq "0">
		 <cflocation url="#getContextRoot()#/index.cfm"/> 
	<cfelse>
		 <cflocation url="#buildUrl('product.recommend')#"/> 
</cfif>

</cfoutput>