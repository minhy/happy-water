<cfparam name="productID" default="0">
    <cfoutput>
        <cftry>
            <cfif #productID# neq 0>
                <cfquery name="qDelete">
                    delete from product
                    where productID = <cfqueryparam value="#url.productID#" cfsqltype="cf_sql_integer">
                </cfquery>
                <script type="text/javascript">
                    alert("This product was deleted !!!");
                    window.location.href= "#buildUrl('product.default')#";
                </script>
            </cfif>
            <cfcatch>
                <script type="text/javascript">
                    alert("Can't delete this product");
                    window.location.href= "#buildUrl('product.default')#";
                </script>
            </cfcatch>    
        </cftry>
    </cfoutput>
        
    <cfquery name="qShowAll">
    SELECT *
    FROM product
    </cfquery>    

    
    

    <script type="text/javascript">
        $(document).ready( function () {
            $('#table_id').dataTable({
                "sPaginationType": "full_numbers"
            });
            
        } );

        function chuyentrang(status, id, url){
            switch(status)
            {
                case 1:
                    window.location.href= url + "?productID=0";
                    break;
                case 2:
                    window.location.href= url +"?productID="+ id;
                    break;
                case 3:
                    if(confirm("Are you sure ???") == true){
                        window.location.href= url +"?productID="+ id;
                    }
                    break;
            }
        }

    </script>
<cfoutput>
    <table id="table_id" class="display">
        <thead>
            <tr>
                <th>Product ID</th>
                <th>Product Name</th>
                <th>Selling</th>
                <th>In stock</th>
                <th>Price</th>
                <th>Image</th>
                <th>Date updating</th>
                <th>Category</th>
                <th>Brand</th>
                <th></th>
            </tr>
        </thead>
        <tbody>
            <cfloop query="qShowAll">
                <tr id="#qShowAll.productID#">
                    <td class="col-md-1 column">#qShowAll.productID#</td>
                    <td class="col-md-2 column">#qShowAll.productName#</td>
                    <td class="col-md-1 column">
                        <cfif #qShowAll.IsActive# eq 1>
                            Yes
                        <cfelse> No
                        </cfif>
                    </td>
                    <td class="col-md-1 column">
                        <cfif #qShowAll.status# eq 1>
                            Yes
                        <cfelse> No
                        </cfif>
                    </td>
                    <td class="col-md-1 column">#qShowAll.price#</td>
                    <td class="col-md-1 column"><img src="#getContextRoot()##qShowAll.image#" width="50" height="50"/></td>
                    <td class="col-md-1 column">#dateformat(#qShowAll.productDate#,"dd/mm/yyyy")#</td>
                    <td class="categoryID">
                        <cfquery name="categoryName">
                            SELECT categoryName
                            FROM Category
                            WHERE categoryID = #qShowAll.categoryID#
                        </cfquery>
                        #categoryName.categoryName#
                    </td>
                    <td class="brandID">
                        <cfquery name="brandName">
                            SELECT brandName
                            FROM Brand
                            WHERE brandID = #qShowAll.brandID#
                        </cfquery>
                        #brandName.brandName#
                    </td>
                    <td class="col-md-3 column">
                        <div class="btn-group btn-group-xs">
                            <button type="button" class="btn btn-default" onclick="chuyentrang(1,'#qShowAll.productID#', '#buildUrl('product.admin_products_editor')#');"><span class="glyphicon glyphicon-plus"></span> Add</button>
                            <button type="button" class="btn btn-default" onclick="chuyentrang(2,'#qShowAll.productID#', '#buildUrl('product.admin_products_editor')#');"><span class="glyphicon glyphicon-edit"></span>  Edit</button>
                            <button class="btn btn-danger" type="button" onclick="chuyentrang(3,'#qShowAll.productID#', '#buildUrl('product.default')#');");"><span class="glyphicon glyphicon-remove"></span> Delete</button>
                        </div>
                    </td>
                </tr>   
            </cfloop>                                   
        </tbody>
    </table>
</cfoutput>