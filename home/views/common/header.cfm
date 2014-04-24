
<cfparam name="SESSION.isLoggedIn" default="false">
<cfparam name="SESSION.name" default="">
<cfparam name="SESSION.test" default="">

<header id="header">
	<div class="container header">
		<div class="row clearfix">
			<div class="col-md-2 column logo">
			</div>
			<div class="col-md-6 column">
				<cfinclude template="menu.cfm" />
			</div>
			<div class="col-md-4 column">
				<div class="row clearfix">
					<cfoutput>
					<div class="col-md-6 column register">
					
							<cfif SESSION.isLoggedIn EQ true>
						
					
                        <a href="##" class="dropdown-toggle" data-toggle="dropdown">Hi!#SESSION.name# <b class="caret"></b></a>
                        <ul class="dropdown-menu">
                            
                            <li >
                            	<a href="#getContextRoot()#/index.cfm/home:user_edit">User edit</a>
                            </li>

                            <li >
                            	<a href="#getContextRoot()#/index.cfm/home:changepassword">Change your password</a>
                            </li>
                            
                        </ul>
                   	
							<a href="#getContextRoot()#/index.cfm/home:logout">Log Out</a>
							<cfelse>
							<a href="#getContextRoot()#/index.cfm/home:register">Register</a> / <a href="#getContextRoot()#/index.cfm/home:login">Sign In</a>
							
							</cfif>


						<!--- </cflock> --->

					</div>
					</cfoutput>
					<div class="col-md-6 column cart">
						<a href="##"><span class="glyphicon glyphicon-shopping-cart"></span></a>
					</div>
				</div>
			</div>
		</div>
	</div>
</header>
