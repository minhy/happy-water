<script language="javascript">
    $(document).ready( function () {
        $('#table_id').dataTable({
            "bJQueryUI": true,
            "sPaginationType": "full_numbers"
        });
        
    } );
</script>
<script language="javascript">

function forward(status, id, url){
            switch(status)
            {
                case 1:
                    window.location.href= url + "?categoryID=0";
                    break;
                case 2:
                    window.location.href= url +"?categoryID="+ id;
                    break;
                case 3:
                    if(confirm("Are you sure ???") == true){
                        window.location.href= url +"?categoryID="+ id;
                    }
                    break;
            }
        }
</script>

<cfoutput>
<cfparam name="categoryID" default="0">
        <cftry>
            <cfif #categoryID# neq 0>
                <cfquery name="qDelete">
                    delete from category
                    where categoryID = <cfqueryparam value="#url.categoryID#" cfsqltype="cf_sql_integer">
                </cfquery>
                <script type="text/javascript">
                    alert("Deleted !!!");
                    window.location.href= "#buildUrl('category.default')#";
                </script>
            </cfif>
            <cfcatch>
                <script type="text/javascript">
                    alert("Can't delete");
                    window.location.href= "#buildUrl('category.default')#";
                </script>
            </cfcatch>    
        </cftry>
    
<cfquery name="qGetCategory">
    SELECT * FROM category
</cfquery>
<legend><h1>Category Management</h1></legend>
<div class="alert alert-info">
    <button type="button" class="btn btn-default" onclick="forward(1,'#qGetCategory.categoryID#', '#buildUrl('category.form')#');"><span class="glyphicon glyphicon-plus"></span> Add new Category</button>
</div>
 <table id="table_id" class="display">
 		<thead>
            <tr>
                <th>Category ID</th>
                <th>Category Name</th>
                <th>Description</th>
                <th>Parent</th>
                <th>Image</th>
                <th>IsActive</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <cfloop query="qGetCategory">
                <cfquery name="qGetParentCategory">      
                    SELECT *
                    FROM category
                    WHERE categoryID = <cfqueryparam sqltype="integer" value="#qGetCategory.parentID#"/>
                </cfquery>
                <cfif #qGetCategory.IsActive# equal "1">
                    <cfset a="yes">
                <cfelse>
                    <cfset a="no">
                </cfif>
             
                <tr id="#qGetCategory.categoryID#">
                    <td class="col-md-1 column">#qGetCategory.categoryID#</td>
                    <td>#qGetCategory.categoryName#</td>
                    <td class="col-md-3 column">#qGetCategory.description#</td>
                    <td class="col-md-1 column">#qGetParentCategory.categoryName#
                    </td>
                    <td><img src="#getContextRoot()##qGetCategory.image#" width="80" height="80"/></td>                   
                    <td class="col-md-1 column">#a#</td>
                    <td class="col-md-2 column">
                        <div class="btn-group btn-group-xs">
                            <button type="button" class="btn btn-default" onclick="forward(2,'#qGetCategory.categoryID#', '#buildUrl('category.form')#');"><span class="glyphicon glyphicon-edit"></span>  Edit</button>
                            <button class="btn btn-danger" type="button" onclick="forward(3,'#qGetCategory.categoryID#', '#buildUrl('category.default')#');"
                            ><span class="glyphicon glyphicon-remove"></span> Delete</button>
                        </div>
                    </td>
                </tr>   
            </cfloop>              
        </tbody>
    </table>
</cfoutput>


