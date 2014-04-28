<cfparam name="categoryID" default="0">
    <cfoutput>
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
    </cfoutput>
<head>
<script language="javascript">
    $(document).ready( function () {
        $('#table_id').dataTable({
            "sPaginationType": "full_numbers"
        });
        
    } );
</script>
<script language="javascript">
function checkMe() {
    if (!confirm("Are you sure?")) {
        return true;
    } 
}
function chuyentrang(status, id, url){
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
</head>

<cfquery name="qCategory">
    SELECT * FROM category
</cfquery>
<cfoutput>
<body>
<legend><h1>Category Management</h1></legend>
<div class="alert alert-info">
    <button type="button" class="btn btn-default" onclick="chuyentrang(1,'#qCategory.categoryID#', '#buildUrl('category.form')#');"><span class="glyphicon glyphicon-plus"></span> Add new Category</button>
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
                <!--- <th>Description</th>
                <th>Tag</th> --->
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
 <cfloop query="qCategory">
                <cfquery name="qParent">      
                    SELECT *
                    FROM category
                    WHERE categoryID = <cfqueryparam sqltype="integer" value="#qCategory.parentID#"/>
                </cfquery>
                <cfif #qCategory.IsActive# equal "1">
                    <cfset a="yes">
                <cfelse>
                    <cfset a="no">
                </cfif>
                <!--- <cfif #qCategory.status# equal "1">
                    <cfset b="yes">
                <cfelse>
                    <cfset b="no">
                </cfif> --->
                <tr id="#qCategory.categoryID#">
                    <td class="col-md-1 column">#qCategory.categoryID#</td>
                    <td>#qCategory.categoryName#</td>
                    <td class="col-md-3 column">#qCategory.description#</td>
                    <td class="col-md-1 column">#qParent.categoryName#
                    </td>
                    <td><img src="#getContextRoot()##qCategory.image#" width="80" height="80"/></td>                   
                    <td class="col-md-1 column">#a#</td>
                    <!--- <td class="col-md-2 column">#qCategory.tag#</td> --->
                    <td class="col-md-2 column">
                        <div class="btn-group btn-group-xs">
                            <!--- <button type="button" class="btn btn-default" onclick="chuyentrang(1,'#qCategory.categoryID#', '#buildUrl('category.form')#');"><span class="glyphicon glyphicon-plus"></span> Add</button> --->
                            <button type="button" class="btn btn-default" onclick="chuyentrang(2,'#qCategory.categoryID#', '#buildUrl('category.form')#');"><span class="glyphicon glyphicon-edit"></span>  Edit</button>
                            <button class="btn btn-danger" type="button" onclick="chuyentrang(3,'#qCategory.categoryID#', '#buildUrl('category.default')#');"
                            ><span class="glyphicon glyphicon-remove"></span> Delete</button>
                        </div>
                    </td>
                </tr>   
            </cfloop>              
        </tbody>
    </table>
</body>
</cfoutput>


