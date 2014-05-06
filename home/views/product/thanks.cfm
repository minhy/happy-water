<cfquery name="qGetEmail">
	SELECT email, firstname
	FROM user
	WHERE userID = #URL.userID#
</cfquery>

<cfset mailAttributes = {
                server="smtp.gmail.com",
                username="nguyen.hoang.thien1410@gmail.com",
                password="0914735651",
                from="nguyen.hoang.thien1410@gmail.com",
                to="#qGetEmail.email#",
                subject="[Happy-Water] Your order infomation"
                }
/>
<cfmail port="465" useSSL="true" attributeCollection="#mailAttributes#">
  <cfoutput>
    Dear #qGetEmail.firstname#

	Your order ID: #URL.orderID#

	Please remember this code for receiving your package.
	
	Sincerly,
	Administrator
  </cfoutput>
</cfmail>

<style type="text/css">
	.checkok{
		font-size: 18px;
		color: #4eb127;
	}

</style>
<cfoutput>
<span>
	<img src="#getContextRoot()#/home/images/check.png">
</span>
<span class="checkok">Order successfully.<br>Thank you for ordering at Happy Water.<br></span>
<span style="color:##505050">Your order ID: </span><b style="font-size:18px;">#URL.orderID#</b>
<hr>
<span>We sent the order information to your email <b>#qGetEmail.email#</b>. If not found, please looking for in Spam or Junk Folder.</span>

</cfoutput>