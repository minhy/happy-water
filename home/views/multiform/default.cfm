<script type="text/javascript">
function multiform( name,level,question_tf,nq,tfparent) {
			var groupid="";
		var sumr=0;
		for (var j = 1; j <=nq; j++) 
		{
			var radios = document.getElementsByName(name+j);
		    var found = 1;
		    for (var i = 0; i < radios.length; i++) {       
		        if (radios[i].checked) {
		            sumr=sumr+(+radios[i].value);
		            break;
		        }
		    }   
		};
		
		if (level ==32 || level==31 ) {


			if (level==32 && tfparent==1) 
			{

				if(sumr>= Math.round(nq/2))
				{
					groupid="g5";
				}
				else
				{
					groupid="g6";
				}
			}
			else
			{
				if (level==32 && tfparent==0) {

				if(sumr>= Math.round(nq/2))
				{
					groupid="g7";
				}
				else
				{
					groupid="g8";
				}
			}
			else
			{
				if (level==31 && tfparent==1) 
				{

				if(sumr>= Math.round(nq/2))
				{
					groupid="g1";
				}
				else
				{
					groupid="g2";
				}
			}
			else
			{
				if (level==31 && tfparent==0) 
				{

				if(sumr>= Math.round(nq/2))
				{
					groupid="g3";
				}
				else
				{
					groupid="g4";
				}
			}
			}
			}

			}
			window.location.href="index.cfm/multiform.update?groupid="+groupid;
			return false;
		}
		if(level==2 && question_tf==1)
		    {
            if(tfparent == 1)
            {
                level = 30;
            }
            else
            {
                level = 31;
            }
        }
        else if(level==2 && question_tf==0)
        {
            if(tfparent ==1)
            {
                level = 30;
            }
            else{
                level = 31;
            }
        }
		if(sumr>= Math.round(nq/2))
		{
				window.location.href="?level="+(level+1)+"&tf="+1+"&tfparent="+1;
		}
		else 
		{	
				window.location.href="?level="+(level+1)+"&tf="+0+"&tfparent="+0;
		}
		return false;
    	
}
</script>
<cfparam name="URL.level" default="1">
<cfparam name="URL.tf" default="1">
<cfparam name="URL.tfparent" default = "1">
<cfset level=URL.level />
<cfset question_tf=URL.tf/>
<cfset tfparent = URL.tfparent/>
<cfset i=1/>
<cfset user_id=3/>

<cfquery name="qGetUserRe" result="tmpRe">
	select groupre_id from user where userID=<cfqueryparam sqltype="integer" value="#user_id#">
</cfquery>

<cfif #tmpRe.RecordCount# gt 0 and #qGetUserRe.groupre_id# eq "">
	<cfquery name="qGetQuestionByLevel" result="tmpResult">
		select * from question where question_level=<cfqueryparam sqltype="integer" value="#level#">
		and question_tf=<cfqueryparam sqltype="varchar" value="#question_tf#">
	</cfquery>

	<cfoutput>
	<section id="multiform" class="section">
		<cfheader title=""/>
		<form action="" method="post">
			<div class="row clearfix">
			<cfloop query="qGetQuestionByLevel" >
				<cfparam name="form.active#i#" default="yes"/>
				<div class="col-md-8 border-question">
					<div class="input-group">
						<span name="ch" class="label label-default">#qGetQuestionByLevel.question_name#</span>
					</div>	
				</div>
				<div class="col-md-1 border-question">
					<div class="input-group">
					    <span class="input-group">
					        <input type="radio" name="active#i#" value="1" > Yes
					    </span>
	      			</div>
				</div>
				<div class="col-md-1 border-question">
					<div class="input-group">
					    <span class="input-group">
					        <input type="radio" name="active#i#" value="0" > No
					    </span>
	      			</div>
				</div>
				<cfset i=i+1/>
			</cfloop>
			<div class="col-md-9">
			</div>
			<div class="col-md-3">
				<div class="btn-group">
				  	<button type="submit" class="btn btn-default" value="Submit" onclick="return multiform('active',#level#,#question_tf#,#tmpResult.RecordCount#,#tfparent#)">Submit</button>
				</div>
			</div>
			</div>
		</form>
	</section>
	</cfoutput>
</cfif>
