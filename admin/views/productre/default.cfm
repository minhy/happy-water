<script type="text/javascript">
	function checkDelete() {
	    if (confirm("Are you sure you want delete it?")) {
	        return true;
	    } else {
	        return false;
	    }
	};

	$(document).ready( function () {
	$('#table_id').dataTable({
	    "sPaginationType": "full_numbers"
	});	
	});
</script>
<cfoutput>
<cfquery name="qGetProductRe">
	select product.*,groupre.* from product_re,product ,groupre
	where product.productID=product_re.productid 
	and product_re.groupre_id =groupre.groupre_id
</cfquery>
<cfset stt=1>

<h3 class="header-title">Product Group Management</h3>

<form action="" method="post">
	<div class="row clearfix">
		<div class="col-md-9">
			<table class="table" id="table_id">
			<thead>
				<tr>
					<th>STT</th>
					<th>ID</th>
			        <th>Name</th>
			        <th>Description</th>
			        <th>Price</th>
			        <th>Group</th>
			        <th>Action</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="qGetProductRe">
					<tr>
						<td style="width:5%; text-align: center">
							#stt#
						</td>
						<td style="width:5%; text-align: center">
							#qGetProductRe.productID#
						</td>
						<td style="width:15%; text-align: center">
							#qGetProductRe.productName#
						</td>
						<td style="width:40%; text-align: center">
							#qGetProductRe.Description#
						</td>
						<td style="width:15%; text-align: center">
							#qGetProductRe.price#
						</td>
						<td style="width:15%; text-align: center">
							#qGetProductRe.groupre_name#
						</td>
						<td>
							<a href="#buildUrl('productre.delete')#?productID=#qGetProductRe.productID#&groupReID=#qGetProductRe.groupRe_id#" onclick ="return checkDelete()">
								<div class="btn-group btn-group-xs">
			  						<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-remove"></span> Delete</button>
			  					</div>
			  				</a>					
						</td>
					</tr>
					<cfset stt=stt+1>
				</cfloop>
			</tbody>
			</table>
		</div>
		<div class="col-md-3">
			<div class="btn-group">
				<a href="#buildUrl('productre.productreform')#">
  				<button type="button" class="btn btn-default"><span class="glyphicon glyphicon-plus"></span> Add Product Group</button>
  				</a>
			</div>
		</div>
</form>
</cfoutput>
