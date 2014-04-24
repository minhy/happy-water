<cfset id_category = #URL.categoryID# >
<cfif id_category EQ "ne">
	<cflocation url="#getContextRoot()#"/>
</cfif>
<cfquery name="qGetAbout">
	SELECT article.article_content, article.article_title, article.article_id, article.article_img FROM article 
	WHERE article.article_category_id = <cfqueryparam sqltype="varchar" value="#id_category#" />
	AND article.article_isactive = 1
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