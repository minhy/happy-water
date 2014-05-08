<cfparam name="productID" type="numeric" default="0">
<cfset LOCAL.showAll = rc.showAll/>
<cfoutput>
    <cfif isDefined("rc.bDeleted")>
        <cfif rc.bDeleted>
            <script type="text/javascript">
                alert("This product was deleted !!!");
                window.location.href= "#buildUrl('product.default')#";
            </script>
        <cfelse>
            <script type="text/javascript">
                alert("Can't delete this product");
                window.location.href= "#buildUrl('product.default')#";
            </script>
        </cfif>
    </cfif>   
</cfoutput>

<script type="text/javascript">
    $(document).ready( function () {
        $('#table_id').dataTable({
            "bJQueryUI": true,
            "sPaginationType": "full_numbers",
            "bSort": false
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
    <br>
    <legend><h1>Product Management</h1></legend>
    <div class="alert alert-info">
        <button type="button" class="btn btn-default" onclick="chuyentrang(1,'#showAll.productID#', '#buildUrl('product.editor')#');"><span class="glyphicon glyphicon-plus"></span> Add new product</button>
    </div>
    <br>
    <table id="table_id" class="display">
        <thead>
            <tr>
                <th>Product ID</th>
                <th>Product Name</th>
                <th>Selling</th>
                <th>In stock</th>
                <th>Original Price</th>
                <th>Price</th>
                <th>Image</th>
                <th>Date updating</th>
                <th>Category</th>
                <th>Brand</th>
                <th></th>
            </tr>
        </thead>
        <tbody>
            <cfloop query="showAll">
                <tr id="#showAll.productID#">
                    <td class="col-md-1 column">#showAll.productID#</td>
                    <td class="col-md-2 column">#showAll.productName#</td>
                    <td class="col-md-1 column">
                        <cfif #showAll.IsActive# eq 1>
                            Yes
                        <cfelse> No
                        </cfif>
                    </td>
                    <td class="col-md-1 column">
                        <cfif #showAll.status# eq 1>
                            Yes
                        <cfelse> No
                        </cfif>
                    </td>
                    <td class="col-md-1 column">#showAll.originalprice#</td>
                    <td class="col-md-1 column">#showAll.price#</td>
                    <td class="col-md-1 column"><img src="#getContextRoot()##showAll.image#" width="50" height="50"/></td>
                    <td class="col-md-1 column">#dateformat(#showAll.productDate#,"dd/mm/yyyy")#</td>
                    <td class="categoryID">
                        <cfquery name="categoryName">
                            SELECT categoryName
                            FROM Category
                            WHERE categoryID = #showAll.categoryID#
                        </cfquery>
                        #categoryName.categoryName#
                    </td>
                    <td class="brandID">
                        <cfquery name="brandName">
                            SELECT brandName
                            FROM Brand
                            WHERE brandID = #showAll.brandID#
                        </cfquery>
                        #brandName.brandName#
                    </td>
                    <td class="col-md-3 column">
                        <div class="btn-group btn-group-xs">
                           
                            <button type="button" class="btn btn-default" onclick="chuyentrang(2,'#showAll.productID#', '#buildUrl('product.editor')#');"><span class="glyphicon glyphicon-edit"></span>  Edit</button>
                            <button class="btn btn-danger" type="button" onclick="chuyentrang(3,'#showAll.productID#', '#buildUrl('product.default')#');"><span class="glyphicon glyphicon-remove"></span> Delete</button>
                        </div>
                    </td>
                </tr>   
            </cfloop>                                   
        </tbody>
    </table>
</cfoutput>