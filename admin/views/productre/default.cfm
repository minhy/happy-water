<script type="text/javascript">
	$(document).ready( function () {
	$('#table_id').dataTable({
	    "sPaginationType": "full_numbers"
	});

	function checkDelete() {
	    if (confirm("Are you sure you want delete it?")) {
	        return true;
	    } else {
	        return false;
	    }
	}
	
	} );
</script>
<cfoutput>
<cfquery name="qGetProductRe">
	select product.*,groupre.* from product_re,product ,groupre
	where product.productID=product_re.productid 
	and product_re.groupre_id =groupre.groupre_id
</cfquery>
<cfset stt=1>

<h3 class="header-title">Product Group Management <a href="#buildUrl('productre.productreform')#">[add]</a>
</h3>

<form action="" method="post">
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
				<td>
					#stt#
				</td>
				<td>
					#qGetProductRe.productID#
				</td>
				<td>
					#qGetProductRe.productName#
				</td>
				<td>
					#qGetProductRe.Description#
				</td>
				<td>
					#qGetProductRe.price#
				</td>
				<td>
					#qGetProductRe.groupre_name#
				</td>
				<td>
					
					<a href="#buildUrl('productre.delete')#?productID=#qGetProductRe.productID#&groupReID=#qGetProductRe.groupRe_id#" onclick ="return checkDelete()">[delete]</a>
				</td>
			</tr>
			<cfset stt=stt+1>
		</cfloop>
	</tbody>
	</table>
</form>
</cfoutput>
