<cfoutput>
<!DOCTYPE html>
<html lang="en">
	<head>
	  <meta charset="utf-8">
	  <title>HAPPY WATER</title>
	  <meta name="viewport" content="width=device-width, initial-scale=1.0">
	  <meta name="description" content="">
	  <meta name="author" content="">
		<link href="#getContextRoot()#/home/css/bootstrap.min.css" rel="stylesheet">
		<link href="#getContextRoot()#/home/css/style.css" rel="stylesheet">
		<link href="#getContextRoot()#/home/css/jquery-ui.css" rel="stylesheet">
		<script type="text/javascript" src="#getContextRoot()#/home/js/jquery.js"></script>
		<script type="text/javascript" src="#getContextRoot()#/home/js/jquery.min.js"></script>
		<script type="text/javascript" src="#getContextRoot()#/home/js/bootstrap.min.js"></script>
		<script type="text/javascript" src="#getContextRoot()#/home/js/scripts.js"></script>
		<script type="text/javascript" src="#getContextRoot()#/home/js/jquery-1.7.1.min.js"></script> 
		<script type="text/javascript" src="#getContextRoot()#/home/js/jquery.validate.js"></script>

	</head>
<body>    
	#view( "common/header" )#
	<div class="container wrap">
		<div class="wrap-main">
			#body#
		</div>
		#view( "common/bottom" )#
		#view( "common/footer" )#
	</div>
</body>
</html>
</cfoutput>