<cfparam name="FORM.password" default=""/>



<cfif not IsDefined("URL.email") and not IsDefined("URL.reset")>
	<cfoutput> page not found </cfoutput>
<cfelse>	
	<cfquery name="count" datasource="happy_water" result="result">
		SELECT*
		FROM user
		WHERE email  = <cfqueryparam cfsqltype="string" value="#URL.email#"/>
		AND  password = <cfqueryparam cfsqltype="string" value="#URL.reset#"/>
	</cfquery>
	<cfif result.RECORDCOUNT EQ 0 >
		<cfoutput> page not found </cfoutput>

<cfelse>
	<cfif CGI.REQUEST_METHOD EQ 'POST'>
		<cftransaction isolation="serializable" action="begin">
      <cftry>
        <cfquery name="insertdatabase" datasource="happy_water">
          UPDATE user
          SET
          password   =  <cfqueryparam sqltype="string" value="#Hash(#FORM.password#, "SHA")#"/>
          WHERE email = <cfqueryparam sqltype="string" value="#URL.email#"/>
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
      <cflocation url="#getContextRoot()#/index.cfm/home:login" addtoken="false">
    </cftransaction>
	</cfif>


<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Reset Password</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<cfoutput>

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
          <h1 style="padding-left:150px">Reset Password </h1>
          <br/>
          
  

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

</cfoutput>

</body>

 
</html>

</cfif>

</cfif>