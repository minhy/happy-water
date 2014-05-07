<cfquery name="qGetUser" result="result">
  SELECT * FROM user
  WHERE userID = <cfqueryparam sqltype="integer" value="#Session.UserID#"/>
  LIMIT 0,1
</cfquery>

<cfif result.RECORDCOUNT EQ 0 >
  <cflocation url="error.cfm" addtoken="false">
  <cfelse>
<cfparam name="FORM.firstname" default="#qGetUser.firstName#"/>
<cfparam name="FORM.lastname" default="#qGetUser.lastName#"/>
<cfparam name="FORM.email" default="#qGetUser.email#"/>
<cfparam name="date" default="#qGetUser.dateofbirth#"/>
<cfparam name="FORM.address" default="#qGetUser.address#"/>
<cfparam name="nameofphoto" default=""/>
<cfparam name="FORM.month" default="1"/>
<cfparam name="FORM.day" default="1"/>
<cfparam name="FORM.year" default="1920"/>
<cfparam name="Validation.date.text" default="&nbsp;"/>
<cfset mo=listGetAt(#dateformat(date, "mm/dd/yyyy")#,1,"/")>
<cfset dy=listGetAt(#dateformat(date, "mm/dd/yyyy")#,2,"/")>
<cfset yr=listGetAt(#dateformat(date, "mm/dd/yyyy")#,3,"/")>

<cfif CGI.REQUEST_METHOD EQ 'POST'>
    <cfif #DaysInMonth(#createDate(FORM.year,FORM.month,1)#)# LT FORM.day >
        <cfset Validation.date.text = "Invalid date" />
    <cfelse>
    <cfif FORM.photo is not "">
       <cffile  action = "upload"
                destination = "/./home/images/user-avatar/#qGetUser.avatar#" 
                fileField = "photo" 
                nameConflict = "Overwrite"/>
    </cfif>
    <cftransaction isolation="serializable" action="begin">
      <cftry>
        <cfquery name="qUpdateUser">
          UPDATE user
          SET
          firstName   =  <cfqueryparam sqltype="string" value="#FORM.firstname#"/>,
          lastName    =  <cfqueryparam sqltype="string" value="#FORM.lastname#"/>,
          address     =  <cfqueryparam sqltype="string" value="#FORM.address#"/>,
          dateofbirth =  <cfqueryparam sqltype="string" value="#dateformat(#createDate("#FORM.year#","#FORM.month#","#FORM.day#")#, "yyyy-mm-dd")#"/>
          WHERE userID = <cfqueryparam sqltype="integer" value="#Session.UserID#"/>
          ;
        </cfquery>
        <cftransaction action="commit"/>
          <cfcatch>
            <cftransaction action="rollback"/>
            <cfdump var="#cfcatch#"/><cfabort>
          </cfcatch>
      </cftry>
    </cftransaction> 
    <cfset yr = FORM.year>
    <cfset mo = FORM.month>
    <cfset dy = FORM.day>
      </cfif>
</cfif>
<cfoutput>
<link href="#getContextRoot()#/home/css/form.css" rel="stylesheet">
<div class="header-title">
  <h1>Edit form</h1>
</div>

<form id="registration-form" class="form-horizontal" action ="" method ="post" enctype="multipart/form-data">
  <div class="row clearfix">
    <div class="col-md-12 column">
      <div class="row clearfix">
        <div class="col-md-2 column">
          <div id="imagesavatar" style=" height:160px;width:160px;float:left" >
            <img src="#getContextRoot()#/home/images/user-avatar/#qGetUser.avatar#" width ="160px" height ="160px" style="float:left;" >  
          </div>
        </div>

        <div class="col-md-10 column">
          <div class="col-md-4 column">
            Email Address
          </div>

          <div class="col-md-8 column">
            <input class="form-control" name="email" id="disabledInput" type="text" placeholder="#FORM.email#" style ="height:inherit;width:228px" disabled width="220px">
            <p></p>
          </div>
          <div class="col-md-12 column"> <br></div>
          <div class="col-md-4 column">
            FirstName
          </div>

          <div class="col-md-8 column">
            <input type="text" class="form-control" name="firstname" id="firstname" value ="#FORM.firstname#" style ="height:inherit ;width:228px;float:left">
            <p></p>
          </div>
           <div class="col-md-12 column"> <br></div>
          <div class="col-md-4 column">
            Lastname
          </div>

          <div class="col-md-8 column">
            <input type="text" class="form-control" name="lastname" id="lastname" value ="#FORM.lastname#" style ="height:inherit ;width:228px;float:left" >
            <p></p>
          </div>
           <div class="col-md-12 column"> <br></div>
          <div class="col-md-4 column">
            DateOfBirth
          </div>

          <div class="col-md-8 column">
              <select class="form-control" name="month" style ="width:70px; float: left ">
                <cfloop from="1" to="12" step="1" index="i">
                    <cfif i EQ #mo#>
                        <option value="#i#" selected>#i#</option>
                      <cfelse>
                  
                        <option value="#i#">#i#</option>
                   
                    </cfif>          
                </cfloop>
            </select> 

            <select class="form-control" name="day" style ="width:70px; float: left  ">
                <cfloop from="1" to="31" step="1" index="i">
                    <cfif i EQ #dy#>
                        <option value="#i#" selected>#i#</option>
                      <cfelse>               
                        <option value="#i#">#i#</option>     
                    </cfif> 
                </cfloop>
            </select> 

            <select class="form-control" name="year" style ="width:90px; float: left  ">
                <cfloop from="1920" to="2014" step="1" index="i">
                    <cfif i EQ #yr#>
                        <option value="#i#" selected>#i#</option>
                      <cfelse>
                        <option value="#i#">#i#</option>
                    </cfif>          
                </cfloop>
            </select>
            (mm-dd-yyyy)
            <p style="color:red"><br><b>#Validation.date.text#</b></p>
          </div>

          <div class="col-md-4 column">
            Choose your avatar
          </div>

          <div class="col-md-8 column">
            <input type="file" name="photo" id="photo">
            <p></p>
          </div>

          <div class="col-md-4 column">
            Your Address
          </div>

          <div class="col-md-8 column">
            <textarea class="input-xlarge" name="address" rows="3" Style="float:left">#FORM.address#</textarea>
            <p></p>
          </div>
           <div class="col-md-12 column"> <br></div>
          <div class="col-md-4 column">
          </div>

          <div class="col-md-8 column">
            <button type="submit" class="btn btn-success btn-large">Save</button>
          </div>

        </div>
      </div>
    </div>
  </div>
</cfoutput>
</cfif>
