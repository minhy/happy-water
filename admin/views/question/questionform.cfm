
<cfoutput>
<cfparam name="FORM.id"	type="integer" default="0"/>
<cfparam name="URL.id"	type="integer" default="0">
<cfparam name="question_id" type="integer" default="1">
	<cfset Validation.Valid = true/>
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
<cfquery name="qGetQuestion">
	select distinct question_level from question 
	
</cfquery>
<cfquery name="qGetQuestionByID">
	select * from question where question_id = <cfqueryparam sqltype="integer" value="#URL.id#"/>
</cfquery>
<cfswitch expression="#FormAction#">
	<cfcase value="show">
		<cfparam name="Form.level"		default=""/>
		<cfparam name="Form.description"		default=""/>
		<cfparam name="Form.Answer"		default="Yes"/>
	</cfcase>
	<cfcase value="insert">


<!--- 	<cfif NOT IsDefined('FORM.level') OR Len(Trim(FORM.level)) EQ 0>
		<cfset Validation.level.text = "Please input level."/>
		<cfset Validation.level.class = InvalidClass/>
		<cfset Validation.Valid = false/>
	</cfif>

			/**
		  * @author Huan
		  * @edit by Phu 
		  * @date May 05, 2014 
		  * @time 18:04:05  
		  */
 --->
	<cfif NOT IsDefined('FORM.description') OR Len(Trim(FORM.description)) EQ 0>
		<cfset Validation.description.text = "Please input description."/>
		<cfset Validation.description.class = InvalidClass/>
		<cfset Validation.Valid = false/>
	</cfif>

	<cfif  Validation.Valid>
			<cftransaction isolation="serializable" action="begin">
				<cftry>
					<cfquery name="InsertContact" result="Result" >
						INSERT INTO question
						(question_name,
						 question_level,
						 question_TF
						 )
						VALUES
						(
						 <cfqueryparam sqltype="varchar" value="#FORM.description#"/>,
						 <cfqueryparam sqltype="varchar" value="#FORM.level#"/>,
						 <cfif  NOT IsDefined('FORM.Answer')>
							<cfqueryparam sqltype="integer" value="0"/>,
						 <cfelse>
							<cfqueryparam sqltype="integer" value="#FORM.Answer#"/>
						 </cfif>
						 )
					</cfquery>
			
			<cftransaction action="commit"/>
				<cflocation url="#buildUrl('question')#" />
				<cfcatch>
					<cftransaction action="rollback"/>
					<cfset Validation.Valid = false>
					<cfdump eval=cfcatch />
				</cfcatch>
			</cftry>
			</cftransaction>
	</cfif>
	</cfcase>

	<cfcase value="edit">
		<cfset form.level=qGetQuestionByID.question_level/>
		<cfset form.id=qGetQuestionByID.question_id/>
		<cfset form.description=qGetQuestionByID.question_name/>
		<cfset form.Answer=qGetQuestionByID.question_TF/>
	</cfcase>

	<cfcase value="update">
<cfdump eval=FORM>


<!--- 		<cfif NOT IsDefined('FORM.level') OR Len(Trim(FORM.level)) EQ 0>
		<cfset Validation.level.text = "Please input level."/>
		<cfset Validation.level.class = InvalidClass/>
		<cfset Validation.Valid = false/>
	</cfif> 
			/**
		  * @author Huan
		  * @edit by Phu 
		  * @date May 05, 2014 
		  * @time 18:05:05  
		  */
 --->
	<cfif NOT IsDefined('FORM.description') OR Len(Trim(FORM.description)) EQ 0>
		<cfset Validation.description.text = "Please input description."/>
		<cfset Validation.description.class = InvalidClass/>
		<cfset Validation.Valid = false/>
	</cfif>

	<cfif  Validation.Valid>

		<cftransaction isolation="serializable" action="begin">
			<cftry>
		<cfquery name="qUpdateQuestion">
			update question set 
				question_level=<cfqueryparam sqltype="varchar" value="#FORM.level#"/>,
				question_name=<cfqueryparam sqltype="varchar" value="#FORM.description#"/>,
				<cfif  NOT IsDefined('FORM.ANSWER')>
					question_TF=<cfqueryparam sqltype="integer" value="0"/>,
				<cfelse>
					question_TF=<cfqueryparam sqltype="integer" value="#FORM.Answer#"/>
				</cfif>
				where question_id=<cfqueryparam sqltype="integer" value="#FORM.id#"/>
		</cfquery>		
				<cftransaction action="commit"/>
				<cflocation url="#buildUrl('question')#" />
				<cfcatch>
					<cftransaction action="rollback"/>
					<cfset Validation.Valid = false>
					<cfdump eval=cfcatch />
				</cfcatch>
			</cftry>
		</cftransaction>
		 
		 </cfif>
	</cfcase>
</cfswitch>
	
	<cfparam name="Validation.level.text" 		default="&nbsp;"/>
	<cfparam name="Validation.description.text"     default="&nbsp;"/>
	<cfparam name="Validation.Answer.text"     default="&nbsp;"/>

	<cfparam name="Validation.level.class" 		default=""/>
	<cfparam name="Validation.description.class"		default=""/>
	<cfparam name="Validation.Answer.class" 		default=""/>
	<cfparam name="Validation.Valid" 	default="true"/>

<h3 class="header-title"><a href="#buildUrl('question')#"><span class="glyphicon glyphicon-circle-arrow-left"></span></a> Add Question</h3><hr>
<div class="row clearfix">
	<cfif NOT Validation.Valid>
		<div class="alert alert-dange">
			<h3>Oops! Could not save new question</h3>
		</div>
	</cfif>
</div>
<form action="" method="post" enctype="multipart/form-data">
<input type="hidden" name="id" value="#FORM.id#"/>
<div class="row clearfix">
    <div class="col-md-2">
		Question level:
    </div>
    <div class="col-md-10 form#Validation.level.class#">
		<select name="level" id ="level">
			  	<cfloop query="qGetQuestion">
			  		<cfif #qGetQuestion.question_level# eq #qGetQuestionByID.question_level#>
						<cfset selected="selected"/>
					<cfelse>
						<cfset selected=""/>
					</cfif>
				  	<option 		  	
				  	value="#qGetQuestion.question_level#" #selected#>#qGetQuestion.question_level#
					</option>
				</cfloop>
		</select>
		<p>#Validation.level.text#</p>
    </div>

    <div class="col-md-2">
    	Description:
    </div>
    <div class="col-md-10 form#Validation.description.class#">
		<textarea "textarea" rows="5" cols="100" name="Description" id="Description" value="" size="50">#FORM.description#</textarea>
		<p>#Validation.description.text#</p>
    </div>

    <div class="col-md-2">
    	Answer:
    </div>
    <div class="col-md-10 form#Validation.Answer.class#">


		<input type="checkbox" name="Answer" value="1"<cfif FORM.Answer> checked</cfif>/> Yes
	<!---<input type="radio" name="Answer" value="1"<cfif FORM.Answer> checked</cfif>/> True<br>
		<input type="radio" name="Answer" value="0"<cfif NOT FORM.Answer> checked</cfif>/> False<br> --->
		<!---
				/**
		  * @author Huan
		  * @edit by Phu 
		  * @date May 06, 2014 
		  * @time 11:05:05  
		  */--->


		<p>#Validation.Answer.text#</p>
    </div>
</div>


 <!--- Submit button --->
    <div class="div_center">
		<div class="alert alert-info">
			<button type="submit" class="btn btn-default btn_center">Submit</button>
		</div>
	</div>
<!---   <div class="col-md-10">
    <div class="btn-group">
        <button type="submit" class="btnSubmit btn btn-default">Submit</button>
    </div>
</div> --->

</form>

</cfoutput>