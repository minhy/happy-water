<cftransaction isolation="serializable">
	<cfquery name="qDeleteQuestion" >
		DELETE FROM question
		WHERE question_id = <cfqueryparam sqltype="integer" value="#URL.id#"/>
	</cfquery>
</cftransaction>

<cflocation url="#buildUrl('question')#" />