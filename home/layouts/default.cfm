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
		<script type="text/javascript" src="#getContextRoot()#/home/js/jquery.min.js"></script>
		<script type="text/javascript" src="#getContextRoot()#/home/js/bootstrap.min.js"></script>
		<script type="text/javascript" src="#getContextRoot()#/home/js/script.js"></script>
		<link rel="stylesheet" href="//code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.css">
		  <script src="//code.jquery.com/jquery-1.10.2.js"></script>
		  <script src="//code.jquery.com/ui/1.10.4/jquery-ui.js"></script>
			 <script>
			  $(function() {
			    $( document ).tooltip();
			  });
			  </script>
			  <style>
			  label {
			    display: inline-block;
			    width: 5em;
			  }
			  </style>

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