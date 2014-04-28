


<cfparam name="FORM.email" default=""/>
<cfparam name="check.mail.exist" default="&nbsp;"/>

<cfif CGI.REQUEST_METHOD EQ 'POST'>
    <cfquery name="reset" datasource="happy_water" result="result">
    	SELECT * FROM user
    	WHERE email = <cfqueryparam cfsqltype="string" value="#FORM.email#">
    </cfquery>
    <cfif #result.RECORDCOUNT# EQ 0>
        <cfset check.mail.exist = "No account with that e-mail address exists."/>
    <cfelse>
        <cfset mailAttributes = {
                server="smtp.gmail.com",
                username="nguyen.hoang.thien1410@gmail.com",
                password="0914735651",
                from="nguyen.hoang.thien1410@gmail.com",
                to="#FORM.email#",
                subject="Reset password"
                }
        />
        <cfmail port="465" useSSL="true" attributeCollection="#mailAttributes#">
          <cfoutput>
            Hi, #reset.firstName[1]#
            Someone recently requested a password change for your account.If
            this was you, you can set a new password by click link below :
            http://rasia:8888#getContextRoot()#/index.cfm/home:reset_password/?email=#reset.email[1]#&reset=#reset.password[1]#
            
          </cfoutput>
        </cfmail>

        <script type="text/javascript">
        alert('We have just sent email to help reset your password please check your inbox or spam')

        </script>

    </cfif>


</cfif>


<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Forgot password</title>
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
      
      <form id="registration-form" class="form-horizontal" action ="" method ="post" enctype="multipart/form-data" >
       <cfoutput>
        
          <br/>
          
         <fieldset>

         	<legend><h1>Reset password</h1></legend>
          <font-size=+2>
          <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Forgot your password? &nbsp;&nbsp;&nbsp;Enter your email address to reset your password.</p>
          </font-size>
          <div class="form-control-group">
            <label class="control-label" for="email">Email Address</label>
            <div class="controls">
              <input type="text" class="input-xlarge" name="email" id="email" value="#FORM.email#" style ="height:inherit">
              <p style="color:red;width:280px;height:0px"><b>#check.mail.exist#</b></p>
            </div>
          </div>

          <div class="form-actions">
            <button type="submit" class="btn btn-success btn-large">Reset</button>
          
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


