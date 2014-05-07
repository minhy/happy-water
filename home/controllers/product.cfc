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

	<cffunction
		name="show"
		access="public"
		output="false">
		
		<cfargument name="rc" type="struct" required="true">

		<cfif NOT isDefined("rc.page")>
			<cfset rc.page = 1>
		</cfif>

		<cfif NOT isDefined("rc.select")>
			<cfset rc.select = "all">
		</cfif>

		<cfquery name="qSumColumn">
			select Count(productID) as dem
			from product where status = 1 and IsActive = 1
			order by productID
		</cfquery> 

		<cfquery name="qGetAll">
			select *
			from product where status = 1 and IsActive = 1
			limit #rc.page#,9
		</cfquery>  

		<cfquery name="qSumColumn1" >
			SELECT Count(productID) as dem
			FROM product
			WHERE productDate BETWEEN DATE_SUB(CURDATE(), INTERVAL 7 DAY) AND CURDATE() and status = 1 and IsActive = 1
			ORDER BY productID
		</cfquery> 

		<cfquery name="qGetByNew" >
			SELECT * 
			FROM product 
			WHERE productDate BETWEEN DATE_SUB(CURDATE(), INTERVAL 7 DAY) AND CURDATE() and status = 1 and IsActive = 1
			ORDER BY productDate DESC
			LIMIT #rc.page#,9
		</cfquery>  

		<cfquery name="qSumColumn2">
			SELECT Count(productID) as dem 
			FROM product
			WHERE discount <> 0  and status = 1 and IsActive = 1
			ORDER BY discount DESC 
		</cfquery> 

		<cfquery name="qGetByTopdeal">
			SELECT * 
			FROM product
			WHERE discount <> 0 and status = 1 and IsActive = 1
			ORDER BY discount DESC 
			LIMIT #rc.page#,9
		</cfquery>  

		<cfif rc.select eq "all">
		
			<cfset sumpage = ceiling(qSumColumn.dem/9)>
			<cfset querryGet=qGetAll>

		<cfelseif rc.select eq "new">

			<cfset sumpage = ceiling(qSumColumn1.dem/9)>
			<cfset querryGet=qGetByNew>

		<cfelse >
			<cfset sumpage = ceiling(qSumColumn2.dem/9)>
			<cfset querryGet=qGetByTopdeal>
		</cfif>


		<cfset rc.sumpage = sumpage>
		<cfset rc.querryGet = querryGet>

	</cffunction>
</cfcomponent>