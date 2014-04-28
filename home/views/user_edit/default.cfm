


<cfquery name="show" datasource="happy_water" result="result">
  SELECT * FROM user
  WHERE userID = <cfqueryparam sqltype="integer" value="#Session.UserID#"/>
</cfquery>

<cfif result.RECORDCOUNT EQ 0 >
  <cflocation url="error.cfm" addtoken="false">
  <cfelse>




<cfparam name="FORM.firstname" default="#show.firstName[1]#"/>
<cfparam name="FORM.lastname" default="#show.lastName[1]#"/>
<cfparam name="FORM.email" default="#show.email[1]#"/>
<cfparam name="date" default="#show.dateofbirth[1]#"/>
<cfparam name="FORM.address" default="#show.address[1]#"/>
<cfparam name="nameofphoto" default=""/>
<cfparam name="FORM.month" default="1"/>
<cfparam name="FORM.day" default="1"/>
<cfparam name="FORM.year" default="1920"/>



<cfset mo=listGetAt(#dateformat(date, "mm/dd/yyyy")#,1,"/")>
<cfset dy=listGetAt(#dateformat(date, "mm/dd/yyyy")#,2,"/")>
<cfset yr=listGetAt(#dateformat(date, "mm/dd/yyyy")#,3,"/")>


<cfif CGI.REQUEST_METHOD EQ 'POST'>

    <cfif FORM.photo is not "">
       <cffile  action = "upload" 
                destination = "/./home/images/user-avatar/#show.avatar[1]#" 
                fileField = "photo" 
                nameConflict = "Overwrite"/>
    </cfif>

    <cftransaction isolation="serializable" action="begin">
      <cftry>
        <cfquery name="insertdatabase" datasource="happy_water">
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

<cfoutput>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Edit user</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="#getContextRoot()#/home/css/form.css" rel="stylesheet">
<link rel="stylesheet" href="#getContextRoot()#/home/css/jquery-ui.css">

</cfoutput>


</head>
<body>
<div class="container">
  <div class="row-fluid">
    <div class="span12">
    
    </div>
  </div>
  <div class="row-fluid">
  <div class="span6 offset6">
    <div id="maincontent" class="span8"> 
      
      <form id="registration-form" class="form-horizontal" action ="" method ="post" enctype="multipart/form-data">
       <cfoutput>
          <h1 style="padding-left:200px">Edit form </h1>
          <br/>
          <div id="imagesavatar" style=" height:160px;width:160px;float:left" >
            <img src="#getContextRoot()#/home/images/user-avatar/#show.avatar[1]#" width ="160px" height ="160px" style="float:left;" >  
          </div>

          <div class="form-control-group" style="float:left">
            <label class="control-label" for="email">Email Address</label>
            <div class="controls">
              <input class="form-control" name="email" id="disabledInput" type="text" placeholder="#FORM.email#" style ="height:inherit;width:228px" disabled width="220px">

            </div>
          </div>


          <div class="form-control-group" style="float:left">
            <label class="control-label" for="name">FirstName</label>
            <div class="controls">
              <input type="text" class="input-xlarge" name="firstname" id="firstname" value ="#FORM.firstname#" style ="height:inherit ;width:228px">
            </div>
          </div>
          

          <div class="form-control-group" style="float:left">
            <label class="control-label" for="name">Lastname</label>
            <div class="controls">
              <input type="text" class="input-xlarge" name="lastname" id="lastname" value ="#FORM.lastname#" style ="height:inherit ;width:228px" >
            </div>

          </div>
          
          <div class="form-control-group" style="float:left;padding-left:160px">
            <label class="control-label" for="name">DateOfBirth</label>
            <div class="controls">

              <select class="form-control" name="month" style ="width:70px ">
                <cfloop from="1" to="12" step="1" index="i">
                    <cfif i EQ #mo#>
                        <option value="#i#" selected>#i#</option>
                      <cfelse>
                  
                        <option value="#i#">#i#</option>
                   
                    </cfif>          
                </cfloop>
            </select> 

            <select class="form-control" name="day" style ="width:70px ">
                <cfloop from="1" to="31" step="1" index="i">
                    <cfif i EQ #dy#>
                        <option value="#i#" selected>#i#</option>
                      <cfelse>
                  
                        <option value="#i#">#i#</option>
                   
                    </cfif> 
                    

                </cfloop>
            </select> 

            <select class="form-control" name="year" style ="width:90px ">
                <cfloop from="1920" to="2014" step="1" index="i">
                    <cfif i EQ #yr#>
                        <option value="#i#" selected>#i#</option>
                      <cfelse>
                  
                        <option value="#i#">#i#</option>
                   
                    </cfif>          
                </cfloop>
            </select> (mm-dd-yyyy)

            </div>

          </div>

          <div class="form-control-group" style="padding-left:160px;float:left">
            <label class="control-label" for="name">Choose your avatar</label>
            <div class="controls">
              <input type="file" name="photo" id="photo">
            </div>
          </div>
          
          <div class="form-control-group" style="padding-left:160px;float:left">
            <label class="control-label" for="message">Your Address</label>
            <div class="controls">
              <textarea class="input-xlarge" name="address" rows="3">#FORM.address#</textarea>
            </div>
          </div>
          
          
          
          <div class="form-actions" style="padding:17px 270px;padding-left:320px;float:left">
            <button type="submit" class="btn btn-success btn-large">Edit</button>
            
          </div>
  </cfoutput>
      </form>
    </div>
    <!-- .span --> 
  </div>
  <!-- .row -->
  
</div>
<!-- .container --> 
<cfoutput>
<script src="#getContextRoot()#/home/js/jquery-1.7.1.min.js"></script> 

<script src="#getContextRoot()#/home/js/jquery.validate.js"></script> 

<script src="#getContextRoot()#/home/js/script.js"></script> 
</cfoutput>


</body>

 
</html>
</cfif>