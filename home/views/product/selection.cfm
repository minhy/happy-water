<cfoutput>
<cfset alllink = #buildUrl('product.all')#>
<cfset newlink = #buildUrl('product.new')#>
<cfset toplink = #buildUrl('product.topdeal')#>
<div class="row clearfix">
	<div class="col-md-12 column">
		<!--- <div class="btn-group-vertical" style="width:100%;" >
			<button class="btn btn-primary" style="margin-bottom:5px;" onclick="window.location='#alllink#';">All product</button>
			<button class="btn btn-primary" style="margin-bottom:5px;" onclick="window.location='#newlink#';">New Product</button>
			<button class="btn btn-primary" style="margin-bottom:5px;" onclick="window.location='#toplink#';">Top Deal</button>
		</div> --->
		<div class="btn-group" style="margin-bottom: 15px;">
	 		<div class="btn-group">
		    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
		      Show Product By
		      <span class="caret"></span>
		    </button>
		    <ul class="dropdown-menu">
		      <li><a href="#alllink#">All</a></li>
		      <li><a href="#newlink#">New</a></li>
		      <li><a href="#toplink#">Top Deal</a></li>
		    </ul>
		    </div>
		</div>
</div>
</cfoutput>