<cfparam name="Form.username" default="aaaaa"/>

<script type="text/javascript">

function assgin( id){
	$("#username").val(id);
	// $("#username").text(id);
}

$(document).ready(function() {

    $('a.login-window').click(function() {
        
        // Getting the variable's value from a link 
        var loginBox = $(this).attr('href');

        //Fade in the Popup and add close button
        $(loginBox).fadeIn(300);
        
        //Set the center alignment padding + border
        var popMargTop = ($(loginBox).height() + 24) / 2; 
        var popMargLeft = ($(loginBox).width() + 24) / 2; 
        
        $(loginBox).css({ 
            'margin-top' : -popMargTop,
            'margin-left' : -popMargLeft
        });
        
        // Add the mask to body
        $('body').append('<div id="mask"></div>');
        $('#mask').fadeIn(300);
        
        return false;
    });        
  
    // When clicking on the button close or the mask layer the popup closed
    $('a.closest, #mask').bind('click', function() { 
      $('#mask , .login-popup').fadeOut(300 , function() {
        $('#mask').remove();  
    }); 
    return false;
    });
});


</script>

<cfoutput>
<div id="login-box" class="login-popup">

    <a href="##" class="closest"><img src="#getContextRoot()#/admin/images/close_pop.png" class="btn_close" title="Close Window" alt="Close" /></a>

    <form method="post" class="signin" action="#getContextRoot()#/index.cfm/admin:mail_to_user">
        <fieldset class="textbox">
            <label class="username">
            <span>Mail to :</span>
            <input  id="username" name="username" value="" type="text" autocomplete="on" placeholder="Username">
            </label>

            <label class="password">
            <span>Content</span>
            
            <textarea id="content" name="content" rows="4" cols="35" ></textarea>

            </label>

            <input type="submit" name="Submit" value="Send">
            

        </fieldset>
    </form>
</div>

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
		<table id="table_user" class="display">
			<thead style="background-color: black;">
				<tr>
					<th>ID</th>
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
						<td>
							#getUsers.email#
							<a href="##login-box" class="login-window">
							<button type="button" style="float:right;border-color:white" class="btn btn-default" onclick = assgin('#getUsers.email#')><span class="glyphicon glyphicon-envelope"></span></button>
							</a>
						</td>
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
	function action(id,action){	
		<cfoutput>
			var baseUrl = "#getContextRoot()#/index.cfm/admin:user/"; 
		</cfoutput>
		var detailUrl = 'function/function.cfm?id='+id+'&act='+action;
		window.location = baseUrl + detailUrl;
	}

	$(document).ready(function(){
		var $rows = $('#table_user .trr');
		$('#search').keyup(function() {
			var val = $.trim($(this).val()).replace(/ +/g, ' ').toLowerCase()
			$rows.show().filter(function() {
				var text = $(this).text().replace(/\s+/g, ' ').toLowerCase();
				return !~text.indexOf(val);
			}).hide();
		});
		$('#table_user').dataTable({
        "sPaginationType": "full_numbers"
    	});
	});
</script>