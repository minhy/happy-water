


<cfparam name="FORM.email" default="">
<cfparam name="FORM.pass"  default="">
<cfparam name="Login.check.text"  default="">

<cfif CGI.REQUEST_METHOD EQ 'POST'>


<cfquery name="check_login" datasource="happy_water" result="result">
	SELECT * FROM user
	WHERE email = <cfqueryparam cfsqltype="string" value="#FORM.email#">
		AND password = <cfqueryparam cfsqltype="string" value="#Hash(#FORM.pass#, "SHA")#">
</cfquery>

<cfif #result.RECORDCOUNT# EQ 0>
	<cfset Login.check.text ="Login failed">
	<cfelse>
		<script>
			alert('login successfull');
			<cfoutput>EARERAEREARE</cfoutput>
		</script>
		<cfif  #check_login.level[1]# EQ 0>
			<cfset Login.check.text ="user has been banned">
		<cfelseif #check_login.level[1]# EQ 1 OR #check_login.level[1]# EQ 2>
        
              <cfset SESSION.isLoggedIn = true>
              <cfset SESSION.Admin      = true>
              <cfset SESSION.userID     = #check_login.userID[1]#>
              <cfset SESSION.name       = #check_login.firstName[1]#>
               <cflocation url="#getContextRoot()#/index.cfm/admin" addtoken="false">
        
			<!--
			Set admin SESSION here
			SESSION.Admin = result.level[1]
			SESSION.User  = result.userID[1]
			direct to admin page
			-->
		<cfelse>
        
              <cfset SESSION.isLoggedIn = true>
              <cfset SESSION.Admin      = false>
              <cfset SESSION.userID     = #check_login.userID[1]#>
              <cfset SESSION.name       = #check_login.firstName[1]#>
              <cflocation url="#getContextRoot()#/index.cfm" addtoken="false"> 
        <!--- </cflock> --->
           
			<!--
			Set user set user session
			Session.User = result.userID[1]
			direct to home page
			-->
		</cfif>
</cfif>
</cfif>


<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Login</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<cfoutput>

<link href="#getContextRoot()#/home/css/style1.css" rel="stylesheet">
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
      
      <form id="registration-form" class="form-horizontal" action ="" method ="post" enctype="multipart/form-data" > <!-- style ="background-color:#eeeeee" -->
       <cfoutput>
        
          <br/>
          
         <fieldset>

         	<legend ><h1>Login</h1></legend>
          <div class="form-control-group">
            <label class="control-label" for="email">Email Address</label>
            <div class="controls">
              <input type="text" class="input-xlarge" name="email" id="email" value="#FORM.email#" style ="height:inherit">
              <p style="color:red;width:280px;height:0px"><b>#Login.check.text#</b></p>
            </div>
          </div>

        
          <div class="form-control-group">
            <label class="control-label" for="name">Password</label>
            <div class="controls">
              <input type="password" class="input-xlarge" name="pass" style ="height:inherit" >
            </div>
          </div>
          
           <div class="form-control-group">
            
            <div class="controls">
              <input type="checkbox" class="checkbox" name="remember" style ="height:inherit" > Remember me?
            </div>

          </div>         

          <div class="form-control-group" style="padding-left:300px">
            <label class="control-label" for="forgot">
              <a href="#getContextRoot()#/index.cfm/forgot">forgot password?</a>
            </label>
          </div>

          <div class="form-actions">
            <button type="submit" class="btn btn-success btn-large">Login</button>
          
          </div>

      </fieldset>
  </cfoutput>
      </form>
    </div>
    <!-- .span --> 
  </div>
  <!-- .row -->
  
</div>
<!-- .container --> 

</body>


