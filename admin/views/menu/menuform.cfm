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
                	alert("priority is number");
                	return false;
                }
                else if(par=="")
                {
                	return true;
                }
                else if(isNaN(par) || par<0 )
                {
                	alert("parentid is number");
                	return false;
                }
                return true;
            }
</script>
<cfoutput>
<cfparam name="FORM.id"	type="integer" default="0"/>
<cfparam name="URL.id"	type="integer" default="0">
<cfparam name="menu_id" type="integer" default="1">

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
		<cfset Validation.isInvalid = true/>
	</cfif>

	<cfif NOT IsDefined('FORM.title') OR Len(Trim(FORM.title)) EQ 0>
		<cfset Validation.title.text = "Please input title."/>
		<cfset Validation.title.class = InvalidClass/>
		<cfset Validation.isInvalid = true/>
	</cfif>

	<cfif NOT IsDefined('FORM.link') OR Len(Trim(FORM.link)) EQ 0>
		<cfset Validation.link.text = "Please input link."/>
		<cfset Validation.link.class = InvalidClass/>
		<cfset Validation.isInvalid = true/>
	</cfif>

	<cfif NOT IsDefined('FORM.priority') OR Len(Trim(FORM.priority)) EQ 0>
		<!--- <cfset Validation.priority.text = "Please input priority."/> --->
		<cfset Validation.priority.class = InvalidClass/>
	</cfif>

	<cfif NOT IsDefined('FORM.parentid') OR Len(Trim(FORM.parentid)) EQ 0>
		<!--- <cfset Validation.parentid.text = "Please input parentid."/> --->
		<cfset Validation.parentid.class = InvalidClass/>

	</cfif>
	<cfif NOT  Validation.isInvalid>
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
						 <cfqueryparam sqltype="integer" value="#FORM.active#"/>,
						 <cfqueryparam sqltype="varchar" value="#FORM.tag#"/>,
						 <cfqueryparam sqltype="integer" value="#FORM.priority#"/>,
						 <cfqueryparam sqltype="integer" value="#FORM.parentid#"/>
						 )
					</cfquery>
			
			<cftransaction action="commit"/>
				<cfcatch>
					<cftransaction action="rollback"/>
						
				</cfcatch>
				</cftry>
			</cftransaction>
		 <cflocation url="#buildUrl('menu')#" />
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
		<cfset Validation.isInvalid = true/>
	</cfif>

	<cfif NOT IsDefined('FORM.title') OR Len(Trim(FORM.title)) EQ 0>
		<cfset Validation.title.text = "Please input title."/>
		<cfset Validation.title.class = InvalidClass/>
		<cfset Validation.isInvalid = true/>
	</cfif>

	<cfif NOT IsDefined('FORM.link') OR Len(Trim(FORM.link)) EQ 0>
		<cfset Validation.link.text = "Please input link."/>
		<cfset Validation.link.class = InvalidClass/>
		<cfset Validation.isInvalid = true/>
	</cfif>

	<cfif NOT IsDefined('FORM.priority') OR Len(Trim(FORM.priority)) EQ 0>
		<!--- <cfset Validation.priority.text = "Please input priority."/> --->
		<cfset Validation.priority.class = InvalidClass/>
	</cfif>

	<cfif NOT IsDefined('FORM.parentid') OR Len(Trim(FORM.parentid)) EQ 0>
		<!--- <cfset Validation.parentid.text = "Please input parentid."/> --->
		<cfset Validation.parentid.class = InvalidClass/>
	</cfif>

	<cfif NOT  Validation.isInvalid>

		<cftransaction isolation="serializable" action="begin">
			<cftry>
		<cfquery name="qUpdateMenu">
			update menu set 
				menu_name=<cfqueryparam sqltype="varchar" value="#FORM.title#"/>,
				menu_link=<cfqueryparam sqltype="varchar" value="#FORM.link#"/>,
				menu_isactive=<cfqueryparam sqltype="integer" value="#FORM.active#"/>,
				menu_tag=<cfqueryparam sqltype="varchar" value="#FORM.tag#"/>,
				menu_priority=<cfqueryparam sqltype="integer" value="#FORM.priority#"/>,
				menu_parentid=<cfqueryparam sqltype="integer" value="#FORM.parentid#"/>
				where menu_id=<cfqueryparam sqltype="integer" value="#FORM.id#"/>
		</cfquery>		
			<cftransaction action="commit"/>
				<cfcatch>
					<cftransaction action="rollback"/>
						<cfdump eval=cfcatch />
				</cfcatch>
			</cftry>
		</cftransaction>>
		 <cflocation url="#buildUrl('menu')#" />
		 </cfif>
	</cfcase>
</cfswitch>
	<cfparam name="Validation.title.text"     default="&nbsp;"/>
	<cfparam name="Validation.link.text"     default="&nbsp;"/>
	<cfparam name="Validation.active.text"     default="&nbsp;"/>
	<cfparam name="Validation.tag.text" 		default="&nbsp;"/>
<!--- 	<cfparam name="Validation.menu_priority.text" 		default="&nbsp;"/>
	<cfparam name="Validation.menu_parentid.text" 		default="&nbsp;"/> --->

	<cfparam name="Validation.tag.class" 		default=""/>
	<cfparam name="Validation.title.class"		default=""/>
	<cfparam name="Validation.active.class" 		default=""/>
	<cfparam name="Validation.link.class" 		default=""/>
	<cfparam name="Validation.menu_priority.class"		default=""/>
	<cfparam name="Validation.menu_parentid.class" 		default=""/>
	<cfparam name="Validation.isInvalid" 	default="false"/>
				<form action="" method="post" enctype="multipart/form-data">
					<input type="hidden" name="id" value="#FORM.id#"/>
					<table>
						<tr>
							<td>Title:
							</td>
							<td class="form#Validation.title.class#" >
								<p></p>
								<input type="text" name="title" value="#FORM.title#" size="50"/>
								<p>#Validation.title.text#</p>
							</td>
						</tr>

						<tr>
							<td>link:</td>
							<td class="form#Validation.link.class#" >
								<p></p>
								<input type="text" name="link" value="#FORM.link#" size="50"/>
								<p>#Validation.link.text#</p>
							</td>
						</tr>

						<tr>
							<td> menu tag:</td>

							<td class="form#Validation.tag.class#" >
								<p></p>
								<select name="tag" id ="tag">
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

								<p>#Validation.tag.text#</p>
							</td>
						</tr>

						<tr>
							<td>priority:</td>
							<p></p>
							<td class="form#Validation.menu_priority.class#" >
								<input type="text" name="priority" value="#FORM.priority#" size="50" id="priority"/>
								<!--- <p>#Validation.menu_priority.text#</p> --->
							</td>
						</tr>

						<tr>
							<td>parentid:</td>
							<td class="form#Validation.menu_parentid.class#" >
								<p></p>
								<input type="text" name="parentid" value="#FORM.parentid#" size="50" id="parentid"/>
								<!--- <p>#Validation.menu_parentid.text#</p> --->
							</td>
						</tr>
							
						<tr>
							<td >active:</td>
							<td class="form#Validation.active.class#">
								<p></p>
								<input type="radio" name="active" value="1"<cfif FORM.active> checked</cfif>/> Yes<br>
								<input type="radio" name="active" value="0"<cfif NOT FORM.active> checked</cfif>/> No<br>
								<p>#Validation.active.text#</p>
							</td>
						</tr>
						<tr>
							<td ></td>
							<td >
								<input type="submit" value="Submit" onclick="return kt()"/>
							</td>
						</tr>
					</table>
				</form>
	
			</cfoutput>