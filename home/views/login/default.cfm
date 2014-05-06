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
<link rel="stylesheet" href="#getContextRoot()#/home/css/jquery-ui.css">

</cfoutput>

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
              <input type="checkbox" class="checkbox" name="remember" style ="height:inherit" value ="true" > Remember me?
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

