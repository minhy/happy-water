<cfoutput>
<cfset login = #buildUrl('login.default')#>
<cfset registry = #buildUrl('register')#>
<div class="col-md-6 column">

	<label>If you're had a account. Please press this button below.</label><br>
	<div class="form-group">
		<div class="clearfix">
			<a class="btn btn-success btn-large" href="#login#">Log In</a>
		</div>
		<div class="clearfix">
		  	<a href="#getContextRoot()#/index.cfm/forgot" style="color:red;">forgot password ?</a>
		</div>
	</div>
	<label>Or not. <br>Please press this button below to registry !</label><br>
	<div class="form-group">
		<div class="clearfix">
			<a class="btn btn-info btn-large" href="#login#">Registry</a>
		</div>
	</div>
</div>
</cfoutput>
