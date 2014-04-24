
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
	select * from article where article_category_id= <cfqueryparam sqltype="varchar" value="#news_id#"/>
	and userid= <cfqueryparam sqltype="integer" value="#user_id#"/>
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
								<a href="article_admin.articleform">[add]</a>
								<a href="article_admin.articleform?id=#qGetArticle.article_id#">[edit]</a>
								<a href="article_admin.delete?id=#qGetArticle.article_id#" onclick ="return checkDelete()">[delete]</a>
							</td>
						</tr>
						<cfset stt=stt+1>
					</cfloop>
				</tbody>
			</table>
				</form>
</cfoutput>
