		<cfset Session.isadmin       = false>
		<cfset Session.isLoggedIn    = false>
		<cfset Session.UserID        = 0>
		<cfset Session.name          = "">
		<cflocation url="#getContextRoot()#/index.cfm/home:login" addtoken="false">