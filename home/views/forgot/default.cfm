<cfparam name="FORM.email" default=""/>
<cfparam name="check.mail.exist" default="&nbsp;"/>

<cfif CGI.REQUEST_METHOD EQ 'POST'>
    <cfquery name="qGetUser"  result="result">
    	SELECT * FROM user
    	WHERE email = <cfqueryparam cfsqltype="string" value="#FORM.email#">
      limit 0,1
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
            Hi, #qGetUser.firstName#
            Someone recently requested a password change for your account.If
            this was you, you can set a new password by click link below :
            http://#CGI.HTTP_HOST##getContextRoot()#/index.cfm/home:reset_password/?email=#qGetUser.email#&reset=#qGetUser.password#
            
          </cfoutput>
        </cfmail> 

        <script type="text/javascript">
        alert('We have just sent email to help reset your password please check your inbox or spam')

        </script>

    </cfif>


</cfif>



<cfoutput>
<div class="header-title">
  <h1>Reset password</h1>
</div>
<form id="registration-form" class="form-horizontal" action ="" method ="post" enctype="multipart/form-data" >
<div class="row clearfix">
  <div class="col-md-12 column">
    <font-size=+2>
    <p>Forgot your password? &nbsp;&nbsp;&nbsp;Enter your email address to reset your password.</p>
    </font-size>
    <div class="row clearfix">
      <div class="col-md-2 column">
        Email Address
      </div>
      <div class="col-md-10 column">
        <input type="text" class="input-xlarge" name="email" id="email" value="#FORM.email#" style ="height:inherit">
        <p style="color:red;width:280px;height:0px"><b>#check.mail.exist#</b></p>
      </div>

      <div class="col-md-2 column">
      </div>
      <div class="col-md-10 column">
        <button type="submit" class="btn btn-success btn-large">Reset</button>
      </div>
    </div>
  </div>
</div>
</form>
  </cfoutput>

