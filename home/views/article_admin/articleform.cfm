
<cfoutput>
<cfparam name="FORM.id"	type="integer" default="0"/>
<cfparam name="URL.id"	type="integer" default="0">
<cfparam name="userid"	type="integer" default="1">
<cfparam name="news_id" type="varchar" default="ne">
	<cfset Validation.isInvalid = false/>
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


<cfswitch expression="#FormAction#">
	<cfcase value="show">
		<cfparam name="Form.title"		default=""/>
		<cfparam name="Form.content"		default=""/>
		<cfparam name="Form.description"		default=""/>
		<cfparam name="Form.photo"		default=""/>
		<cfparam name="Form.active"		default="Yes"/>
	</cfcase>
	<cfcase value="insert">
		<cfif NOT IsDefined('FORM.title') OR Len(Trim(FORM.title)) EQ 0>
		<cfset Validation.title.text = "Please input title."/>
		<cfset Validation.title.class = InvalidClass/>
		<cfset Validation.isInvalid = true/>
	</cfif>

	<cfif NOT IsDefined('FORM.description') OR Len(Trim(FORM.description)) EQ 0>
		<cfset Validation.description.text = "Please input description."/>
		<cfset Validation.description.class = InvalidClass/>
		<cfset Validation.isInvalid = true/>
	</cfif>

	<cfif NOT IsDefined('FORM.content') OR Len(Trim(FORM.content)) EQ 0>
		<cfset Validation.content.text = "Please input content."/>
		<cfset Validation.content.class = InvalidClass/>
		<cfset Validation.isInvalid = true/>
	</cfif>

	<!---<cfif NOT IsDefined('FORM.photo') OR Len(Trim(FORM.photo)) EQ 0>
		<cfset Validation.photo.text = "Please input photo."/>
		<cfset Validation.photo.class = InvalidClass/>
		<cfset Validation.isInvalid = true/>
	</cfif>--->

	<cfif FORM.photo is ""> 
		<cfset Validation.photo.text = "Please input photo."/>
		<cfset Validation.photo.class = InvalidClass/>
		<cfset Validation.isInvalid = true/>
	</cfif>

	<cfif NOT  Validation.isInvalid>
			<cftransaction isolation="serializable" action="begin">
				<cftry>
					<cfif isDefined("form.photo") >
						<cfif FORM.photo is not ""> 
						  <cffile action = "upload" result="reupload"
				         fileField = "photo" 
				         destination = "/images/upload/"
				         nameConflict = "MakeUnique">
        				 </cfif>
					</cfif>

				

					<cfquery name="InsertContact" result="Result" >
						INSERT INTO article
						(article_title,
						 article_content,
						 article_img,
						 article_description,
						 userid,
						 article_isactive,
						 article_category_id,
						 article_createdate,
						 article_editdate
						 )
						VALUES
						(<cfqueryparam sqltype="varchar" value="#FORM.title#"/>,
						 <cfqueryparam sqltype="longvarchar" value="#FORM.content#"/>,
						 <cfqueryparam sqltype="varchar" value="images/upload/#reupload.serverfile#"/>,
						 <cfqueryparam sqltype="varchar" value="#FORM.description#"/>,
						 <cfqueryparam sqltype="integer" value="#userid#"/>,
						  <cfqueryparam sqltype="integer" value="#FORM.active#"/>,
						   <cfqueryparam sqltype="varchar" value="#news_id#"/>,
						 <cfqueryparam sqltype="date" value="#now()#"/>,
						 <cfqueryparam sqltype="date" value="#now()#"/>)
					</cfquery>
			
			<cftransaction action="commit"/>
				<cfcatch>
					<cftransaction action="rollback"/>
						
				</cfcatch>
				</cftry>
			</cftransaction>
		 <cflocation url="article_admin" />
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
	</cfcase>
	<cfcase value="update">
		<cfif NOT IsDefined('FORM.title') OR Len(Trim(FORM.title)) EQ 0>
		<cfset Validation.title.text = "Please input title."/>
		<cfset Validation.title.class = InvalidClass/>
		<cfset Validation.isInvalid = true/>
	</cfif>

	<cfif NOT IsDefined('FORM.description') OR Len(Trim(FORM.description)) EQ 0>
		<cfset Validation.description.text = "Please input description."/>
		<cfset Validation.description.class = InvalidClass/>
		<cfset Validation.isInvalid = true/>
	</cfif>

	<cfif NOT IsDefined('FORM.content') OR Len(Trim(FORM.content)) EQ 0>
		<cfset Validation.content.text = "Please input content."/>
		<cfset Validation.content.class = InvalidClass/>
		<cfset Validation.isInvalid = true/>
	</cfif>

	<cfif NOT  Validation.isInvalid>

		<cftransaction isolation="serializable" action="begin">
			<cftry>
					
				<cfif isDefined("form.photo") >
					<cfif FORM.photo is not ""> 
					  <cffile action = "upload" result="reupload"
			         fileField = "photo" 
			         destination = "/images/upload/"
			         nameConflict = "MakeUnique">
					 </cfif>
				</cfif>
		<cfquery name="qUpdateArticle">
			update article set 
				article_title=<cfqueryparam sqltype="varchar" value="#FORM.title#"/>,
				article_content=<cfqueryparam sqltype="varchar" value="#FORM.content#"/>,
				article_description=<cfqueryparam sqltype="varchar" value="#FORM.description#"/>,
				article_editdate =<cfqueryparam sqltype="date" value="#now()#"/>,
				article_isactive=<cfqueryparam sqltype="integer" value="#FORM.active#"/>

				<cfif FORM.photo is not ""> 
					,article_img=<cfqueryparam sqltype="varchar" value="images/upload/#reupload.serverfile#"/>
				</cfif>
				where article_id=<cfqueryparam sqltype="integer" value="#FORM.id#"/>
		</cfquery>		
			<cftransaction action="commit"/>
				<cfcatch>
					<cftransaction action="rollback"/>
						
				</cfcatch>
			</cftry>
		</cftransaction>>
		 <cflocation url="article_admin" />
		 </cfif>
	</cfcase>
</cfswitch>
	

	<cfparam name="Validation.title.text" 		default="&nbsp;"/>
	<cfparam name="Validation.content.text"     	default="&nbsp;"/>
	<cfparam name="Validation.photo.text" 	default="&nbsp;"/>
	<cfparam name="Validation.description.text"     default="&nbsp;"/>
	<cfparam name="Validation.active.text"     default="&nbsp;"/>

	<cfparam name="Validation.title.class" 		default=""/>
	<cfparam name="Validation.content.class"		default=""/>
	<cfparam name="Validation.photo.class" 		default=""/>
	<cfparam name="Validation.description.class"		default=""/>
	<cfparam name="Validation.active.class" 		default=""/>
	<cfparam name="Validation.isInvalid" 	default="false"/>


		
			
				<form action="" method="post" enctype="multipart/form-data">
					<input type="hidden" name="id" value="#FORM.id#"/>
					<table>
						<tr>
							<td>Title:</td>
							<td class="form#Validation.title.class#" >
								<input type="text" name="title" value="#FORM.title#" size="50"/>
								<p>#Validation.title.text#</p>
							</td>
						</tr>
						<tr>
							<td>Description:</td>
							<td class="form#Validation.description.class#" >
								<textarea "textarea" rows="10" cols="55" name="Description" id="Description" value="" size="50">#FORM.description#</textarea>
								<p>#Validation.description.text#</p>
							</td>
						</tr>
						<tr>
							<td >Image:</td>
							<td class="form#Validation.photo.class#">
								<input type="file" name="photo"  size="50"/>
								<p>#Validation.photo.text#</p>
							</td>
						</tr>
						<tr>
							<td >Content:</td>
							<td class="form#Validation.content.class#" >
								<textarea "textarea" rows="10" cols="55" name="content" id="content" value="" size="50">#FORM.content#</textarea>
								<script type="text/javascript">CKEDITOR.replace('content'); </script>
								<p>#Validation.content.text#</p>
							</td>
						</tr>
						<tr>
							<td >Active:</td>
							<td class="form#Validation.active.class#">
								<input type="radio" name="active" value="1"<cfif FORM.active> checked</cfif>/> Yes<br>
								<input type="radio" name="active" value="0"<cfif NOT FORM.active> checked</cfif>/> No<br>
								<p>#Validation.active.text#</p>
							</td>
						</tr>
						<tr>
							<td ></td>
							<td >
								<input type="submit" value="Submit"/>
							</td>
						</tr>
					</table>
				</form>
	
			</cfoutput>