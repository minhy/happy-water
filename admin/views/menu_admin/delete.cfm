<cftransaction isolation="serializable">
	<cfquery name="qDeleteMenu" >
		DELETE FROM menu
		WHERE menu_id = <cfqueryparam sqltype="integer" value="#URL.id#"/>
	</cfquery>
</cftransaction>

<cflocation url="#buildUrl('menu_admin')#" />