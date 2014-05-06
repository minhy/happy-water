<script>
    addEventListener('load', prettyPrint, false);
    $(document).ready(function(){
    $('pre').addClass('prettyprint linenums');
      });
</script> 

<cfoutput>
<cfparam name="FORM.password" default=""/>
<cfparam name="FORM.old_pass" default=""/>
<cfparam name="Validation.oldpass.text" default="&nbsp;"/>

<cfif CGI.REQUEST_METHOD EQ 'POST'>
    <cfquery name="qCountUser"  result="Result">
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
        <cfquery name="UpdateUser" >
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
<div class="header-title">
  <h1>Change Password </h1>
</div>
<form id="registration-form" class="form-horizontal" action ="" method ="post" enctype="multipart/form-data">
  <div class="row clearfix">
    <div class="col-md-12 column">
      <div class="row clearfix">

        <div class="col-md-2 column">
         Old password
        </div>
        <div class="col-md-10 column">
          <div class="controls">
            <input type="password" class="input-xlarge" name="old_pass" id="old_pass" style ="height:inherit">
            <p style="color:red;width:280px;height:0px"><b>#Validation.oldpass.text#</b></p>
          </div>
        </div>
          
        <div class="col-md-2 column">
         New Password
        </div>
        <div class="col-md-10 column">
          <div class="controls">
            <input type="password" class="input-xlarge" name="password" id="password" style ="height:inherit">
            <p></p>
          </div>
        </div>
          
        <div class="col-md-2 column">
          Retype New Password
        </div>
        <div class="col-md-10 column">
          <div class="controls">
            <input type="password" class="input-xlarge" name="confirm_password" id="confirm_password" style="height:inherit">
            <p></p>
          </div>
        </div>

        <div class="col-md-2 column">

        </div>
        <div class="col-md-10 column">
          <button type="submit" class="btn btn-success btn-large">Change</button>
        </div>

      </div>
    </div>
  </div>
</form>
</cfoutput>

