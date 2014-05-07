<cfoutput>
<cfparam name="brandID" default="0">
<cfset LOCAL.listbrand = rc.listbrand>
<cfif isDefined("rc.bDeleted")>
    <cfif rc.bDeleted>
        <script type="text/javascript">
            alert("This brand was deleted !!!");
            window.location.href= "#buildUrl('brand.default')#";
        </script>
    <cfelse>
        <script type="text/javascript">
            alert("Can't delete this brand");
            window.location.href= "#buildUrl('brand.default')#";
        </script>
    </cfif>
</cfif>
</cfoutput>
   <!---  <
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
     --->
        
<!---     <cfquery name="qShowAll">
    SELECT *
    FROM brand
    </cfquery>    
     --->

    

    <script type="text/javascript">
        $(document).ready( function () {
            $('#table_id').dataTable({
                "bJQueryUI": true,
                "sPaginationType": "full_numbers"
            });
        } );

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
        <button type="button" class="btn btn-default" onclick="chuyentrang(1,'#listbrand.brandID#', '#buildUrl('brand.editor')#');"><span class="glyphicon glyphicon-plus"></span> Add new brand</button>
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
            <cfloop query="listbrand">
                <tr id="#listbrand.brandID#">
                    <td class="col-md-2 column">#listbrand.brandID#</td>
                    <td class="col-md-2 column">#listbrand.brandName#</td>
                    <td class="col-md-3 column">#listbrand.description#</td>
                    <td class="col-md-1 column">
                        <cfif #listbrand.IsActive# eq 1>
                            Yes
                        <cfelse> No
                        </cfif>
                    </td>
                    <td class="col-md-1 column">
                        <cfif #listbrand.status# eq 1>
                            New
                        <cfelse> Old
                        </cfif>
                    </td>
                    <td class="col-md-3 column">
                        <div class="btn-group btn-group-xs">
                           
                            <button type="button" class="btn btn-default" onclick="chuyentrang(2,'#listbrand.brandID#', '#buildUrl('brand.editor')#');"><span class="glyphicon glyphicon-edit"></span>  Edit</button>
                            <button class="btn btn-danger" type="button" onclick="chuyentrang(3,'#listbrand.brandID#', '#buildUrl('brand.default')#');"><span class="glyphicon glyphicon-remove"></span> Delete</button>
                        </div>
                    </td>
                </tr>   
            </cfloop>                                   
        </tbody>
    </table>
</cfoutput>