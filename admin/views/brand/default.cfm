<cfparam name="brandID" default="0">
    <cfoutput>
        <cftry>
            <cfif #brandID# neq 0>
                <cfquery name="qDelete">
                    delete from brand
                    where brandID = <cfqueryparam value="#url.brandID#" cfsqltype="cf_sql_integer">
                </cfquery>
                <script type="text/javascript">
                    alert("This brand was deleted !!!");
                    window.location.href= "#buildUrl('brand.default')#";
                </script>
            </cfif>
            <cfcatch>
                <script type="text/javascript">
                    alert("Can't delete this brand");
                    window.location.href= "#buildUrl('brand.default')#";
                </script>
            </cfcatch>    
        </cftry>
    </cfoutput>
        
    <cfquery name="qShowAll">
    SELECT *
    FROM brand
    </cfquery>    
    

    <script type="text/javascript">
        // $(document).ready( function () {
        //     $('#table_id').dataTable({
        //         "bJQueryUI": true,
        //         "sPaginationType": "full_numbers"
        //     });
        // } );

        function chuyentrang(status, id, url){
            switch(status)
            {
                case 1:
                    window.location.href= url + "?brandID=0";
                    break;
                case 2:
                    window.location.href= url +"?brandID="+ id;
                    break;
                case 3:
                    if(confirm("Are you sure ???") == true){
                        window.location.href= url +"?brandID="+ id;
                    }
                    break;
            }
        }

    </script>
<cfoutput>
    <br>
    <legend><h1>Brand Management</h1></legend>
    <div class="alert alert-info">
        <button type="button" class="btn btn-default" onclick="chuyentrang(1,'#qShowAll.brandID#', '#buildUrl('brand.editor')#');"><span class="glyphicon glyphicon-plus"></span> Add new brand</button>
    </div>
    <br>
    <table id="table_id" class="display">
        <thead>
            <tr>
                <th>Brand ID</th>
                <th>Brand Name</th>
                <th>Description</th>
                <th>Selling</th>
                <th>Status</th>
                <th></th>
            </tr>
        </thead>
        <tbody>
            <cfloop query="qShowAll">
                <tr id="#qShowAll.brandID#">
                    <td class="col-md-2 column">#qShowAll.brandID#</td>
                    <td class="col-md-2 column">#qShowAll.brandName#</td>
                    <td class="col-md-3 column">#qShowAll.description#</td>
                    <td class="col-md-1 column">
                        <cfif #qShowAll.IsActive# eq 1>
                            Yes
                        <cfelse> No
                        </cfif>
                    </td>
                    <td class="col-md-1 column">
                        <cfif #qShowAll.status# eq 1>
                            New
                        <cfelse> Old
                        </cfif>
                    </td>
                    <td class="col-md-3 column">
                        <div class="btn-group btn-group-xs">
                           
                            <button type="button" class="btn btn-default" onclick="chuyentrang(2,'#qShowAll.brandID#', '#buildUrl('brand.editor')#');"><span class="glyphicon glyphicon-edit"></span>  Edit</button>
                            <button class="btn btn-danger" type="button" onclick="chuyentrang(3,'#qShowAll.brandID#', '#buildUrl('brand.default')#');"><span class="glyphicon glyphicon-remove"></span> Delete</button>
                        </div>
                    </td>
                </tr>   
            </cfloop>                                   
        </tbody>
    </table>
</cfoutput>