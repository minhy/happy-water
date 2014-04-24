
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
<cfquery name="qGetQuestion">
	select * from question
</cfquery>
<cfset stt=1>
<h3 class="header-title">Questions Management</h3>
<form action="#CGI.SCRIPT_NAME#" method="post">
	<div class="row clearfix">
		<div class="col-md-9">
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
						<td>
							#stt#
						</td>
						<td>
							#qGetQuestion.question_name#
						</td>
						<td>
							<a href="#buildUrl('question.questionform')#?id=#qGetQuestion.question_id#">[edit]</a>
							<a href="#buildUrl('question.delete')#?id=#qGetQuestion.question_id#" onclick ="return checkDelete()">[delete]</a>
						</td>
					</tr>
					<cfset stt=stt+1>
				</cfloop>
			</tbody>
			</table>
		</div>
		<div class="col-md-3">
			<div class="btn-group">
				<a href="#buildUrl('question.questionform')#">
  				<button type="button" class="btn btn-default">Add Question</button>
  				</a>
			</div>
		</div>
	</div>
</form>
</cfoutput>
