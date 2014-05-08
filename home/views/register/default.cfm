<script type="text/javascript">
function chkEmailUnique(theEmail){
  $.getJSON("../home/controllers/checkmail.cfc", {
   method: 'chkEmail',
   email: theEmail,
   returnformat: 'json'
   }, 

   function(isEmailUnique){  
   if (isEmailUnique == true) {
   $("#theErrorDivID").html('Please select a new Email');
   }
   else {
   $("#theErrorDivID").html('');
   }
   });
};
</script>
<cfparam name="FORM.firstname" default=""/>
<cfparam name="FORM.lastname" default=""/>
<cfparam name="FORM.email" default=""/>
<cfparam name="FORM.password" default=""/>

<cfparam name="FORM.month" default="1"/>
<cfparam name="FORM.day" default="1"/>
<cfparam name="FORM.year" default="1920"/>



<cfparam name="FORM.address" default=""/>
<cfparam name="FORM.confirm_password" default=""/>
<cfparam name="nameofphoto" default="default.jpg"/>
<cfparam name="Validation.email.text" default="&nbsp;"/>
<cfparam name="Validation.date.text" default="&nbsp;"/>

  
<cfif CGI.REQUEST_METHOD EQ 'POST'>

<cfquery name="qGetUserID" >
  SELECT userID
  FROM user
  ORDER BY userID Desc
  LIMIT 0,1
</cfquery>
  
 <cfset name_image =  #qGetUserID.userID+1#/> 

<cfif FORM.photo is not "">
  
 <cffile  action = "upload" 
          destination = "/./home/images/user-avatar/" 
          fileField = "photo" 
          nameConflict = "MakeUnique"/>
    
<cfset nameofphoto = #name_image# &"."& #cffile.clientfileext#/>
                
  <cffile 
  action="rename" 
  source="/./home/images/user-avatar/#cffile.clientfile#" 
  destination="/./home/images/user-avatar/#nameofphoto#"
  />
   
</cfif>


<cfquery name="qCountUser"  result="Result">
  SELECT * 
    FROM user
      WHERE email = <cfqueryparam cfsqltype="string" value="#FORM.email#"/>
</cfquery>

<cfif #result.RECORDCOUNT# GT 0>
  <cfset Validation.email.text = "Email has been taken"/>
  <cfelseif #DaysInMonth(#createDate(FORM.year,FORM.month,1)#)# LT FORM.day >
        <cfset Validation.date.text = "Invalid date" />
    <cfelse>
    <cftransaction isolation="serializable" action="begin">
      <cftry>   
        <cfquery name="qInsertUser">
          INSERT INTO user(firstName,lastName,address,dateofbirth,email,level,avatar,password,RegisterDate)
          Values (
            <cfqueryparam sqltype="string" value="#FORM.firstname#"/>,
            <cfqueryparam sqltype="string" value="#FORM.lastname#"/>,
            <cfqueryparam sqltype="string" value="#FORM.address#"/>,
            <cfqueryparam sqltype="string" value="#dateformat(#createDate("#FORM.year#","#FORM.month#","#FORM.day#")#, "yyyy-mm-dd")#"/>,
            <cfqueryparam sqltype="string" value="#FORM.email#"/>,
            '3',
            <cfif nameofphoto eq ''>
              <cfoutput>'#name_image#.jpg'</cfoutput>,
              <cfelse>
              <cfoutput>'#nameofphoto#'</cfoutput>,
            </cfif>

            <cfqueryparam sqltype="string" value="#Hash(#FORM.password#, "SHA")#"/>,
            <cfqueryparam sqltype="string" value="#dateformat(#now()#, "yyyy-mm-dd")#"/>
            );
        </cfquery>
        <cftransaction action="commit"/>
          <cfcatch>
            <cftransaction action="rollback"/>
            <cfdump var="#cfcatch#"/><cfabort>
          </cfcatch>
      </cftry>

    </cftransaction>    

    <script type="text/javascript">
    alert('registeration successfull');
    window.location.href='index.cfm/home:login';
    </script>
</cfif>
</cfif>

<cfoutput>
<link href="#getContextRoot()#/home/css/form.css" rel="stylesheet">
<link rel="stylesheet" href="#getContextRoot()#/home/css/jquery-ui.css">
</cfoutput>




          <cfoutput>
            <!--- <cfdump eval =CGI> --->
      <form id="registration-form" class="form-horizontal"  method ="post" enctype="multipart/form-data">
          
          <h1>Registration form </h1>
          <br/>
          <input type="hidden" name="hide" value="1"/>
          <div class="form-control-group">
            <label class="control-label" for="name">FirstName</label>
            <div class="controls">
              <input type="text" class="form-control" name="firstname" id="firstname" value ="#FORM.firstname#" style ="height:inherit;width:250px;float:left">
            </div>
          </div>
          

          <div class="form-control-group">
            <label class="control-label" for="name">Lastname</label>
            <div class="controls">
              <input type="text" class="form-control" name="lastname" id="lastname" value ="#FORM.lastname#" style ="height:inherit;width:250px;float:left">
            </div>
          </div>

          <div class="form-control-group">
            <label class="control-label" for="email">Email Address</label>
            <div class="controls">
              <input type="text" class="input-xlarge" name="email" id="email" value="#FORM.email#" style ="height:inherit;width:250px;float:left" onchange="return chkEmailUnique(this.value);">
              <p style="color:red;width:280px;height:0px"><b>#Validation.email.text#</b></p>
              <p id="theErrorDivID"></p>
            </div>
          </div>

          <div class="form-control-group">
            <label class="control-label" for="name">DateOfBirth</label>
            <select class="form-control" name="month" style ="width:70px ; margin-left :20px">
                <cfloop from="1" to="12" step="1" index="i">
                    <option value="#i#">#i#</option>           
                </cfloop>
            </select> 

            <select class="form-control" name="day" style ="width:70px ; margin-left :20px">
                <cfloop from="1" to="31" step="1" index="i">
                 <!--   <cfif i EQ 4>
                        <option value="#i#" selected>#i#</option>
                      <cfelse>
                  -->
                        <option value="#i#">#i#</option>
                  <!--  
                    </cfif>
                    -->

                </cfloop>
            </select> 

            <select class="form-control" name="year" style ="width:90px ; margin-left :20px">
                <cfloop from="1920" to="2014" step="1" index="i">
                    <option value="#i#">#i#</option>           
                </cfloop>
                
            </select> (mm-dd-yyyy)

            <p style="color:red;width:280px;height:0px;padding-left :160px"><b>#Validation.date.text#</b></p>
          </div>

          <div class="form-control-group">
            <label class="control-label" for="name">Password</label>
            <div class="controls">
              <input type="password" class="form-control" name="password" id="password" style ="height:inherit;float:left;width:250px">

            </div>
          </div>
          
          <div class="form-control-group">
            <label class="control-label" for="name"> Retype Password</label>
            <div class="controls">
              <input type="password" class="form-control" name="confirm_password" id="confirm_password" style="height:inherit;float:left;width:250px">
            </div>
          </div>
          
          <div class="form-control-group">
            <label class="control-label" for="name">Choose your avatar</label>
            <div class="controls">
              <input type="file" name="photo" id="photo">
            </div>
          </div>
          
          <div class="form-control-group">
            <label class="control-label" for="message">Your Address</label>
            <div class="controls">
              <textarea class="form-control" name="address" id="address" rows="3" value="#FORM.address#" style="float:left;width:250px">#FORM.address#</textarea>
            </div>
          </div>
          
          
          
          <div class="form-actions">
            <button type="submit" class="btn btn-success btn-large">Register</button>
            <button type="reset" class="btn">Cancel</button>
          </div>
  </cfoutput>
      </form>
    
<cfoutput>
<script src="#getContextRoot()#/home/js/jquery-1.7.1.min.js"></script> 

<script src="#getContextRoot()#/home/js/jquery.validate.js"></script> 

<script src="#getContextRoot()#/home/js/script.js"></script> 

</cfoutput>
<script>
		addEventListener('load', prettyPrint, false);
		$(document).ready(function(){
		$('pre').addClass('prettyprint linenums');
			});
		</script> 

</body>

 <!-- <script src="js/jquery-1.10.2.js"></script>
  <script src="js/jquery-ui.js"></script>
 
  <script>
  $(function() {
    $( "#datepicker" ).datepicker();
  });
  </script>
  -->
</html>
