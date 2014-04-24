
<script language="javascript">
			function checkDelete() {
			    if (confirm("Are you sure you want delete it?")) {
			        return true;
			    } else {
			        return false;
			    }
			}

				$(document).ready( function () {
		    $('#table_id').dataTable({
                "sPaginationType": "full_numbers"
		    });
		    
		} );
		</script>
		
<cfoutput>
<cfquery name="qGetMenu">
	select * from menu
</cfquery>

<cfset stt=1>
				<form action="#CGI.SCRIPT_NAME#" method="post">
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
							Action
						</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="qGetMenu">
						<tr>
							<td>
								#stt#
							</td>
							<td>
								#qGetMenu.menu_name#
							</td>
							<td>
								<a href="#buildUrl('menu_admin.menuform')#">[add]</a>
								<a href="#buildUrl('menu_admin.menuform')#?id=#qGetMenu.menu_id#">[edit]</a>
								<a href="#buildUrl('menu_admin.delete')#?id=#qGetMenu.menu_id#" onclick ="return checkDelete()">[delete]</a>
							</td>
						</tr>
						<cfset stt=stt+1>
					</cfloop>
				</tbody>
			</table>
				</form>
</cfoutput>
