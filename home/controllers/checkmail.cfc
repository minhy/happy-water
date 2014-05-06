<cfcomponent>
<cffunction name="chkEmail" access="remote" returnformat="json" returntype="boolean" output="false">
    <cfargument name="email" type="string" required="true">
    <cfquery name="qchkEmail">
    SELECT *
    FROM user 
    WHERE email = <cfqueryparam value="#arguments.Email#" sqltype="varchar" />
    </cfquery>
 
<cfreturn yesNoFormat(qchkEmail.recordCount) />

 </cffunction>
</cfcomponent>