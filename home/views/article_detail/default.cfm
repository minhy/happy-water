<cfquery name="qGetArticle">
	SELECT *
	FROM happy_water.article
	WHERE article.article_isactive = 1
	AND article.article_id = <cfqueryparam sqltype="integer" value="#URL.id#" />
	ORDER BY article.article_id ASC 
</cfquery>
<cfoutput>
	<div class="header-title">
		<h1>#qGetArticle.article_title#</h1>
	</div>
	<div class="date">
		<p>Create date: #dateFormat(qGetArticle.article_createdate,"dd/mm/yyyy")#</p>
	</div>
		<div class="article_detail">
			<div class="img-thumbnail"><img src="#getContextRoot()#/#qGetArticle.article_img#"></div>
			<div class="caption">
				<p><i>#qGetArticle.article_description#</i></p>
				<p>#qGetArticle.article_content#</p>
			</div>
		</div>
</cfoutput>