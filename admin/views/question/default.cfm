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
<cfquery name="qGetQuestion">
	select * from question
</cfquery>
<cfset stt=1>
<h3 class="header-title">Questions Management</h3>
<form action="#CGI.SCRIPT_NAME#" method="post">
	<div class="row clearfix">
		<div class="col-md-12">
			<div class="alert alert-info">
				<div class="btn-group">
					<a href="#buildUrl('question.questionform')#">
	  				<button type="button" class="btn btn-default"><span class="glyphicon glyphicon-plus"></span> Add Question</button>
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
						Action
					</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="qGetQuestion">
					<tr>
						<td style="width:7%; text-align: center">
							#stt#
						</td>
						<td style="width:75%; text-align: center">
							#qGetQuestion.question_name#
						</td>
						<td>
							<a href="#buildUrl('question.questionform')#?id=#qGetQuestion.question_id#">
								<div class="btn-group btn-group-xs">
			  						<button type="button" class="btn btn-default"><span class="glyphicon glyphicon-remove"></span> Edit</button>
			  					</div>
							</a>
							<a href="#buildUrl('question.delete')#?id=#qGetQuestion.question_id#" onclick ="return checkDelete()">
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
