<script type="text/javascript">
		$(document).ready(function () {
		    $('#product_group_add').dataTable({
                "sPaginationType": "full_numbers"
    		});
    		    
            $('.SelectAll').click( function(){
                $('.check-group').prop('checked', $(this).is(':checked'));
            });

            $('.btnSubmit').click( function(){
                var productID = '';
                 var groupID = '';
                $('.check-group:checked').each(function() {
                  productID += $(this).val() + ",";
                });
                productID =  productID.slice(0,-1);

                $('.option:selected').each(function() {
                  groupID += $(this).val();
                });
                
                window.location.href=".insert?productID="+productID+"&"+"groupID="+groupID;
            });

		});
	</script>
<cfoutput>
<h3 class="header-title"><a href="#buildUrl('productre')#"><span class="glyphicon glyphicon-circle-arrow-left"></span></a> Add Product Group</h3>
<form action="" method="POST">
    <div class="row clearfix">
        <div class="col-md-9">
            <cfquery name="qGetProduct">
                select * from product
            </cfquery>
                <table id="product_group_add" class="display">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Description</th>
                        <th>Price</th>
                        <th><input type="checkbox" class="SelectAll" /></th>
                    </tr>
                </thead>
                <tbody>
                    <cfloop query="qGetProduct">
                        <tr id="#qGetProduct.productID#">
                            <td class="id">#qGetProduct.productID#</td>
                            <td class="name">#qGetProduct.productName#</td>
                            <td class="description">#qGetProduct.description#</td>
                            <td class="price">#qGetProduct.price#</td>
                            <td class="action"><input type="checkbox" class="check-group" value="#qGetProduct.productID #"></td>
                        </tr>
                    </cfloop>
                </tbody>
            </table>
        </div>
        <div class="col-md-3">
            <cfquery name="qGetGroup">
                select * from groupre
            </cfquery>
            <select  class="form-control" >
            <cfloop query="qGetGroup">
              <option name="groupid" class="option" value="#qGetGroup.groupre_id#" >#qGetGroup.groupre_name#</option>
            </cfloop>
            </select>
            <br>
            <div class="btn-group">
                <button type="button" class="btnSubmit btn btn-default">Submit</button>
            </div>
        </div>        
</form>
</cfoutput>