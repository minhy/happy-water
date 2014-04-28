<cfparam name="URL.page" default="1">
<cfset cr_page = "news" />
<cfset limit  = 3 />
<cfset URL.idpage = (URL.page -1)*#limit# />
<cfquery name="qGetArticle">
	SELECT *
	FROM article 
	WHERE article_isactive = 1
	AND tag ="news"
	ORDER BY article_id ASC LIMIT #URL.idpage#,#limit#
</cfquery>
<cfquery name="qGetArticle1">
	SELECT Count(article_id) as dem
	FROM article
	WHERE article_isactive = 1
	AND tag ="news"
	ORDER BY article_id ASC 
</cfquery>
<cfoutput>
	<script type="text/javascript">
        function checkPrev(){
        	var search= window.location.search;
        	var result= search.substr(6,1);
            if(result<=1)
            {
            	return false;
            }           
            else{
            	return true;
            }
             
        }
        function checkNext(totalPage){
        	var search= window.location.search;
        	var result= search.substr(6,1);
            if(result>=totalPage)
            {
            	return false;
            }           
            else{
            	return true;
            }
             
        }
 </script>
<div class="header-title">
	<h1>News</h1>
</div>
<cfset sum_column= ceiling(qGetArticle1.dem/#limit#) >
<div class="row clearfix">
	<ul class="pagination">
			<li>
				<a href="#cr_page#?page=#URL.page-1#" onclick="return checkPrev()">Prev</a>
			</li>
			<cfloop from="1" to="#sum_column#" index="i">			
			<li>
				<a href="#cr_page#?page=#i#">#i#</a>
			</li>
			</cfloop>
			<li >
				<a href="#cr_page#?page=#URL.page+1#" onclick="return checkNext(#sum_column-1#)">Next</a>
			</li>
	</ul>
	</div>
	<div class="row clearfix">
		<cfloop query="#qGetArticle#">
		<div class="col-md-12 colum article">
			<div class="img-thumbnail">
				<img alt="#qGetArticle.article_title#" src="#getContextRoot()#/#qGetArticle.article_img#">
			</div>
			<div class="caption">
				<a href="article_detail?id=#qGetArticle.article_id#"><h4>#qGetArticle.article_title#</h4></a>
				<p>#qGetArticle.article_description#</p>
			</div>
		</div>
		</cfloop>
	</div>
</cfoutput>