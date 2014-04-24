<cfoutput>	
	<cfif #URL.act# is "bans">
		<cfquery name="bans">
			UPDATE user
			SET level = 0
			WHERE userID = <cfqueryparam cfsqltype="int" value="#URL.id#">
		</cfquery>
	</cfif>

	<cfif #URL.act# is "unbans">
		<cfquery name="unbans">
			UPDATE user
			SET level = 3
			WHERE userID = <cfqueryparam cfsqltype="int" value="#URL.id#">
		</cfquery>
	</cfif>

	<cfif #URL.act# is "setadmin">
		<cfquery name="setadmin">
			UPDATE user
			SET level = 2
			WHERE userID = <cfqueryparam cfsqltype="int" value="#URL.id#">
		</cfquery>
	</cfif>

	<cflocation addtoken="false" url="#getContextRoot()#/index.cfm/admin:user/">
</cfoutput>