<cfoutput>
	<cfif CGI.REQUEST_METHOD EQ 'POST'>

	<cfset mailAttributes = {
                server="smtp.gmail.com",
                username="nguyen.hoang.thien1410@gmail.com",
                password="0914735651",
                from="nguyen.hoang.thien1410@gmail.com",
                to="#username#",
                subject="Notification from admin page happy-water"
                }
        />
        <cfmail port="465" useSSL="true" attributeCollection="#mailAttributes#">
          <cfoutput>
            Hi, #username#
            #content#
          </cfoutput>
        </cfmail>
        <script type="text/javascript">
        alert('Send email to user success!!')
        </script>
		<cflocation url="#getContextRoot()#/index.cfm/admin:user" addtoken="false"/>
	</cfif>
</cfoutput>