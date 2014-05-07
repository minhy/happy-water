<script type="text/javascript">
    function kt(){
        var pri=document.getElementById("priority").value;
        var par=document.getElementById("parentid").value;
        if(pri=="")
        {
        	return true;
        }
        else if(isNaN(pri) || pri<0 )
        {
        	alert("Priority is number");
        	return false;
        }
        else if(par=="")
        {
        	return true;
        }
        else if(isNaN(par) || par<0 )
        {
        	alert("Parentid is number");
        	return false;
        }
        return true;
    }
</script>
<cfoutput>
<cfparam name="FORM.id"	type="integer" default="0"/>
<cfparam name="URL.id"	type="integer" default="0">
<cfparam name="menu_id" type="integer" default="1">

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
<cfquery name="qGetMenu">
	select distinct menu_tag from menu 
	
</cfquery>
<cfquery name="qGetMenuByID">
	select * from menu where menu_id = <cfqueryparam sqltype="integer" value="#URL.id#"/>
</cfquery>
<cfswitch expression="#FormAction#">
	<cfcase value="show">
		<cfparam name="Form.title"		default=""/>
		<cfparam name="Form.link"		default=""/>
		<cfparam name="Form.active"		default="Yes"/>
		<cfparam name="Form.tag"		default=""/>
		<cfparam name="Form.priority"		default=""/>
		<cfparam name="Form.parentid"		default=""/>
	</cfcase>
	<cfcase value="insert">
		<cfif NOT IsDefined('FORM.tag') OR Len(Trim(FORM.tag)) EQ 0>
		<cfset Validation.tag.text = "Please input tag."/>
		<cfset Validation.tag.class = InvalidClass/>
		<cfset Validation.isValid = false/>
	</cfif>

	<cfif NOT IsDefined('FORM.title') OR Len(Trim(FORM.title)) EQ 0>
		<cfset Validation.title.text = "Please input title."/>
		<cfset Validation.title.class = InvalidClass/>
		<cfset Validation.isValid = false/>
	</cfif>

	<cfif NOT IsDefined('FORM.link') OR Len(Trim(FORM.link)) EQ 0>
		<cfset Validation.link.text = "Please input link."/>
		<cfset Validation.link.class = InvalidClass/>
		<cfset Validation.isValid = false/>
	</cfif>

	<!--- <cfif NOT IsDefined('FORM.priority') OR Len(Trim(FORM.priority)) EQ 0>
		<!--- <cfset Validation.priority.text = "Please input priority."/> --->
		<cfset Validation.priority.class = InvalidClass/>
	</cfif>

	<cfif NOT IsDefined('FORM.parentid') OR Len(Trim(FORM.parentid)) EQ 0>
		<!--- <cfset Validation.parentid.text = "Please input parentid."/> --->
		<cfset Validation.parentid.class = InvalidClass/>

	</cfif> --->
	<cfif Validation.isValid>
			<cftransaction isolation="serializable" action="begin">
				<cftry>
					<cfquery name="InsertContact" result="Result" >
						INSERT INTO menu
						(menu_name,
						 menu_link,
						 menu_isactive,
						 menu_tag,
						 menu_priority,
						 menu_parentid
						 )
						VALUES
						(
						 <cfqueryparam sqltype="varchar" value="#FORM.title#"/>,
						 <cfqueryparam sqltype="varchar" value="#FORM.link#"/>,
						 <cfif  NOT IsDefined('FORM.active')>
							<cfqueryparam sqltype="tinyint" value="0"/>,
						 <cfelse>
							<cfqueryparam sqltype="tinyint" value="#FORM.active#"/>,
						 </cfif>
						 <cfqueryparam sqltype="varchar" value="#FORM.tag#"/>,
						 <cfqueryparam sqltype="integer" value="#FORM.priority#"/>,
						 <cfqueryparam sqltype="integer" value="#FORM.parentid#"/>
						 )
					</cfquery>
			
			<cftransaction action="commit"/>
		 	<cflocation url="#buildUrl('menu')#" />
				<cfcatch>
					<cftransaction action="rollback"/>
					<cfset Validation.isValid = false/>
					<cfdump eval=cfcatch />
				</cfcatch>
				</cftry>
			</cftransaction>
	</cfif>
	</cfcase>
	<cfcase value="edit">

		<cfset form.tag=qGetMenuByID.menu_tag/>
		<cfset form.id=qGetMenuByID.menu_id/>
		<cfset form.title=qGetMenuByID.menu_name/>
		<cfset form.active=qGetMenuByID.menu_isactive/>
		<cfset form.link=qGetMenuByID.menu_link/>
		<cfset form.priority=qGetMenuByID.menu_priority/>
		<cfset form.parentid=qGetMenuByID.menu_parentid/>
		
	</cfcase>
	<cfcase value="update">
		<cfif NOT IsDefined('FORM.tag') OR Len(Trim(FORM.tag)) EQ 0>
		<cfset Validation.tag.text = "Please input tag."/>
		<cfset Validation.tag.class = InvalidClass/>
		<cfset Validation.isValid = false/>
	</cfif>

	<cfif NOT IsDefined('FORM.title') OR Len(Trim(FORM.title)) EQ 0>
		<cfset Validation.title.text = "Please input title."/>
		<cfset Validation.title.class = InvalidClass/>
		<cfset Validation.isValid = false/>
	</cfif>

	<cfif NOT IsDefined('FORM.link') OR Len(Trim(FORM.link)) EQ 0>
		<cfset Validation.link.text = "Please input link."/>
		<cfset Validation.link.class = InvalidClass/>
		<cfset Validation.isValid = false/>
	</cfif>

	<!--- <cfif NOT IsDefined('FORM.priority') OR Len(Trim(FORM.priority)) EQ 0>
		<!--- <cfset Validation.priority.text = "Please input priority."/> --->
		<cfset Validation.priority.class = InvalidClass/>
	</cfif>

	<cfif NOT IsDefined('FORM.parentid') OR Len(Trim(FORM.parentid)) EQ 0>
		<!--- <cfset Validation.parentid.text = "Please input parentid."/> --->
		<cfset Validation.parentid.class = InvalidClass/>
	</cfif> --->

	<cfif Validation.isValid>

		<cftransaction isolation="serializable" action="begin">
			<cftry>
		<cfquery name="qUpdateMenu">
			update menu set 
				menu_name=<cfqueryparam sqltype="varchar" value="#FORM.title#"/>,
				menu_link=<cfqueryparam sqltype="varchar" value="#FORM.link#"/>,
				<cfif  NOT IsDefined('FORM.active')>
					menu_isactive = 0,
				<cfelse>
					menu_isactive = <cfqueryparam sqltype="tinyint" value="#FORM.active#"/>,
				</cfif>
				menu_tag=<cfqueryparam sqltype="varchar" value="#FORM.tag#"/>,
				menu_priority=<cfqueryparam sqltype="integer" value="#FORM.priority#"/>,
				menu_parentid=<cfqueryparam sqltype="integer" value="#FORM.parentid#"/>
				where menu_id=<cfqueryparam sqltype="integer" value="#FORM.id#"/>
		</cfquery>		
			<cftransaction action="commit"/>
		 	<cflocation url="#buildUrl('menu')#" />
				<cfcatch>
					<cftransaction action="rollback"/>
					<cfset Validation.isValid = false/>
					<cfdump eval=cfcatch />
				</cfcatch>
			</cftry>
		</cftransaction>>
		 </cfif>
	</cfcase>
</cfswitch>
	<cfparam name="Validation.title.text"     default="&nbsp;"/>
	<cfparam name="Validation.link.text"     default="&nbsp;"/>
	<cfparam name="Validation.active.text"     default="&nbsp;"/>
	<cfparam name="Validation.tag.text" 		default="&nbsp;"/>
	<cfparam name="Validation.priority.text" 		default="&nbsp;"/>
	<cfparam name="Validation.parentid.text" 		default="&nbsp;"/>

	<cfparam name="Validation.tag.class" 		default=""/>
	<cfparam name="Validation.title.class"		default=""/>
	<cfparam name="Validation.active.class" 		default=""/>
	<cfparam name="Validation.link.class" 		default=""/>
	<cfparam name="Validation.priority.class"		default=""/>
	<cfparam name="Validation.parentid.class" 		default=""/>
	<cfparam name="Validation.isValid" 	default="false"/>

<h3 class="header-title"><a href="#buildUrl('menu')#"><span class="glyphicon glyphicon-circle-arrow-left"></span></a> Menu - Update</h3><hr>
<div class="row clearfix">
	<cfif NOT Validation.isValid>
		<div class="alert alert-dange">
			<h3>Oops! Could not save new menu</h3>
		</div>
	</cfif>
</div>
<form action="" method="post" enctype="multipart/form-data">
<input type="hidden" name="id" value="#FORM.id#"/>
	<div class="row clearfix">
			<div class="col-md-12 column">
				<div class="row clearfix">
					<div class="col-md-6 column" style="border-right: 1px solid brown;">
						<!--- Title --->
						<label for="title">Title</label>
						<div class="form#Validation.title.class#">
							#Validation.title.text#
						</div>
						<div class="form-group">
							 <input type="text" name="title" value="#FORM.title#" class="form-control"/>
						</div>

						<!--- Link --->
						<label for="link">Link</label>
						<div class="form#Validation.link.class#">
							#Validation.link.text#
						</div>
						<div class="form-group">
						        <input type="text" name="link" value="#FORM.link#" class="form-control"/>
						</div>

						<!--- Menu tag --->
						<label for="tag">Menu tag</label>
						<div class="form#Validation.tag.class#">
							#Validation.tag.text#
						</div>
						<div class="form-group">
					       <select name="tag" id ="tag" class="form-control">
							  	<cfloop query="qGetMenu">
							  		<cfif #qGetMenu.menu_tag# eq #qGetMenuByID.menu_tag#>
										<cfset selected="selected"/>
									<cfelse>
										<cfset selected=""/>
									</cfif>
								  	<option 		  	
								  	value="#qGetMenu.menu_tag#" #selected#>#qGetMenu.menu_tag#
									</option>
								</cfloop>
							</select>
						</div>
					</div>
					<div class="col-md-6 column" style="border-right: 1px solid brown;">
						<!--- Priority --->
						<label for="priority">Priority</label>
						<div class="form#Validation.priority.class#">
						</div>
						<div class="form-group">
							 <input type="text" name="priority" value="#FORM.priority#" id="priority" class="form-control"/>
						</div>

						<!--- Parentid --->
						<label for="parentid">Parentid</label>
						<div class="form#Validation.parentid.class#">
						</div>
						<div class="form-group">
						        <input type="text" name="parentid" value="#FORM.parentid#" id="parentid"class="form-control"/>
						</div>

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
			</div>
		</div>

		<div class="div_center">
			<div class="alert alert-info">
				<button type="submit" class="btn btn-default btn_center">Submit</button>
			</div>
		</div>
</div>
</form>
</cfoutput>