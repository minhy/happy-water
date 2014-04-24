<cfquery name="qGetMenu">
	SELECT *
	FROM menu
	WHERE menu_isactive = 1
	AND menu_tag = "top"
	ORDER BY menu_priority ASC

</cfquery>
<cfoutput>
<ul class="nav nav-pills">
	<cfloop query="qGetMenu">
		<li>
			<a href="#getContextRoot()#/#qGetMenu.menu_link#">#qGetMenu.menu_name#</a>
		</li>
	</cfloop>
</ul>
</cfoutput>