<cfoutput>
<div class="container wrap main">
	<section class="main-container">
		<style>
		table, td, th
		{
			border:1px solid black;
		}
		th
		{
			background-color:black;
			color:white;
		}
		</style>
		
		<!-- Set admin session -->
		<cflock timeout="#CreateTimeSpan(0,0,45,0)#" scope="Session" type="Exclusive">
			<cfset Session.Admin = 1>
		</cflock>

		<!-- Get all user -->
		<cfquery name="getUsers" datasource="happy_water">
			SELECT userId, firstname, lastname, address, dateofbirth, email, level
			FROM user
		</cfquery>

		<!-- Show list user on table -->
		<form>
			<input id="search" type="text" placeholder="Type to search">
		</form>
		<table id="table_user" class="display">
			<thead>
				<tr>
					<th>User ID</th>
					<th>First Name</th>
					<th>Last Name</th>
					<th>DOB</th>
					<th>Email</th>
					<th>Address</th>
					<!--- <th>Image</th> --->
					<th>Action</th>
				</tr>
			</thead>
			<tbody>
	 			<cfloop query="getUsers">
					<tr id="#getUsers.userID#" class="trr">
						<td>#getUsers.userID#</td>
						<td>#getUsers.firstname#</td>
						<td>#getUsers.lastname#</td>
						<td>#dateFormat(getUsers.dateofbirth, "short")#</td>
						<td>#getUsers.email#</td>
						<td>#getUsers.address#</td>
						<td class="col-md-2 column">
						<div class="btn-group btn-group-xs">
								<cfif Session.Admin EQ 1 OR Session.Admin EQ 2>	
									<cfif #getUsers.level# EQ 3>
										<button type="button" class="btn btn-default" onclick = action('#getUsers.userID#','bans')><span class="glyphicon glyphicon-ban-circle"></span>Bans</button>
										
										<button type="button" class="btn btn-default" onclick = action('#getUsers.userID#','setadmin')><span class="glyphicon glyphicon-ok-circle"></span>Set Admin</button>

									<cfelseif #getUsers.level# EQ 0>	
										<button type="button" class="btn btn-default" onclick = action('#getUsers.userID#','unbans')><span class="glyphicon glyphicon-user"></span>Unbans</button>					
									</cfif>
								</cfif>
								<cfif Session.Admin EQ 1>
									<cfif #getUsers.level# EQ 2>
										<button type="button" class="btn btn-default" onclick = action('#getUsers.userID#','bans')><span class="glyphicon glyphicon-ban-circle"></span>Bans</button>
										<button type="button" class="btn btn-default" onclick = action('#getUsers.userID#','unbans')><span class="glyphicon glyphicon-remove-circle"></span>Remove Admin</button>	
									</cfif>
								</cfif>
							</div>
						</td>
					</tr>
				</cfloop>
			</tbody>
		</table>
	</section>
</div>
</cfoutput>

<script type="text/javascript">
	// Action function define
	function action(id,action){	
		<cfoutput>
			var baseUrl = "#getContextRoot()#/index.cfm/admin:user/"; 
		</cfoutput>
		var detailUrl = 'function/function.cfm?id='+id+'&act='+action;
		window.location = baseUrl + detailUrl;
	}

	// Real time searching
	$(document).ready(function(){
		var $rows = $('#table_user .trr');
		$('#search').keyup(function() {
			var val = $.trim($(this).val()).replace(/ +/g, ' ').toLowerCase()
			$rows.show().filter(function() {
				var text = $(this).text().replace(/\s+/g, ' ').toLowerCase();
				return !~text.indexOf(val);
			}).hide();
		});
	});
</script>