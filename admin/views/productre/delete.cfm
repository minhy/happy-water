

<cftransaction isolation="serializable">
	<cfquery name="qDeleteProductRe" >
		DELETE FROM Product_re
		WHERE productID = <cfqueryparam sqltype="integer" value="#URL.productID#"/>
		and groupre_id = <cfqueryparam sqltype="varchar" value="#URL.GroupReID#"/>
	</cfquery>
</cftransaction>

<cflocation url="#buildUrl('productre')#" />