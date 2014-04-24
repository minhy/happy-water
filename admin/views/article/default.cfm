
<script language="javascript">
			function checkDelete() {
			    if (confirm("Are you sure you want delete it?")) {
			        return true;
			    } else {
			        return false;
			    }
			}

				$(document).ready( function () {
		    $('#table_id').dataTable({
                "sPaginationType": "full_numbers"
		    });
		    
		} );
		</script>
<cfoutput>
<cfparam name="news_id" type="varchar" default="ne">
<cfparam name="user_id" type="integer" default="1">
<cfquery name="qGetArticle">
	select article.*,categoryName from article,category
	where article.tag=category.tag
	order by tag
</cfquery>

<cfset stt=1>


				<form action="#CGI.SCRIPT_NAME#" method="post">
				<table class="table" id="table_id">
				<thead>
					<tr>
						<th>
							STT
						</th>
						<th>
							Title
						</th>
						<th>
							Tag
						</th>
						<th>
							Action
						</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="qGetArticle">
						<tr>
							<td>
								#stt#
							</td>
							<td>
								#qGetArticle.article_title#
							</td>
								<td>
								#qGetArticle.categoryName#
							</td>
							<td>
								<a href="#buildUrl('article.articleform')#">[add]</a>
								<a href="#buildUrl('article.articleform')#?id=#qGetArticle.article_id#&tag=#qGetArticle.tag#">[edit]</a>
								<a href="#buildUrl('article.delete')#?id=#qGetArticle.article_id#" onclick ="return checkDelete()">[delete]</a>
							</td>
						</tr>
						<cfset stt=stt+1>
					</cfloop>
				</tbody>
			</table>
				</form>
</cfoutput>
