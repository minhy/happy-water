<cfquery name="qGetContact">
	SELECT *
	FROM article
	WHERE tag="contact"
</cfquery>
<cfset Validation.isInvalid = false/>
<cfset InvalidClass = " invalid"/>
<cfif CGI.REQUEST_METHOD EQ 'get' >
	<cfset FormAction 	= "show"/>
<cfelseif CGI.REQUEST_METHOD EQ 'post' >
	<cfset FormAction = "insert"/>
</cfif>
<cfswitch expression="#FormAction#">
	<cfcase value="show">
		<cfparam name="Form.yname"		default=""/>
		<cfparam name="Form.email"		default=""/>
		<cfparam name="Form.subject"		default=""/>
		<cfparam name="Form.comment"		default=""/>
		<cfparam name="Form.active"		default="Yes"/>
	</cfcase>
	<cfcase value="insert">
		<cfif NOT IsDefined('FORM.yname') OR Len(Trim(FORM.yname)) EQ 0>
		<cfset Validation.yname.text = "Please input name."/>
		<cfset Validation.yname.class = InvalidClass/>
		<cfset Validation.isInvalid = true/>
	</cfif>

	<cfif NOT IsDefined('FORM.email') OR Len(Trim(FORM.email)) EQ 0>
		<cfset Validation.email.text = "Please input email."/>
		<cfset Validation.email.class = InvalidClass/>
		<cfset Validation.isInvalid = true/>
	</cfif>

	<cfif NOT IsDefined('FORM.subject') OR Len(Trim(FORM.subject)) EQ 0>
		<cfset Validation.subject.text = "Please input subject."/>
		<cfset Validation.subject.class = InvalidClass/>
		<cfset Validation.isInvalid = true/>
	</cfif>

	<cfif NOT IsDefined('FORM.comment') OR Len(Trim(FORM.comment)) EQ 0>
		<cfset Validation.comment.text = "Please input comment."/>
		<cfset Validation.comment.class = InvalidClass/>
		<cfset Validation.isInvalid = true/>
	</cfif>

	<cfif NOT  Validation.isInvalid>
			<cftransaction isolation="serializable" action="begin">
				<cftry>
					<cfquery name="InsertContact" result="Result" >
						INSERT INTO contact
						(contact_name,
						 contact_email,
						 contact_subject,
						 contact_comment)
						VALUES
						(<cfqueryparam sqltype="varchar" value="#FORM.yname#"/>,
						 <cfqueryparam sqltype="varchar" value="#FORM.email#"/>,
						 <cfqueryparam sqltype="varchar" value="#FORM.subject#"/>,
						 <cfqueryparam sqltype="varchar" value="#FORM.comment#"/>)
					</cfquery>
					<cfmail
						server="smtp.gmail.com"
						useSSL = "true"
						port="465"
						username="nguyen.hoang.thien1410@gmail.com"
						password="0914735651"
					    from="#form.email#" 
					    to="nguyen.hoang.thien1410@gmail.com" 
					    subject="#form.subject#"> 
					    #form.comment#
					</cfmail>
			<cftransaction action="commit"/>
				<cfcatch>
					<cftransaction action="rollback"/>
						<cfdump eval=cfcatch>
				</cfcatch>
				</cftry>
			</cftransaction>
			<!--- <cflocation url="index.cfm" /> --->
	</cfif>
	</cfcase>

</cfswitch>
	<cfparam name="Validation.yname.text" 		default="&nbsp;"/>
	<cfparam name="Validation.email.text"     	default="&nbsp;"/>
	<cfparam name="Validation.subject.text" 	default="&nbsp;"/>
	<cfparam name="Validation.comment.text"     default="&nbsp;"/>

	<cfparam name="Validation.yname.class" 		default=""/>
	<cfparam name="Validation.email.class"		default=""/>
	<cfparam name="Validation.subject.class" 		default=""/>
	<cfparam name="Validation.comment.class"		default=""/>
	<cfparam name="Validation.active.class" 		default=""/>
	<cfparam name="Validation.isInvalid" 	default="false"/>
<cfoutput>
<div class="header-title">
	<h1>Contact us</h1>
	<hr>
</div>
<div class="row clearfix">
	<div class="col-md-7">
		<form action="##" method="post">
			<div class="row clearfix">
				<div class="col-md-2">
					Your name:
				</div>
				<div class="col-md-10 form#Validation.yname.class#">
					<div class="input-group">
						<input type="text" name="yname" value="#FORM.yname#" class="form-control" placeholder="Your name" size="50">
						<p>#Validation.yname.text#</p>
					</div>
				</div>

				<div class="col-md-2">
					Your email:
				</div>
				<div class="col-md-10 form#Validation.email.class#">
					<div class="input-group">
						<input type="email" name="email" value="#FORM.email#" class="form-control" placeholder="Your email" size="50">
						<p>#Validation.email.text#</p>
					</div>				
				</div>

				<div class="col-md-2">
					Subject:
				</div>
				<div class="col-md-10 form#Validation.subject.class#">
					<div class="input-group">
						<input type="text" name="Subject" value="#FORM.subject#" class="form-control" placeholder="Subject" size="50">
						<p>#Validation.subject.text#</p>
					</div>				
				</div>

				<div class="col-md-2">
					Your message:
				</div>
				<div class="col-md-10 form#Validation.comment.class#">
					<div class="input-group">
					  <textarea type="text" rows="10" cols="55" name="comment" value="" class="form-control" placeholder="Message">#FORM.comment#</textarea>
					  <p>#Validation.comment.text#</p>
					</div>					
				</div>

				<div class="col-md-2">
				</div>
				<div class="col-md-10">
					<div class="btn-group">
					  	<button type="submit" class="btn btn-default" value="Submit">Send Message</button>
					</div>
				</div>
			</div>
		</form>
	</div>
	<div class="col-md-5">
		<center>
			<p>#qGetContact.article_description#</p>
			<p>
				<img src="#getContextRoot()#/#qGetContact.article_img#">			
			</p>
			<p>#qGetContact.article_content#</p>		
		</center>
	</div>
</div>
</cfoutput>