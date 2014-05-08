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

	<!--- Delete --->
	<cffunction
		name="delete"
		access="public"
		output="false">

		<cfargument name="productID" type="string" required="true">
		<cfif #productID# neq 0>
			<cftransaction isolation="serializable" action="begin">
			<cftry>
				<cfquery name="qDelete">
			        delete from product
			        where productID = <cfqueryparam value="#arguments.productID#" cfsqltype="cf_sql_integer">
	    		</cfquery>
				<cftransaction action="commit"/>
				<cfreturn true>

			<cfcatch>
				<cftransaction action="rollback"/>
				<cfreturn false>
			</cfcatch>
			</cftry>
			</cftransaction> 
		</cfif>
		
	</cffunction>

	<!--- Show all --->
	<cffunction name="showAll" access="public" output="false" returnformat="JSon">
		<cfquery name="qShowAll">
			SELECT *
			FROM product
			ORDER BY productID DESC
		</cfquery>

		<cfreturn qShowAll> 
	</cffunction>

	<!--- Get list category --->
	<cffunction name="getCategory" access="public" output="false" returntype="any">
		<cfquery name="qlstCategory">
			SELECT * 
			FROM Category
			WHERE tag = "product"
		</cfquery>

		<cfreturn qlstCategory> 
	</cffunction>

	<!--- Get list brand --->
	<cffunction name="getBrand" access="public" output="false" returntype="any">
		<cfquery name="qlstBrand">
			SELECT * 
			FROM Brand
			WHERE IsActive = 1
		</cfquery>

		<cfreturn qlstBrand> 
	</cffunction>

	<!--- Get product editing --->
	<cffunction name="getProductEditing" access="public" output="false" returntype="any">
		<cfargument name="productID" type="string" required="true">

		<cfquery name="qeditingproduct">
			SELECT *
			FROM Product
			WHERE productID = <cfqueryparam sqltype="cf_sql_integer" value="#arguments.productID#"/>
		</cfquery>

		<cfreturn qeditingproduct> 
	</cffunction>
<!--- Insert product --->
	<cffunction name="updateProduct" access="public" output="false" returntype="any">

		<cfargument name="rc" type="struct" required="true">
		<cfset desc = ReReplaceNoCase(#rc.description#, '<[^>]*>', '', "ALL")>
		<cfset text = ReReplaceNoCase(#rc.text#, '<[^>]*>', '', "ALL")>
		<cftransaction isolation="serializable" action="begin">
			<cftry>
				<cfquery name="update_product">
					UPDATE Product
					SET 
						productName = <cfqueryparam sqltype="varchar" value="#rc.productName#"/>,
						description = <cfqueryparam sqltype="clob" value="#desc#"/>,
						price = <cfqueryparam sqltype="float" value="#rc.price#"/>,
						discount = <cfqueryparam sqltype="integer" value="#rc.discount#"/>,
						originalprice = <cfqueryparam sqltype="float" value="#rc.originalprice#"/>,
						<cfif  NOT IsDefined('rc.status')>
							status = 0,
						<cfelse>
							status = <cfqueryparam sqltype="tinyint" value="#rc.status#"/>,
						</cfif>
						<cfif  NOT IsDefined('rc.IsActive')>
							IsActive = 0,
						<cfelse>
							IsActive = <cfqueryparam sqltype="tinyint" value="#rc.IsActive#"/>,
						</cfif>
						categoryID = <cfqueryparam sqltype="integer" value="#rc.categoryID#"/>,
						brandID = <cfqueryparam sqltype="integer" value="#rc.brandID#"/>,
						text = <cfqueryparam sqltype="clob" value="#text#"/>,
						productDate = <cfqueryparam sqltype="date" value="#now()#"/>
						<cfif rc.image is not "">
							,image = <cfqueryparam sqltype="varchar" value="#rc.image#"/>
						</cfif>
					WHERE productID = <cfqueryparam sqltype="integer" value="#rc.productID#"/>
				</cfquery>
				<cftransaction action="commit"/>
					<cfreturn true>
				<cfcatch>
					<cftransaction action="rollback"/>
					<cfreturn false>
				</cfcatch>
				</cftry>
		</cftransaction>
	</cffunction>

	<!--- Insert product --->
	<cffunction name="insertProduct" access="public" output="false" returntype="any">

		<cfargument name="rc" type="struct" required="true">


		<cfset desc = ReReplaceNoCase(#rc.description#, '<[^>]*>', '', "ALL")>
		<cfset text = ReReplaceNoCase(#rc.text#, '<[^>]*>', '', "ALL")>
		<cftransaction isolation="serializable" action="begin">
				<cftry>
					<cfquery name="insert_product" result="Result">

						INSERT INTO Product
						(
							productName,
							description,
							price,
							discount,
							originalprice,
							status,
							IsActive,
							categoryID,
							brandID,
							text,
							image,
							productDate
						)
						VALUES
						(
							<cfqueryparam sqltype="varchar" value="#rc.productName#"/>,
							<cfqueryparam sqltype="clob" value="#desc#"/>,
							<cfqueryparam sqltype="float" value="#rc.price#"/>,
							<cfqueryparam sqltype="integer" value="#rc.discount#"/>,
							<cfqueryparam sqltype="float" value="#rc.originalprice#"/>,
							<cfif  NOT IsDefined('rc.status')>
								<cfqueryparam sqltype="tinyint" value="0"/>,
							<cfelse>
								<cfqueryparam sqltype="tinyint" value="#rc.status#"/>,
							</cfif>
							<cfif  NOT IsDefined('rc.IsActive')>
								<cfqueryparam sqltype="tinyint" value="0"/>,
							<cfelse>
								<cfqueryparam sqltype="tinyint" value="#rc.IsActive#"/>,
							</cfif>
							<cfqueryparam sqltype="integer" value="#rc.categoryID#"/>,
							<cfqueryparam sqltype="integer" value="#rc.brandID#"/>,
							<cfqueryparam sqltype="clob" value="#text#"/>,
							<cfqueryparam sqltype="varchar" value="#rc.image#"/>,
							<cfqueryparam sqltype="date" value="#now()#">
						)
						</cfquery>

						<cftransaction action="commit"/>
					<cfreturn true>
				<cfcatch>
					<cftransaction action="rollback"/>
					<cfreturn false>
				</cfcatch>
				</cftry>
		</cftransaction>
		
	</cffunction>

	<!--- default --->
	<cffunction
		name="default"
		access="public"
		output="false">
		
		<cfargument name="rc" type="struct" required="true">

		<cfif isDefined("rc.productID")>
			<cfset rc.bDeleted = delete(rc.productID)>
		</cfif>

		<cfset rc.showAll = showAll()>

	</cffunction>


	<!--- editor --->
	<cffunction
		name="editor"
		access="public"
		output="false">
		
		<cfargument name="rc" type="struct" required="true">
		<cfset rc.lstCategory = getCategory()/>
		<cfset rc.lstBrand = getBrand()/>
		
		
		<!--- edit --->
		<cfif CGI.REQUEST_METHOD EQ 'get' AND rc.productID GT 0>
			<cfset rc.FormAction = "edit"/>
			<cfset rc.editingProduct = getProductEditing(rc.productID)>
		<!--- show --->
		<cfelseif CGI.REQUEST_METHOD EQ 'get' AND rc.productID EQ 0>
			<cfset rc.FormAction = "show"/>
		<!--- update --->
		<cfelseif CGI.REQUEST_METHOD EQ 'post' AND rc.productID GT 0>
			<cfset rc.FormAction = "update"/>
		<cfelse>
			<cfset rc.FormAction = "insert"/>
		</cfif>
		<!--- setview <cflocation url="#buildUrl('product.default')#"/> --->
	</cffunction>


</cfcomponent>