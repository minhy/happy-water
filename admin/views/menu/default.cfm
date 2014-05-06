
<script language="javascript">
			function checkDelete() {
			    // if (confirm("Are you sure you want delete it?")) {
			    //     return true;
			    // } else {
			    //     return false;
			    // }
			    return confirm("Are you sure you want delete it?");
			}

				// $(document).ready( function () {
				//     $('#table_id').dataTable({
				//     	"bJQueryUI": true,
		  //               "sPaginationType": "full_numbers"
				//     });
				    
				// } );
		</script>
		
<cfoutput>
<cfquery name="qGetMenu">
	select * from menu
</cfquery>
<cfset stt=1>
<h3 class="header-title">Menu Management</h3><hr>
<form action="#CGI.SCRIPT_NAME#" method="post">
	<div class="row clearfix">
	<div class="col-md-12">
		<div class="alert alert-info">
			<div class="btn-group">
				<a href="#buildUrl('menu.menuform')#">
					<button type="button" class="btn btn-default"><span class="glyphicon glyphicon-plus"></span> Add Menu</button>
					</a>
			</div>
		</div>	
		<table class="table" id="table_id">
		<thead>
			<tr>
				<th>
					STT
				</th>
				<th>
					Title
				</th>
				<th>
					Active
				</th>
				<th>
					Action
				</th>
			</tr>
		</thead>
		<tbody>
			<cfloop query="qGetMenu">
				<tr>
					<td style="width:7%; text-align: center">
						#stt#
					</td>
					<td style="width:75%; text-align: center">
						#qGetMenu.menu_name#
					</td>
					<td style="text-align:center">
						<cfif #qGetMenu.menu_isactive# eq 1>
                            Yes
                        <cfelse> No
                        </cfif>
					</td>
					<td>
						<a href="#buildUrl('menu.menuform')#?id=#qGetMenu.menu_id#">
							<div class="btn-group btn-group-xs">
		  						<button type="button" class="btn btn-default"><span class="glyphicon glyphicon-edit"></span> Edit</button>
		  					</div>
						</a>
						<a href="#buildUrl('menu.delete')#?id=#qGetMenu.menu_id#" onclick ="return checkDelete()">
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
	</div>
</form>
</cfoutput>
