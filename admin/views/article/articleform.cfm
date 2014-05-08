
<cfoutput>
<cfparam name="FORM.id"	type="integer" default="0"/>
<cfparam name="URL.id"	type="integer" default="0">
<cfparam name="userid"	type="integer" default="1">
<cfparam name="URL.tag"	type="varchar" default="">
<cfparam name="Form.active"		default="0"/>
<cfset Validation.isValid = true/>
<cfset InvalidClass = " invalid"/>


<cfif CGI.REQUEST_METHOD EQ 'get' AND URL.id EQ 0>
	<cfset FormAction 	= "show"/>
<cfelseif CGI.REQUEST_METHOD EQ 'get' AND URL.id GT 0>
	<cfset FormAction = "edit"/>
<cfelseif CGI.REQUEST_METHOD EQ 'post' AND FORM.id GT 0>
	<cfset FormAction = "update"/>
<cfelse>
	<cfset FormAction = "insert"/>
</cfif>

<cfquery name="qGetCategory">
	select * from category where parentID=<cfqueryparam sqltype="integer" value="1">
</cfquery>

<cfswitch expression="#FormAction#">
	<cfcase value="show">
		<cfparam name="Form.title"		default=""/>
		<cfparam name="Form.content"		default=""/>
		<cfparam name="Form.description"		default=""/>
		<cfparam name="Form.photo"		default=""/>
		<cfparam name="Form.active"		default="Yes"/>
		<cfparam name="Form.tag"		default=""/>
	</cfcase>
	<cfcase value="insert">
	<cfif isDefined("form.photo") >
		<cfif FORM.photo is not ""> 
		  <cffile action = "upload" result="reupload"
         fileField = "photo" 
         destination = "/images/upload/"
         nameConflict = "MakeUnique">
		 </cfif>
	</cfif>	
	<cfif NOT IsDefined('FORM.title') OR Len(Trim(FORM.title)) EQ 0>
		<cfset Validation.title.text = "Please input title."/>
		<cfset Validation.title.class = InvalidClass/>
		<cfset Validation.isValid = false/>
	</cfif>

	<cfif NOT IsDefined('FORM.description') OR Len(Trim(FORM.description)) EQ 0>
		<cfset Validation.description.text = "Please input description."/>
		<cfset Validation.description.class = InvalidClass/>
		<cfset Validation.isValid = false/>
	</cfif>

	<cfif NOT IsDefined('FORM.content') OR Len(Trim(FORM.content)) EQ 0>
		<cfset Validation.content.text = "Please input content."/>
		<cfset Validation.content.class = InvalidClass/>
		<cfset Validation.isValid = false/>
	</cfif>

	<!---<cfif NOT IsDefined('FORM.photo') OR Len(Trim(FORM.photo)) EQ 0>
		<cfset Validation.photo.text = "Please input photo."/>
		<cfset Validation.photo.class = InvalidClass/>
		<cfset Validation.isValid = false/>
	</cfif>--->

	<cfif FORM.photo is ""> 
		<cfset Validation.photo.text = "Please input photo."/>
		<cfset Validation.photo.class = InvalidClass/>
		<cfset Validation.isValid = false/>
	</cfif>

	<cfif Validation.isValid>
			<cftransaction isolation="serializable" action="begin">
				<cftry>
					<cfquery name="InsertContact" result="Result" >
						INSERT INTO article
						(article_title,
						 article_content,
						 article_img,
						 article_description,
						 userid,
						 article_isactive,
						 tag,
						 article_createdate,
						 article_editdate
						 )
						VALUES
						(<cfqueryparam sqltype="varchar" value="#FORM.title#"/>,
						 <cfqueryparam sqltype="longvarchar" value="#FORM.content#"/>,
						 <cfqueryparam sqltype="varchar" value="images/upload/#reupload.clientfile#"/>,
						 <cfqueryparam sqltype="varchar" value="#FORM.description#"/>,
						 <cfqueryparam sqltype="integer" value="#userid#"/>,
						 <cfif  NOT IsDefined('FORM.active')>
							<cfqueryparam sqltype="tinyint" value="0"/>,
						 <cfelse>
							<cfqueryparam sqltype="tinyint" value="#FORM.active#"/>,
						 </cfif>
					     <cfqueryparam sqltype="varchar" value="#FORM.tag#"/>,
						 <cfqueryparam sqltype="date" value="#now()#"/>,
						 <cfqueryparam sqltype="date" value="#now()#"/>)
					</cfquery>
			
			<cftransaction action="commit"/>
			<cflocation url="#buildUrl('article')#" />
				<cfcatch>
					<cftransaction action="rollback"/>
					<cfset Validation.isValid = false/>	
				</cfcatch>
				</cftry>
			</cftransaction>
	</cfif>
	</cfcase>
	<cfcase value="edit">
		<cfquery name="qGetArticleByID">
			select * from article where article_id = <cfqueryparam sqltype="integer" value="#URL.id#"/>
		</cfquery>
		<cfset form.title=qGetArticleByID.article_title/>
		<cfset form.content=qGetArticleByID.article_content/>
		<cfset form.id=qGetArticleByID.article_id/>
		<cfset form.description=qGetArticleByID.article_description/>
		<cfset form.active=qGetArticleByID.article_isactive/>
		<cfset form.photo = qGetArticleByID.article_img/>
	</cfcase>
	<cfcase value="update">
		<cfif isDefined("form.photo") >
			<cfif FORM.photo is not ""> 
			  <cffile action = "upload" result="reupload"
		         fileField = "photo" 
		         destination = "/images/upload/"
		         nameConflict = "MakeUnique">
			 </cfif>
		</cfif>
		<cfif NOT IsDefined('FORM.title') OR Len(Trim(FORM.title)) EQ 0>
			<cfset Validation.title.text = "Please input title."/>
			<cfset Validation.title.class = InvalidClass/>
			<cfset Validation.isValid = false/>
		</cfif>

		<cfif NOT IsDefined('FORM.description') OR Len(Trim(FORM.description)) EQ 0>
			<cfset Validation.description.text = "Please input description."/>
			<cfset Validation.description.class = InvalidClass/>
			<cfset Validation.isValid = false/>
		</cfif>

		<cfif NOT IsDefined('FORM.content') OR Len(Trim(FORM.content)) EQ 0>
			<cfset Validation.content.text = "Please input content."/>
			<cfset Validation.content.class = InvalidClass/>
			<cfset Validation.isValid = false/>
		</cfif>

		<cfif  Validation.isValid>

			<cftransaction isolation="serializable" action="begin">
				<cftry>
			<cfquery name="qUpdateArticle">
				update article set 
					article_title=<cfqueryparam sqltype="varchar" value="#FORM.title#"/>,
					article_content=<cfqueryparam sqltype="varchar" value="#FORM.content#"/>,
					article_description=<cfqueryparam sqltype="varchar" value="#FORM.description#"/>,
					article_editdate =<cfqueryparam sqltype="date" value="#now()#"/>,
					tag=<cfqueryparam sqltype="varchar" value="#FORM.tag#"/>,
					<cfif  NOT IsDefined('FORM.active')>
						article_isactive = 0,
					<cfelse>
						article_isactive = <cfqueryparam sqltype="tinyint" value="#FORM.active#"/>
					</cfif>
					<cfif FORM.photo is not ""> 
						,article_img=<cfqueryparam sqltype="varchar" value="images/upload/#reupload.clientfile#"/>
					</cfif>
					where article_id=<cfqueryparam sqltype="integer" value="#FORM.id#"/>
			</cfquery>		
				<cftransaction action="commit"/>
				<cflocation url="#buildUrl('article')#" />
					<cfcatch>
						<cftransaction action="rollback"/>
						<cfset Validation.isValid = false/>
						<cfdump var="#cfcatch#"/><cfabort>
					</cfcatch>
				</cftry>
			</cftransaction>>
			 </cfif>
	</cfcase>
</cfswitch>
	
	
	<cfparam name="Validation.title.text" 		default="&nbsp;"/>
	<cfparam name="Validation.content.text"     	default="&nbsp;"/>
	<cfparam name="Validation.photo.text" 	default="&nbsp;"/>
	<cfparam name="Validation.description.text"     default="&nbsp;"/>
	<cfparam name="Validation.active.text"     default="&nbsp;"/>
	<cfparam name="Validation.tag.text"     default="&nbsp;"/>

	<cfparam name="Validation.title.class" 		default=""/>
	<cfparam name="Validation.content.class"		default=""/>
	<cfparam name="Validation.photo.class" 		default=""/>
	<cfparam name="Validation.description.class"		default=""/>
	<cfparam name="Validation.active.class" 		default=""/>
	<cfparam name="Validation.tag.class" 		default=""/>
	<cfparam name="Validation.isValid" 	default="false"/>

<script type="text/javascript" language="javascript">
		$("document").ready(function(){
			function readURL(input) {

			    if (input.files && input.files[0]) {
			        var reader = new FileReader();

			        reader.onload = function (e) {
			            $('##currentImage').attr('src', e.target.result);
			        };

			        reader.readAsDataURL(input.files[0]);
			    }
			};
			 
			$("##photo").change(function() {
	    		 readURL(this);
            });

		});

</script>
		
<h3 class="header-title"><a href="#buildUrl('article')#"><span class="glyphicon glyphicon-circle-arrow-left"></span></a>Article Update</h3><hr>
<div class="row clearfix">
	<cfif NOT Validation.isValid>
		<div class="alert alert-dange">
			<h3>Oops! Could not save new artile</h3>
		</div>
	</cfif>
</div>
<form action="" method="post" enctype="multipart/form-data">
<div class="row clearfix">
		<div class="col-md-12 column">
			<div class="row clearfix">
				<div class="col-md-4 column">
					<input type="hidden" name="id" value="#FORM.id#"/>

					<!---- Category --->
					<label for="categoryID">Category</label>
					<div class="form#Validation.tag.class#">
						#Validation.tag.text#
					</div>
					<div class="form-group">
							 <div class="clearfix">
								 <select name="tag" id ="tag" class="form-control" >
								  	<cfloop query="qGetCategory">
								  		<cfif #qGetCategory.tag# eq #URL.tag#>
											<cfset selected="selected"/>
										<cfelse>
											<cfset selected=""/>
										</cfif>
									  	<option 		  	
									  	value="#qGetCategory.tag#" #selected# >#qGetCategory.categoryName#
										</option>
									</cfloop>
								</select>
							 </div>
					</div>
					<!---Title --->
					<label for="title">Title</label>
					<div class="form#Validation.title.class#">
						#Validation.title.text#
					</div>
					<div class="form-group">
						 <input type="text" class="form-control" id="title" name="title" value="#FORM.title#"/>
					</div>
					
				</div>
				<div class="col-md-4 column" style="border-left: 1px solid brown;">
					<div class="row clearfix">
						<div class="col-md-6 column">
							<!--- Active --->
							<label for="active">Active</label>
							<div class="form#Validation.active.class#">
								#Validation.active.text#
							</div>
							<div class="form-group">
						        <input type="checkbox" name="active" value="1"<cfif FORM.active> checked</cfif>/> Yes
							</div>
						</div>
					</div>
					<!--- Description --->
					<label for="description">Description</label>
					<div class="form#Validation.description.class#">
						#Validation.description.text#
					</div>
					<div class="form-group">
						 <textarea "textarea" name="Description"  class="form-control" id="Description" value="" style="margin: 0px -2.65625px 0px 0px; height: 120px; width: 100%;">#FORM.description#</textarea>
					</div>
				</div>
				<div class="col-md-4 column" style="border-left: 1px solid brown;">
					
					<!---- Image ---->
					<label for="photo">Choose an image</label>
					<div class="#Validation.photo.class#">
						#Validation.photo.text#
					</div>
					<div class="form-group">
						<input type="file" name="photo" id="photo" size="50"/>
					</div>
					<label for="photo">Current image</label>
					<div class="form-group">
						<img id="currentImage" src="#getContextRoot()#/#FORM.photo#" alt="No image" width="144" height="144">
					</div>

				</div>
			</div>
		</div>
	</div>
	<hr>
	<div class="row clearfix">
		<div class="col-md-12 column">
			<!---- Content ---->
			<label for="text">Content</label>
			<div class="#Validation.content.class#">
				#Validation.content.text#
			</div>
			<div class="form-group">
				<textarea "textarea" rows="10" cols="55" name="content" id="content" value="" size="50">#FORM.content#</textarea>
				<script language="javascript1.2">
					CKEDITOR.replace( 'content',
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
    <!--- Submit button --->
    <div class="div_center">
		<div class="alert alert-info">
			<button type="submit" class="btn btn-default btn_center">Submit</button>
		</div>
	</div>
</form>
</cfoutput>