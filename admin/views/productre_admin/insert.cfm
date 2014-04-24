<cfoutput>
	
	<cfset productID = #URL.productID# />
	<cfset groupID = #URL.groupID# />
	<cfdump eval=URL>
	<cfset arrProductID = ListToArray(#productID#) />
	<cfdump eval=arrProductID>

	<cfloop index="i" from="1" to="#arrayLen(arrProductID)#">

<cftry>
		<cftransaction isolation="serializable">
			<cfquery name="qInsertProductRe" >
				insert  into product_re (productID,groupre_id) values
					(
						<cfqueryparam sqltype="integer" value="#arrProductID[i]#"/>,
						<cfqueryparam sqltype="varchar" value="#groupID#"/>
					)
			</cfquery>
		</cftransaction>
<cfcatch>
	<cftransaction action="rollback"/>
		
</cfcatch>

</cftry>

</cfloop>
 <cflocation url="#buildUrl('productre_admin')#" />

</cfoutput>
