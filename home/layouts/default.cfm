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
		<link rel="stylesheet" type="text/css" href="#getContextRoot()#/home/css/demo_table.css">
	    <link href="#getContextRoot()#/home/css/jquery-ui.css" rel="stylesheet">


		<script type="text/javascript" src="#getContextRoot()#/home/js/jquery.min.js"></script>

		<script src="#getContextRoot()#/home/js/jquery-ui.js"></script>
	    
		<script type="text/javascript" src="#getContextRoot()#/home/js/bootstrap.min.js"></script>
	    <script type="text/javascript" charset="utf-8" src="#getContextRoot()#/home/js/jquery.dataTables.js"></script>
		<script type="text/javascript" src="#getContextRoot()#/home/js/scripts.js"></script>
		<script language="javascript" src="#getContextRoot()#/home/ckeditor/ckeditor.js" type="text/javascript"></script>
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