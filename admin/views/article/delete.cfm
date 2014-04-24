<cftransaction isolation="serializable">
	<cfquery name="qDeleteArticle" >
		DELETE FROM Article
		WHERE Article_id = <cfqueryparam sqltype="integer" value="#URL.id#"/>
	</cfquery>
</cftransaction>

<cflocation url="#buildUrl('article')#" />