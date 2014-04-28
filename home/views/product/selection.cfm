<cfoutput>
<cfset alllink = #buildUrl('product.all')#>
<cfset newlink = #buildUrl('product.new')#>
<cfset toplink = #buildUrl('product.topdeal')#>
<div class="row clearfix">
	<div class="col-md-12 column">
		<div class="btn-group-vertical" style="width:100%;" >
			<button class="btn btn-primary" style="margin-bottom:5px;" onclick="window.location='#alllink#';">All product</button>
			<button class="btn btn-primary" style="margin-bottom:5px;" onclick="window.location='#newlink#';">New Product</button>
			<button class="btn btn-primary" style="margin-bottom:5px;" onclick="window.location='#toplink#';">Top Deal</button>
		</div>
	</div>
</div>
</cfoutput>