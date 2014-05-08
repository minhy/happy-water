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
		name="deleteBrand"
		access="public"
		output="false">

		<cfargument name="brandID" type="numeric" required="true">
		<cftransaction>
		<cftry>
            <cfif #brandID# neq 0>
        		<cfquery name="qDelete">
                    delete from brand
                    where brandID = <cfqueryparam value="#arguments.brandID#" cfsqltype="cf_sql_integer">
                </cfquery>
        		<cftransaction action="commit"/>
                <cfreturn true>
            </cfif>
            <cfcatch>
            	<cftransaction action="rollback"/>
                <cfreturn false>
            </cfcatch>    
        </cftry>
        </cftransaction>
		
	</cffunction>


	<cffunction
		name="default"
		access="public"
		output="false">
		
		<cfif isDefined("rc.brandID")>
			<cfset rc.bDeleted = deleteBrand(rc.brandID)>
		</cfif>

	    <cfquery name="qShowAll">
		    SELECT *
		    FROM brand
		    ORDER BY brandID DESC
	    </cfquery>    
    
		<cfset rc.listbrand = qShowAll>

	</cffunction>

</cfcomponent>