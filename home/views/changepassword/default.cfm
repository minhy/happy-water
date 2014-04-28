




<cfparam name="FORM.password" default=""/>
<cfparam name="FORM.old_pass" default=""/>
<cfparam name="Validation.oldpass.text" default="&nbsp;"/>

<cfoutput>
<cfif CGI.REQUEST_METHOD EQ 'POST'>
    <cfquery name="count" datasource="happy_water" result="Result">
      SELECT * 
        FROM user
          WHERE   userID   = <cfqueryparam cfsqltype="string" value="#Session.UserID#"/>
              AND password = <cfqueryparam cfsqltype="string" value="#Hash(#FORM.old_pass#, "SHA")#"/>
    </cfquery>

    <cfif #result.RECORDCOUNT# EQ 0>
      <cfset Validation.oldpass.text = "old password is not match your password"/>
    <cfelse>
      <cftransaction isolation="serializable" action="begin">
      <cftry>
        <cfquery name="insertdatabase" datasource="happy_water">
          UPDATE user
          SET
          password   =  <cfqueryparam sqltype="string" value="#Hash(#FORM.password#, "SHA")#"/>
          WHERE userID = <cfqueryparam sqltype="integer" value="#Session.UserID#"/>
          ;
        </cfquery>
        <cftransaction action="commit"/>
          <cfcatch>
            <cftransaction action="rollback"/>
            <cfdump var="#cfcatch#"/><cfabort>
          </cfcatch>
      </cftry>
      <script>
        alert('Your password has been changed success');
      </script>

    </cftransaction>
    </cfif>  
</cfif>


<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Change Password</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="#getContextRoot()#/home/css/style.css" rel="stylesheet">
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
          <h1 style="padding-left:150px">Change Password </h1>
          <br/>
          

          <div class="form-control-group">
            <label class="control-label" for="name">Old password</label>
            <div class="controls">
              <input type="password" class="input-xlarge" name="old_pass" id="old_pass" style ="height:inherit">
              <p style="color:red;width:280px;height:0px"><b>#Validation.oldpass.text#</b></p>
            </div>
          </div>
          

         <div class="form-control-group">
            <label class="control-label" for="name">New Password</label>
            <div class="controls">
              <input type="password" class="input-xlarge" name="password" id="password" style ="height:inherit">
            </div>
          </div>
          
          <div class="form-control-group">
            <label class="control-label" for="name"> Retype New Password</label>
            <div class="controls">
              <input type="password" class="input-xlarge" name="confirm_password" id="confirm_password" style="height:inherit">
            </div>
          </div>

 
          <div class="form-actions" style="padding-left:160px">
            <button type="submit" class="btn btn-success btn-large">Change</button>
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
<script>
    addEventListener('load', prettyPrint, false);
    $(document).ready(function(){
    $('pre').addClass('prettyprint linenums');
      });
    </script> 

</body>
</cfoutput>
 
</html>
