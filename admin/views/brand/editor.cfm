
<cfparam name="FORM.brandID" type="integer" default="0"/>
<cfparam name="URL.brandID"	type="integer" default="0">
<cfparam name="FORM.status" type="string" default="0"/>
<cfparam name="FORM.IsActive" type="string" default="0"/>

<cfif CGI.REQUEST_METHOD EQ 'get' AND URL.brandID EQ 0>
	<cfset FormAction 	= "show"/>
<cfelseif CGI.REQUEST_METHOD EQ 'get' AND URL.brandID GT 0>
	<cfset FormAction = "edit"/>
<cfelseif CGI.REQUEST_METHOD EQ 'post' AND FORM.brandID GT 0>
	<cfset FormAction = "update"/>
<cfelse>
	<cfset FormAction = "insert"/>
</cfif>	

<cfparam name="Validation.brandName.text" default="&nbsp"/>
<cfparam name="Validation.brandName.class" default=""/>
<cfparam name="Validation.description.text" default="&nbsp"/>
<cfparam name="Validation.description.class" default=""/>
<cfparam name="Validation.status.class" default=""/>
<cfparam name="Validation.status.text" default="&nbsp"/>
<cfparam name="Validation.IsActive.class" default=""/>
<cfparam name="Validation.IsActive.text" default="&nbsp"/>

<cfset InvalidClass = "label label-warning"/>

<cfparam name="Validation.isValid" default="true"/>
            
<cfswitch expression="#FormAction#">
	<cfcase value="show">
		<cfparam name="FORM.brandName" type="string" default=""/>
		<cfparam name="FORM.description" type="string" default=""/>
		<cfparam name="FORM.status" type="string" default="0"/>
		<cfparam name="FORM.IsActive" type="string" default="0"/>
	</cfcase>
	<cfcase value="edit">
		
		<cfquery name="edit_brand">
			
			SELECT *
			FROM brand
			WHERE brandID = <cfqueryparam sqltype="integer" value="#URL.brandID#"/>

		</cfquery>
		<cfset FORM.brandID = edit_brand.brandID/>
		<cfset FORM.brandName = edit_brand.brandName/>
		<cfset FORM.description = edit_brand.description/>
		<cfset FORM.status = edit_brand.status/>
		<cfset FORM.IsActive = edit_brand.IsActive/>

	</cfcase>

	<cfcase value="insert">
		<cfif NOT IsDefined('FORM.brandName') OR Len(Trim(FORM.brandName)) GT 255 OR Len(Trim(FORM.brandName)) EQ 0>
			<cfset Validation.brandName.text = "Please provide a brand name with maximal 255 characters and not null."/>
			<cfset Validation.brandName.class = InvalidClass/>
			<cfset Validation.isValid = false/>
		</cfif>
		<cfif NOT IsDefined('FORM.description') OR Len(Trim(FORM.description)) GT 8000 OR Len(Trim(FORM.description)) EQ 0>
			<cfset Validation.description.text = "Please provide a description with maximal 255 characters and not null."/>
			<cfset Validation.description.class = InvalidClass/>
			<cfset Validation.isValid = false/>
		</cfif>
		<cfif Validation.isValid>
			<cfset desc = ReReplaceNoCase(#FORM.description#, '<[^>]*>', '', "ALL")>
			<cftransaction isolation="serializable" action="begin">
					<cftry>
						<cfquery name="insert_brand">
							INSERT INTO brand
							(
								brandName,
								description,
								status,
								IsActive
							)
							VALUES
							(
								<cfqueryparam sqltype="varchar" value="#FORM.brandName#"/>,
								<cfqueryparam sqltype="clob" value="#desc#"/>,
								<cfif  NOT IsDefined('FORM.status')>
									<cfqueryparam sqltype="tinyint" value="0"/>,
								<cfelse>
									<cfqueryparam sqltype="tinyint" value="#FORM.status#"/>,
								</cfif>
								<cfif  NOT IsDefined('FORM.IsActive')>
									<cfqueryparam sqltype="tinyint" value="0"/>
								<cfelse>
									<cfqueryparam sqltype="tinyint" value="#FORM.IsActive#"/>
								</cfif>
							)
							</cfquery>
						<cftransaction action="commit"/>
						<cflocation url="#buildUrl('brand.default')#"/>
					<cfcatch>
						<cftransaction action="rollback"/>
						<cfdump var="#cfcatch#"/><cfabort>
					</cfcatch>

					</cftry>
			</cftransaction>
		</cfif>
	</cfcase>

	<cfcase value="update">
		<cfif NOT IsDefined('FORM.brandName') OR Len(Trim(FORM.brandName)) GT 255 OR Len(Trim(FORM.brandName)) EQ 0>
			<cfset Validation.brandName.text = "Please provide a brand name with maximal 255 characters and not null."/>
			<cfset Validation.brandName.class = InvalidClass/>
			<cfset Validation.isValid = false/>
		</cfif>
		<cfif NOT IsDefined('FORM.description') OR Len(Trim(FORM.description)) GT 8000 OR Len(Trim(FORM.description)) EQ 0>
			<cfset Validation.description.text = "Please provide a description with maximal 255 characters and not null."/>
			<cfset Validation.description.class = InvalidClass/>
			<cfset Validation.isValid = false/>
		</cfif>
		<cfif Validation.isValid>
			<cfset desc = ReReplaceNoCase(#FORM.description#, '<[^>]*>', '', "ALL")>
			<cftransaction isolation="serializable" action="begin">
				<cftry>
					
					<cfquery name="update_brand">

						UPDATE brand
						SET 
							brandName = <cfqueryparam sqltype="varchar" value="#FORM.brandName#"/>,
							description = <cfqueryparam sqltype="clob" value="#desc#"/>,
							<cfif  NOT IsDefined('FORM.status')>
								status = 0,
							<cfelse>
								status = <cfqueryparam sqltype="tinyint" value="#FORM.status#"/>,
							</cfif>
							<cfif  NOT IsDefined('FORM.IsActive')>
								IsActive = 0
							<cfelse>
								IsActive = <cfqueryparam sqltype="tinyint" value="#FORM.IsActive#"/>
							</cfif>
						WHERE brandID = <cfqueryparam sqltype="integer" value="#FORM.brandID#"/>
					</cfquery>
					<cftransaction action="commit"/>
					<cflocation url="#buildUrl('brand.default')#"/>
				<cfcatch>
					<cftransaction action="rollback"/>
					<cfdump var="#cfcatch#"/><cfabort>
				</cfcatch>
				</cftry>
			</cftransaction>
		</cfif>
	</cfcase>
</cfswitch>

<cfoutput>
<br>
<legend><h1>Brand Management - Update</h1></legend>
<div  style="width:100%; margin:auto;">
	<div class="row clearfix">
		<cfif NOT Validation.isValid>
			<div class="alert alert-dange">
				<h3>Oops! Could not save new brand</h3>
			</div>
		</cfif>
	</div>
<form  method="post"  enctype="multipart/form-data">

		<div class="row clearfix">
			<div class="col-md-12 column">
				<div class="row clearfix">
					<div class="col-md-4 column" style="border-right: 1px solid brown;">
						<input type="hidden" name="brandID" value="#FORM.brandID#"/>
						<!--- brand Name --->
						<label for="brandName">Brand Name</label>
						<div class="#Validation.brandName.class#">
							#Validation.brandName.text#
						</div>
						<div class="form-group">
							 <input type="text" class="form-control" id="brandName" name="brandName" value="#FORM.brandName#"/>
						</div>
						<div class="row clearfix">
							<div class="col-md-6 column">
								<!--- Status --->
								<label for="status">Status</label>
								<div class="#Validation.status.class#">
									#Validation.status.text#
								</div>
								<div class="form-group">
								        <input type="checkbox" id="status" name="status" value="1" <cfif FORM.status> checked</cfif>> New
								</div>
							</div>
							<div class="col-md-6 column">
								<!--- Is Active --->
								<label for="IsActive">Is Active</label>
								<div class="#Validation.IsActive.class#">
									#Validation.IsActive.text#
								</div>
								<div class="form-group">
								        <input type="checkbox" id="IsActive" name="IsActive" value="1" <cfif FORM.IsActive> checked</cfif>> Selling
								</div>
							</div>
						</div>
					</div>
	
					<div class="col-md-8 column">
						<!--- Description --->
						<label for="description">Description</label>
						<div class="#Validation.description.class#">
							#Validation.description.text#
						</div>
						<div class="form-group">
							 <textarea type="text" required="yes" class="form-control" id="description" name="description" style="margin: 0px -13.4375px 0px 0px; width: 100%; height: 130px;">#FORM.description#</textarea>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="div_center">
			<div class="alert alert-info">
				<button type="submit" class="btn btn-default btn_center">Submit</button>
			</div>
		</div>
</form>
</div>
</cfoutput>
