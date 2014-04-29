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
				<a href="#buildUrl('product.detail')#/?productID=#qRecommended.productID#" class="category-startpage">
				<img class="categories" src="#qRecommended.image#" width="300" height="300">
				<p class="bginfo">#qRecommended.description#</p>
				<div class="category-name">#qRecommended.productName#</div>
				</a>
			</div>
		</cfloop>
	</div>
	<div class="row clearfix">
		<div class="col-md-12" align="center">
			<ul class="pagination">
			  <li><a href="?page=#URL.page-1#" onclick="return checkPrev()">&laquo;</a></li>
			  <cfloop from="1" to="#sumpage#" index="i">			
				<li>
					<a href="?page=#i#">#i#</a>
				</li>
			  </cfloop>
			  <li><a href="?page=#URL.page+1#" onclick="return checkNext(#sumpage#)">&raquo;</a></li>
			</ul>
		</div>
	</div>
</cfoutput>
