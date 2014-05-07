
<cfparam name="FORM.remember" default=false>
<cfparam name="FORM.email" default="">
<cfparam name="FORM.pass"  default="">
<cfparam name="Login.check.text"  default="">

<cfif CGI.REQUEST_METHOD EQ 'POST'>

<cfquery name="qCheckUser"  result="result">
	SELECT * FROM user
	WHERE email = <cfqueryparam cfsqltype="string" value="#FORM.email#">
		AND password = <cfqueryparam cfsqltype="string" value="#Hash(#FORM.pass#, "SHA")#">
    limit 0,1
</cfquery>

<cfif #result.RECORDCOUNT# EQ 0>
	<cfset Login.check.text ="Login failed">
	<cfelse>
		<script>
			alert('login successfull');
		</script>
		<cfif  #qCheckUser.level# EQ 0>
			<cfset Login.check.text ="user has been banned">
		<cfelseif #qCheckUser.level# EQ 1 OR #qCheckUser.level# EQ 2>
        
              <cfset SESSION.isLoggedIn = true>
              <cfset SESSION.isAdmin    = true>
              <cfset SESSION.userID     = #qCheckUser.userID#>
              <cfset SESSION.Level      = #qCheckUser.level#>
              <cfset SESSION.name       = #qCheckUser.firstName#>
              <cflocation url="#getContextRoot()#/index.cfm" addtoken="false">
		<cfelse>
        
              <cfset SESSION.isLoggedIn = true>
              <cfset SESSION.isAdmin    = false>
              <cfset SESSION.userID     = #qCheckUser.userID#>
              <cfset SESSION.Level      = #qCheckUser.level#>
              <cfset SESSION.name       = #qCheckUser.firstName#>
    <cflocation url="#getContextRoot()#/index.cfm" addtoken="false"> 

		</cfif>
</cfif>
</cfif>
<cfoutput>
  <link href="#getContextRoot()#/home/css/form.css" rel="stylesheet">
<div class="header-title">
  <h1>Login</h1>
</div>
<form id="registration-form" class="form-horizontal" action ="" method ="post" enctype="multipart/form-data" >
  <div class="row clearfix">
    <div class="col-md-12 column">
      <div class="row clearfix">

        <div class="col-md-2 column">
          Email Address
        </div>
        <div class="col-md-10 column">
          <input type="text" class="input-xlarge" name="email" id="email" value="#FORM.email#" style ="height:inherit">
          <p style="color:red;width:280px;height:0px"><b>#Login.check.text#</b></p>
        </div>

        <div class="col-md-2 column">
          Password        
        </div>
        <div class="col-md-10 column">
          <input type="password" class="input-xlarge" name="pass" style ="height:inherit" >
        </div>

        <div class="col-md-2 column">
        
        </div>
        <div class="col-md-10 column">
          <input type="checkbox" class="checkbox" name="remember" style ="height:inherit; float:left" value ="true" ><p style="float: left; line-height:200%">Remember me?</p>
        </div>

        <div class="col-md-2 column">
        
        </div>
        <div class="col-md-10 column">
          <button type="submit" class="btn btn-success btn-large">Login</button>
          <a href="#getContextRoot()#/index.cfm/forgot">forgot password?</a>
        </div>
      </div>
    </div>
  </div>
</form>
</cfoutput>
