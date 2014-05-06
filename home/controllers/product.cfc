<cfcomponent>
	<cffunction
		name="init"
	    access="public"
	    output="false">

		<cfargument name="fw" required="true" type="any">
		
		<cfscript>
			variables.fw = arguments.fw;
			return this;
		</cfscript>
	</cffunction>

	<cffunction
		name="default"
		access="public"
		output="false">
		
		<cfargument name="rc" type="struct" required="true">

		<cfif NOT isDefined("rc.page")>
			<cfset rc.page = 1>
		</cfif>

		<cfquery name="qGetAll" >

			select *
			from product where status = 1 and IsActive = 1
			limit #rc.page#,9

		</cfquery>

		<cfquery name="qSumRecord">

			select Count(productID) as dem
			from product where status = 1 and IsActive = 1
			order by productID

		</cfquery> 

		<cfset rc.products = qGetAll>
		<cfset rc.sumrecord = qSumRecord>

	</cffunction>
</cfcomponent>