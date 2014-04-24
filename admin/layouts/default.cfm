<cfoutput>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>ADMINSTRATOR</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="">
  <meta name="author" content="">	
	<link href="#getContextRoot()#/admin/css/bootstrap.min.css" rel="stylesheet">
	<link href="#getContextRoot()#/admin/css/style.css" rel="stylesheet">
	<link rel="stylesheet" type="text/css" href="#getContextRoot()#/admin/css/demo_table.css">
    <link href="#getContextRoot()#/admin/css/jquery-ui.css" rel="stylesheet">
	<script type="text/javascript" src="#getContextRoot()#/admin/js/jquery.min.js"></script>
	<script src="#getContextRoot()#/admin/js/jquery-ui.js"></script>    
	<script type="text/javascript" src="#getContextRoot()#/admin/js/bootstrap.min.js"></script>
    <script type="text/javascript" charset="utf-8" src="#getContextRoot()#/admin/js/jquery.dataTables.js"></script>
	<script type="text/javascript" src="#getContextRoot()#/admin/js/scripts.js"></script>
	<script language="javascript" src="#getContextRoot()#/admin/ckeditor/ckeditor.js" type="text/javascript"></script>
</head>

<body>
	#view("common/header")#
<section id="main">
	<div class="container main">
	<div class="row clearfix">
		<div class="col-md-12 column">
			<div class="row clearfix">
				<div class="col-md-12 column">
					#view("common/menu")#
				</div>
				<div class="col-md-12 column">
					#body#
				</div>
			</div>
		</div>
	</div>
	</div>
</section>
<footer id="footer">
	<div class="container">
	<div class="row clearfix">
		<div class="col-md-12 column">
			© 2014 - HAPPY WATER - ALL RIGHTS RESERVED
		</div>
	</div>
	</div>
</footer>
</body>
</html>
</cfoutput>