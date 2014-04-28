<cfset tag = #URL.tag# >
<cfif tag EQ "news">
	<cflocation url="#getContextRoot()#"/>
</cfif>
<cfquery name="qGetAbout">
	SELECT article_content, article_title, article_id, article_img FROM article 
	WHERE tag = <cfqueryparam sqltype="varchar" value="#tag#" />
	AND article_isactive = 1
</cfquery>

<cfoutput>
	<div class="header-title">
		<h1>#qGetAbout.article_title#</h1>
	</div>
	<div class="article_detail">
		<div class="caption">
			<p>#qGetAbout.article_content#</p>
		</div>
	</div>

</cfoutput>