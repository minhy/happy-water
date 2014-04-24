<cfparam name="Form.username" default="aaaaa"/>

<style>

.btn-sign a { color:#fff; text-shadow:0 1px 2px #161616; }

#mask {
    display: none;
    background: #000; 
    position: fixed; left: 0; top: 0; 
    z-index: 10;
    width: 100%; height: 100%;
    opacity: 0.8;
    z-index: 999;
}

.login-popup{
    display:none;
    background: #333;
    padding: 10px;  
    border: 2px solid #ddd;
    float: left;
    font-size: 1.2em;
    position: fixed;
    top: 50%; left: 50%;
    z-index: 99999;
    box-shadow: 0px 0px 20px #999;
    -moz-box-shadow: 0px 0px 20px #999; /* Firefox */
    -webkit-box-shadow: 0px 0px 20px #999; /* Safari, Chrome */
    border-radius:3px 3px 3px 3px;
    -moz-border-radius: 3px; /* Firefox */
    -webkit-border-radius: 3px; /* Safari, Chrome */
}

img.btn_close {
    float: right; 
    margin: -28px -28px 0 0;
}

fieldset { 
    border:none; 
}

form.signin .textbox label { 
    display:block; 
    padding-bottom:7px; 
}

form.signin .textbox span { 
    display:block;
}

form.signin p, form.signin span { 
    color:#999; 
    font-size:11px; 
    line-height:18px;
} 

form.signin .textbox input { 
    background:#666666; 
    border-bottom:1px solid #333;
    border-left:1px solid #000;
    border-right:1px solid #333;
    border-top:1px solid #000;
    color:#fff; 
    border-radius: 3px 3px 3px 3px;
    -moz-border-radius: 3px;
    -webkit-border-radius: 3px;
    font:13px Arial, Helvetica, sans-serif;
    padding:6px 6px 4px;
    width:200px;
}

form.signin input:-moz-placeholder { color:#bbb; text-shadow:0 0 2px #000; }
form.signin input::-webkit-input-placeholder { color:#bbb; text-shadow:0 0 2px #000;  }

.button { 
    background: -moz-linear-gradient(center top, #f3f3f3, #dddddd);
    background: -webkit-gradient(linear, left top, left bottom, from(#f3f3f3), to(#dddddd));
    background:  -o-linear-gradient(top, #f3f3f3, #dddddd);
    filter: progid:DXImageTransform.Microsoft.gradient(startColorStr='#f3f3f3', EndColorStr='#dddddd');
    border-color:#000; 
    border-width:1px;
    border-radius:4px 4px 4px 4px;
    -moz-border-radius: 4px;
    -webkit-border-radius: 4px;
    color:#333;
    cursor:pointer;
    display:inline-block;
    padding:6px 6px 4px;
    margin-top:10px;
    font:12px; 
    width:214px;
}

.button:hover { background:#ddd; }

</style>


<script src="#getContextRoot()#/admin/js/jquery-1.9.1.min.js"></script>

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


<div id="login-box" class="login-popup">
						<cfoutput>
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
                        </cfoutput>

</div>







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
	});
</script>