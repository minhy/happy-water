<cfoutput>
<div class="col-md-6 column">

	<label>Hi! #user_name#</label><br>
	<label>Your Name</label>
	<div class="form-group">
		<div class="clearfix">
			<input type="text" class="form-control" id="user_name" name="user_name" value="#user_name#"/>
		</div>
	</div>

	<label>Your address</label>
	<div class="form-group">
		<div class="clearfix">
			<textarea type="text" class="form-control" name="user_address" id="user_address" value="#user_address#"></textarea>
		</div>
	</div>
	<label>If you use this information to delvery. Please press this button below.</label>
	<div class="form-group">
		<div class="clearfix">
		  	<a class="btn btn-success btn-large" >Get it !</a>
		</div>
	</div>
</div>
</cfoutput>