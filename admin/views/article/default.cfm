<script language="javascript">
			function checkDelete() {
			    return confirm("Are you sure you want delete it?");
			}

				$(document).ready( function () {
				    $('#table_id').dataTable({
				    	"bJQueryUI": true,
		  		     "sPaginationType": "full_numbers"
				    });
				    
				} );
		</script>
<cfoutput>
<cfquery name="qGetArticle">
	select article.*,categoryName from article,category
	where article.tag=category.tag
	order by tag
</cfquery>
<cfset stt=1>

<h3 class="header-title">Article Management</h3><hr>
<form action="#CGI.SCRIPT_NAME#" method="post">
	<div class="row clearfix">
		<div class="col-md-12">
			<div class="alert alert-info">
				<div class="btn-group">
					<a href="#buildUrl('article.articleform')#">
	  				<button type="button" class="btn btn-default"><span class="glyphicon glyphicon-plus"></span> Add Ariticle</button>
	  				</a>
				</div>
			</div>
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
						Active
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
						<td style="text-align: center">
							#stt#
						</td>
						<td style="width: 60%">
							#qGetArticle.article_title#
						</td>
						<td style="text-align: center">
	                        <cfif #qGetArticle.article_isactive# eq 1>
	                            Yes
	                        <cfelse> No
	                        </cfif>
						</td>
						<td style="text-align: center">
							#qGetArticle.categoryName#
						</td>
						<td>
							<a href="#buildUrl('article.articleform')#?id=#qGetArticle.article_id#&tag=#qGetArticle.tag#">
								<div class="btn-group btn-group-xs">
			  						<button type="button" class="btn btn-default"><span class="glyphicon glyphicon-edit"></span> Edit</button>
			  					</div>
							</a>
							<a href="#buildUrl('article.delete')#?id=#qGetArticle.article_id#" onclick ="return checkDelete()">
								<div class="btn-group btn-group-xs">
			  						<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-remove"></span> Delete</button>
			  					</div>
							</a>
						</td>
					</tr>
					<cfset stt=stt+1>
				</cfloop>
			</tbody>
			</table>
		</div>
	</div>
</form>
</cfoutput>
