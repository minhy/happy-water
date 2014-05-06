<cfoutput>

<script type="text/javascript">
	function directlink(select,link){
		switch(select)
		{
			case "all":
				window.location = link + "/?select=all";
				break;
			case "new":
				window.location = link + "/?select=new";
				break;
			case "top":
				window.location = link + "/?select=top";
				break;
		}
	}

</script>

<div class="row clearfix">
	<div class="col-md-12 column">
		<div class="btn-group" style="margin-bottom: 15px;">
	 		<div class="btn-group">
		    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
		      Show Product By
		      <span class="caret"></span>
		    </button>
		    <ul class="dropdown-menu">
		      <li><a href="##" onclick="directlink('all','#buildUrl('product.show')#');">All</a></li>
		      <li><a href="##" onclick="directlink('new','#buildUrl('product.show')#');">New</a></li>
		      <li><a href="##" onclick="directlink('top','#buildUrl('product.show')#');">Top Deal</a></li>
		    </ul>
		    </div>
		</div>
	</div>
</div>
</cfoutput>