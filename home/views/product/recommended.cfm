<cftry>
	<cfset userID=SESSION.userID/>
	<cfcatch>
		<cfset userID=""/>
	</cfcatch>
</cftry>
<cfoutput>
	<cfparam name="URL.page" default="1">
	<cfset URL.idpage = (URL.page -1)*9 />
	<cfquery name="qSumRecord" datasource="happy_water">
		select Count(`product`.`productID`) as dem 
		from `product_re`, `product`, `user`
		where `product`.`productID` = `product_re`.`productid`
		and `product_re`.`groupre_id` = `user`.`groupre_id`
		and `user`.`userID`= #userID#

	</cfquery> 

	<cfquery name="qRecommended" datasource="happy_water">
		select `product`.* 
		from `product_re`, `product`, `user`
		where `product`.`productID` = `product_re`.`productid`
		and `product_re`.`groupre_id` = `user`.`groupre_id`
		and `user`.`userID`= #userID#
		LIMIT #URL.idpage#,9
	</cfquery>  
	<div style="margin-bottom: 10px">
		<div class="btn-group">
			<a href="#buildUrl('multiform.update')#?groupid=0">
				<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-refresh"></span> Survey again</button>
			</a>
		</div>
	</a>
	</div>
	<cfset sumpage = ceiling(qSumRecord.dem/9)>
	<div class="row clearfix">
		<cfloop query="qRecommended">
			<div class="col-md-4">
				<img class="categories" src="#qRecommended.image#" width="200" height="200">
				<p class="bginfo kh_bginfo">
					<cfif #len(qRecommended.description)# gt 200>
						#left(qRecommended.description, 200)# ...	
						<cfelse>
							#qRecommended.description#
					</cfif>
						<br>
						<br>
						<br>
						<br>
						<input type="number" name="nQuantity#qRecommended.productID#"
						value="1" min="1" max="99" class="quantity form-control">
						<button style="float:left" class="btn btn-primary" type="button" name="btnBuyNow" onclick="btnBuyOnClick(#qRecommended.productID#)">Buy!</button>
				</p>
				<a href="#buildUrl('product.detail')#/?productID=#qRecommended.productID#">
				<div class="category-name kh_category-name">
					#qRecommended.productName#<br> 
					<span style="float:left;margin-left:5px;">#dollarformat(qRecommended.price*(100-qRecommended.discount)/100)#</span>
					<br>
					<cfif #qRecommended.discount# neq 0>
						<span style="float:left;margin-right:5px; text-decoration: line-through;">#dollarformat(qRecommended.price)#</span>
					
						<span style="font-size:20px; float:right;margin-right:5px;">Discount: #qRecommended.discount#%</span>
					</cfif>
				</div>						
				</a>
			</div>
		</cfloop>
	</div>
	<div class="row clearfix">
		<div class="col-md-12" align="center">
			<cfif #qSumRecord.dem# eq 0>
				No product
			<cfelse>
				<ul class="pagination" style="float: none">
				  <li><a href="?page=#URL.page-1#" onclick="return checkPrev()">&laquo;</a></li>
				  <cfloop from="1" to="#sumpage#" index="i">			
					<li>
						<a href="?page=#i#">#i#</a>
					</li>
				  </cfloop>
				  <li><a href="?page=#URL.page+1#" onclick="return checkNext(#sumpage#)">&raquo;</a></li>
				</ul>
			</cfif>
		</div>
	</div>
</cfoutput>
