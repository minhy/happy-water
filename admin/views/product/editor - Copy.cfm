<cfparam name="FORM.image" type="string" default=""/>

<cfquery name="lstCategory">
	SELECT * 
	FROM Category
	WHERE tag = "product"
</cfquery>
<cfquery name="lstBrand">
	SELECT * 
	FROM Brand
</cfquery>

<cfparam name="FORM.productID"	type="integer" default="0"/>
<cfparam name="URL.productID"	type="integer" default="0">

<cfif CGI.REQUEST_METHOD EQ 'get' AND URL.productID EQ 0>
	<cfset FormAction 	= "show"/>
<cfelseif CGI.REQUEST_METHOD EQ 'get' AND URL.productID GT 0>
	<cfset FormAction = "edit"/>
<cfelseif CGI.REQUEST_METHOD EQ 'post' AND FORM.productID GT 0>
	<cfset FormAction = "update"/>
<cfelse>
	<cfset FormAction = "insert"/>
</cfif>	

<cfparam name="Validation.productName.text" default="&nbsp"/>
<cfparam name="Validation.productName.class" default=""/>
<cfparam name="Validation.description.text" default="&nbsp"/>
<cfparam name="Validation.description.class" default=""/>
<cfparam name="Validation.price.class" default=""/>
<cfparam name="Validation.price.text" default=""/>
<cfparam name="Validation.originalprice.class" default=""/>
<cfparam name="Validation.originalprice.text" default=""/>
<cfparam name="Validation.categoryID.class" default=""/>
<cfparam name="Validation.categoryID.text" default="&nbsp"/>
<cfparam name="Validation.brandID.class" default=""/>
<cfparam name="Validation.brandID.text" default="&nbsp"/>
<cfparam name="Validation.image.class" default=""/>
<cfparam name="Validation.image.text" default="&nbsp"/>
<cfparam name="Validation.status.class" default=""/>
<cfparam name="Validation.status.text" default="&nbsp"/>
<cfparam name="Validation.IsActive.class" default=""/>
<cfparam name="Validation.IsActive.text" default="&nbsp"/>

<cfset InvalidClass = "label label-warning"/>

<cfparam name="Validation.isValid" default="true"/>
            
<cfswitch expression="#FormAction#">
	<cfcase value="show">
		<cfparam name="FORM.productName" type="string" default=""/>
		<cfparam name="FORM.description" type="string" default=""/>
		<cfparam name="FORM.price" type="float" default="0"/>
		<cfparam name="FORM.originalprice" type="float" default="0"/>
		<cfparam name="FORM.discount" type="numeric" default="0"/>
		<cfparam name="FORM.status" type="boolean" default="0"/>
		<cfparam name="FORM.IsActive" type="boolean" default="0"/>
		<cfparam name="FORM.categoryID" type="string" default="0"/>
		<cfparam name="FORM.brandID" type="string" default="0"/>
		<cfparam name="FORM.text" type="string" default=""/>
		<cfparam name="FORM.image" type="string" default=""/>
	</cfcase>
	<cfcase value="edit">
		
		<cfquery name="edit_product">
			
			SELECT *
			FROM Product
			WHERE productID = <cfqueryparam sqltype="integer" value="#URL.productID#"/>

		</cfquery>
		<cfset FORM.productID = edit_product.productID/>
		<cfset FORM.productName = edit_product.productName/>
		<cfset FORM.description = edit_product.description/>
		<cfset FORM.price = edit_product.price/>
		<cfset FORM.originalprice = edit_product.originalprice/>
		<cfset FORM.discount = edit_product.discount/>
		<cfset FORM.status = edit_product.status/>
		<cfset FORM.IsActive = edit_product.IsActive/>
		<cfset FORM.categoryID = edit_product.categoryID/>
		<cfset FORM.brandID = edit_product.brandID/>
		<cfset FORM.text = edit_product.text/>
		<cfset FORM.image =edit_product.image/>

	</cfcase>

	<cfcase value="insert">
		<cfif isDefined("FORM.image")>
			<cfif FORM.image is not "">
				<cffile action = "upload" 
						nameconflict = "unique" 
						result="Reupload"
				        fileField = "image" 
				        destination = "#getContextRoot()#/images/product/">
			</cfif>
		</cfif>
		<cfif NOT IsDefined('FORM.productName') OR Len(Trim(FORM.productName)) GT 255 OR Len(Trim(FORM.productName)) EQ 0>
			<cfset Validation.productName.text = "Please provide a product name with maximal 255 characters and not null."/>
			<cfset Validation.productName.class = InvalidClass/>
			<cfset Validation.isValid = false/>
		</cfif>
		<cfif NOT IsDefined('FORM.description') OR Len(Trim(FORM.description)) GT 8000 OR Len(Trim(FORM.description)) EQ 0>
			<cfset Validation.description.text = "Please provide a description with maximal 255 characters and not null."/>
			<cfset Validation.description.class = InvalidClass/>
			<cfset Validation.isValid = false/>
		</cfif>
		<cfif NOT IsDefined('FORM.price') OR Len(Trim(FORM.price)) EQ 0>
			<cfset Validation.price.text = "Please provide a price with not null."/>
			<cfset Validation.price.class = InvalidClass/>
			<cfset Validation.isValid = false/>
		</cfif>

		<cfif NOT IsDefined('FORM.originalprice') OR Len(Trim(FORM.originalprice)) EQ 0>
			<cfset Validation.originalprice.text = "Please provide a originalprice with not null."/>
			<cfset Validation.originalprice.class = InvalidClass/>
			<cfset Validation.isValid = false/>
		</cfif>
		<cfif NOT IsDefined('FORM.categoryID') OR FORM.categoryID EQ 0>
			<cfset Validation.categoryID.text = "Please provide a category ID."/>
			<cfset Validation.categoryID.class = InvalidClass/>
			<cfset Validation.isValid = false/>
		</cfif>
		<cfif NOT IsDefined('FORM.brandID') OR FORM.brandID EQ 0>
			<cfset Validation.brandID.text = "Please provide a brand ID."/>
			<cfset Validation.brandID.class = InvalidClass/>
			<cfset Validation.isValid = false/>
		</cfif>
		<cfif NOT IsDefined('FORM.image') OR FORM.image EQ "">
			<cfset Validation.image.text = "Please choose an image."/>
			<cfset Validation.image.class = InvalidClass/>
			<cfset Validation.isValid = false/>
		</cfif>
		<!--- <cfif Not IsImageFile(getTempDirectory() & Reupload.serverFile)>
		    <cffile action="delete" file="#getTempDirectory()##Reupload.serverFile#">
		    <cfset Validation.image.text = "The file must an image."/>
			<cfset Validation.image.class = InvalidClass/>
			<cfset Validation.isValid = false/>
		</cfif> ---><!--- 
		<cfif NOT IsDefined('FORM.status') OR NOT ListFind('0,1',FORM.status)>
			<cfset Validation.status.text = "Please select one."/>
			<cfset Validation.status.class = InvalidClass/>
			<cfset Validation.isValid = false/>
		</cfif>
		<cfif NOT IsDefined('FORM.IsActive') OR NOT ListFind('0,1',FORM.IsActive)>
			<cfset Validation.IsActive.text = "Please select one."/>
			<cfset Validation.IsActive.class = InvalidClass/>
			<cfset Validation.isValid = false/>
		</cfif> --->
		<cfif Validation.isValid>
			<cfset desc = ReReplaceNoCase(#FORM.description#, '<[^>]*>', '', "ALL")>
			<cfset text = ReReplaceNoCase(#FORM.text#, '<[^>]*>', '', "ALL")>
			<cftransaction isolation="serializable" action="begin">
					<cftry>
						<cfquery name="insert_product">

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
								<cfqueryparam sqltype="varchar" value="#FORM.productName#"/>,
								<cfqueryparam sqltype="clob" value="#desc#"/>,
								<cfqueryparam sqltype="float" value="#FORM.price#"/>,
								<cfqueryparam sqltype="integer" value="#FORM.discount#"/>,
								<cfqueryparam sqltype="float" value="#FORM.originalprice#"/>,
								<cfif  NOT IsDefined('FORM.status')>
									<cfqueryparam sqltype="tinyint" value="0"/>,
								<cfelse>
									<cfqueryparam sqltype="tinyint" value="#FORM.status#"/>,
								</cfif>
								<cfif  NOT IsDefined('FORM.IsActive')>
									<cfqueryparam sqltype="tinyint" value="0"/>,
								<cfelse>
									<cfqueryparam sqltype="tinyint" value="#FORM.IsActive#"/>,
								</cfif>
								<cfqueryparam sqltype="integer" value="#FORM.categoryID#"/>,
								<cfqueryparam sqltype="integer" value="#FORM.brandID#"/>,
								<cfqueryparam sqltype="clob" value="#text#"/>,
								<cfqueryparam sqltype="varchar" value="#getContextRoot()#/images/product/#Reupload.clientfile#"/>,
								<cfqueryparam sqltype="date" value="#now()#">
							)
							</cfquery>
						<cftransaction action="commit"/>
						<cflocation url="#buildUrl('product.default')#"/>
					<cfcatch>
						<cftransaction action="rollback"/>
						<cfdump var="#cfcatch#"/><cfabort>
					</cfcatch>

					</cftry>
			</cftransaction>
		</cfif>
	</cfcase>

	<cfcase value="update">
		<cfif isDefined("FORM.image")>
			<cfif FORM.image is not "">
				<cffile action = "upload" 
							result="Reupload"
							nameconflict = "unique" 
					        fileField = "image" 
					        destination = "#getContextRoot()#/images/product/">
			</cfif>
		</cfif>
		<cfif NOT IsDefined('FORM.productName') OR Len(Trim(FORM.productName)) GT 255 OR Len(Trim(FORM.productName)) EQ 0>
			<cfset Validation.productName.text = "Please provide a product name with maximal 255 characters and not null."/>
			<cfset Validation.productName.class = InvalidClass/>
			<cfset Validation.isValid = false/>
		</cfif>
		<cfif NOT IsDefined('FORM.description') OR Len(Trim(FORM.description)) GT 8000 OR Len(Trim(FORM.description)) EQ 0>
			<cfset Validation.description.text = "Please provide a description with maximal 255 characters and not null."/>
			<cfset Validation.description.class = InvalidClass/>
			<cfset Validation.isValid = false/>
		</cfif>
		<cfif NOT IsDefined('FORM.price') OR Len(Trim(FORM.price)) EQ 0>
			<cfset Validation.price.text = "Please provide a price with not null."/>
			<cfset Validation.price.class = InvalidClass/>
			<cfset Validation.isValid = false/>
		</cfif>
		<cfif NOT IsDefined('FORM.originalprice') OR Len(Trim(FORM.originalprice)) EQ 0>
			<cfset Validation.originalprice.text = "Please provide a originalprice with not null."/>
			<cfset Validation.originalprice.class = InvalidClass/>
			<cfset Validation.isValid = false/>
		</cfif>
		<cfif NOT IsDefined('FORM.categoryID') OR FORM.categoryID EQ 0>
			<cfset Validation.categoryID.text = "Please provide a category ID."/>
			<cfset Validation.categoryID.class = InvalidClass/>
			<cfset Validation.isValid = false/>
		</cfif>
		<cfif NOT IsDefined('FORM.brandID') OR FORM.brandID EQ 0>
			<cfset Validation.brandID.text = "Please provide a brand ID."/>
			<cfset Validation.brandID.class = InvalidClass/>
			<cfset Validation.isValid = false/>
		</cfif>
		<!--- <cfif NOT IsDefined('FORM.status') OR NOT ListFind('0,1',FORM.status)>
			<cfset Validation.status.text = "Please select one."/>
			<cfset Validation.status.class = InvalidClass/>
			<cfset Validation.isValid = false/>
		</cfif>
		<cfif NOT IsDefined('FORM.IsActive') OR NOT ListFind('0,1',FORM.IsActive)>
			<cfset Validation.IsActive.text = "Please select one."/>
			<cfset Validation.IsActive.class = InvalidClass/>
			<cfset Validation.isValid = false/>
		</cfif> --->

		<cfif Validation.isValid>
			<cfset desc = ReReplaceNoCase(#FORM.description#, '<[^>]*>', '', "ALL")>
			<cfset text = ReReplaceNoCase(#FORM.text#, '<[^>]*>', '', "ALL")>
			<cftransaction isolation="serializable" action="begin">
				<cftry>
					<cfquery name="update_product">
						UPDATE Product
						SET 
							productName = <cfqueryparam sqltype="varchar" value="#FORM.productName#"/>,
							description = <cfqueryparam sqltype="clob" value="#desc#"/>,
							price = <cfqueryparam sqltype="float" value="#FORM.price#"/>,
							discount = <cfqueryparam sqltype="integer" value="#FORM.discount#"/>,
							originalprice = <cfqueryparam sqltype="float" value="#FORM.originalprice#"/>,
							<cfif  NOT IsDefined('FORM.status')>
								status = 0,
							<cfelse>
								status = <cfqueryparam sqltype="tinyint" value="#FORM.status#"/>,
							</cfif>
							<cfif  NOT IsDefined('FORM.IsActive')>
								IsActive = 0,
							<cfelse>
								IsActive = <cfqueryparam sqltype="tinyint" value="#FORM.IsActive#"/>,
							</cfif>
							categoryID = <cfqueryparam sqltype="integer" value="#FORM.categoryID#"/>,
							brandID = <cfqueryparam sqltype="integer" value="#FORM.brandID#"/>,
							text = <cfqueryparam sqltype="clob" value="#text#"/>,
							productDate = <cfqueryparam sqltype="date" value="#now()#"/>
							<cfif FORM.image is not "">
								,image = <cfqueryparam sqltype="varchar" value="#getContextRoot()#/images/product/#Reupload.clientfile#"/>
							</cfif>
						WHERE productID = <cfqueryparam sqltype="integer" value="#FORM.productID#"/>
					</cfquery>
					<cftransaction action="commit"/>
					<cflocation url="#buildUrl('product.default')#"/>
				<cfcatch>
					<cftransaction action="rollback"/>
					<cfdump eval=form>
					<cfdump var="#cfcatch#"/><cfabort>
				</cfcatch>
				</cftry>
			</cftransaction>
		</cfif>
	</cfcase>
</cfswitch>

<script type="text/javascript" language="javascript">
		$("document").ready(function(){
			function readURL(input) {

			    if (input.files && input.files[0]) {
			        var reader = new FileReader();

			        reader.onload = function (e) {
			            $('#currentImage').attr('src', e.target.result);
			        };

			        reader.readAsDataURL(input.files[0]);
			    }
			};
			 
			$("#image").change(function() {
	    		 readURL(this);
            });

		});

</script>

<cfoutput>
<br>
<legend><h1>Product Management - Update</h1></legend>
<div  style="width:100%; margin:auto;">
	<div class="row clearfix">
		<cfif NOT Validation.isValid>
			<div class="alert alert-dange">
				<h3>Oops! Could not save new product</h3>
			</div>
		</cfif>
	</div>
<form  method="post"  enctype="multipart/form-data">

	<div class="row clearfix">
		<div class="col-md-12 column">
			<div class="row clearfix">
				<div class="col-md-4 column" style="border-right: 1px solid brown;">
					<input type="hidden" name="productID" value="#FORM.productID#"/>

					<!--- Product Name --->
					<label for="productName">Product Name</label>
					<div class="#Validation.productName.class#">
						#Validation.productName.text#
					</div>
					<div class="form-group">
						 <input type="text" class="form-control" id="productName" name="productName" value="#FORM.productName#"/>
					</div>
					
					<!--- Description --->
					<label for="description">Description</label>
					<div class="#Validation.description.class#">
						#Validation.description.text#
					</div>
					<div class="form-group">
						 <textarea type="text" required="yes" class="form-control" id="description" name="description">#FORM.description#</textarea>
					</div>

					<div class="row clearfix">
						<div class="col-md-4 column">
							<!--- Original Price --->
							<label for="price">Original Price</label>
							<div class="#Validation.originalprice.class#">
								#Validation.originalprice.text#
							</div>
							<div class="form-group">
								 <input type="number" class="form-control" id="originalprice" name="originalprice" value="#FORM.originalprice#"/>
							</div>
						</div>
						<div class="col-md-4 column">
							<!--- Price --->
							<label for="price">Price</label>
							<div class="#Validation.price.class#">
								#Validation.price.text#
							</div>
							<div class="form-group">
								 <input type="number" class="form-control" id="price" name="price" value="#FORM.price#"/>
							</div>	
						</div>
						<div class="col-md-4 column">
							<!--- Discount --->
							<label for="discount">Discount</label>
							<div class="form-group">
								 <input type="number" class="form-control" id="discount" name="discount" value="#FORM.discount#"/>
							</div>
						</div>
					</div>
				</div>
				<div class="col-md-4 column">
					<div class="row clearfix">
						<div class="col-md-6 column">
							<!--- Status --->
							<label for="status">Stock status</label>
							<div class="#Validation.status.class#">
								#Validation.status.text#
							</div>
							<div class="form-group">
						        <input type="checkbox" id="status" name="status" value="1" <cfif FORM.status> checked</cfif>> In stock
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
					<!---- Category ID --->
					<label for="categoryID">Category</label>
					<div class="#Validation.categoryID.class#">
						#Validation.categoryID.text#
					</div>
					<div class="form-group">
							 <div class="clearfix">
								 <select name="categoryID" class="form-control btn btn-option" style="border: 1px solid brown;">
								 	<option value="0">--- Select a Category ---</option>
							    	<cfloop query="#lstCategory#">
											<option value="#lstCategory.categoryID#" <cfif lstCategory.categoryID EQ FORM.categoryID> selected</cfif>>#lstCategory.categoryName#</option>
									</cfloop>
								 </select>
							 </div>
					</div>

					<!---- Brand ID --->
					<label for="brandID">Brand</label>
					<div class="#Validation.brandID.class#">
						#Validation.brandID.text#
					</div>
					<div class="form-group">
						 <div class="clearfix">
								 <select name="brandID" class="form-control btn btn-option" style="border: 1px solid brown;">
								 	<option value>--- Select a Brand ---</option>
							    	<cfloop query="#lstBrand#">
										<option value="#lstBrand.brandID#" <cfif lstBrand.brandID EQ FORM.brandID> selected</cfif> >#lstBrand.brandName#</option>
									</cfloop>
								 </select>
							 </div>
					</div>
				</div>
				<div class="col-md-4 column" style="border-left: 1px solid brown;">
					
					<!---- Image ---->
					<label for="image">Choose an image</label>
					<div class="#Validation.image.class#">
						#Validation.image.text#
					</div>
					<div class="form-group">
						<input type="file" name="image" id="image" value="#FORM.image#"/>
					</div>
					<label for="image">Current image</label>
					<div class="form-group">
						<img id="currentImage" src="#getContextRoot()##FORM.image#" alt="No image" width="144" height="144">
					</div>

				</div>
			</div>
		</div>
	</div>
	<hr>
	<div class="row clearfix">
		<div class="col-md-12 column">
			<!---- Text ---->
			<label for="text">Text</label>
			<div class="form-group">
				 <textarea type="text" class="form-control" id="text" name="text">#FORM.text#</textarea>
				 <script type="text/javascript">
				 	CKEDITOR.replace( 'text',
						{
							filebrowserBrowseUrl : '../../admin/ckfinder/ckfinder.html',
							filebrowserImageBrowseUrl : '../../admin/ckfinder/ckfinder.html?type=Images',
							filebrowserFlashBrowseUrl : '../../admin/ckfinder/ckfinder.html?type=Flash',
							filebrowserUploadUrl : '../../admin/ckfinder/core/connector/cfm/connector.cfm?command=QuickUpload&type=Files',
							filebrowserImageUploadUrl : '../../admin/ckfinder/core/connector/cfm/connector.cfm?command=QuickUpload&type=Images',
							filebrowserFlashUploadUrl : '../../admin/ckfinder/core/connector/cfm/connector.cfm?command=QuickUpload&type=Flash',
							filebrowserWindowWidth : '1000',
						 	filebrowserWindowHeight : '700'
						});
				 </script>
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