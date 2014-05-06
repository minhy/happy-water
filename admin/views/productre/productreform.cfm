<script type="text/javascript">
		$(document).ready(function () {
		    $('#product_group_add').dataTable({
                "bJQueryUI": true,
                "sPaginationType": "full_numbers",
                    "aoColumnDefs" : [ {
                    'bSortable' : false,
                    'aTargets' : [ 4 ]
                } ]
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

            function test(sel) {
            //alert(sel.options[sel.selectedIndex].value);
             window.location.href="productreform?groupid="+sel.options[sel.selectedIndex].value;
    };
	</script>
<cfoutput>
    <cftry>
        <cfparam name="URL.groupid" default="g1"/>
        <cfset groupid=URL.groupid/>
        <cfcatch>
         <cfset groupid="g1"/>
        </cfcatch>
    </cftry>
  
<h3 class="header-title"><a href="#buildUrl('productre')#"><span class="glyphicon glyphicon-circle-arrow-left"></span></a> Add Product Group</h3>
<form action="" method="POST">
    <div class="row clearfix">
        <div class="col-md-9">
            <cfquery name="qGetProduct">
                    select product.* from product ,product_re 
                    where product.productID not in
                     (select productid from product_re where groupre_id='#groupid#')
                    group by product.productID
            </cfquery>
                <table id="product_group_add" class="display">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Description</th>
                        <th>Price</th>
                        <th id="select-all"><input type="checkbox" class="SelectAll" /></th>
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
            <select  class="form-control" onchange="test(this)" >
            <cfloop query="qGetGroup">
            <cfif #qGetGroup.groupre_id# eq #URL.groupid#>
                    <cfset selected="selected"/>
                <cfelse>
                    <cfset selected=""/>
            </cfif>
              <option name="groupid" class="option" value="#qGetGroup.groupre_id#" #selected#  >#qGetGroup.groupre_name#</option>
            </cfloop>
            </select>
            <br>
            <div class="btn-group">
                <button type="button" class="btnSubmit btn btn-default">Submit</button>
            </div>
        </div>        
</form>
</cfoutput>