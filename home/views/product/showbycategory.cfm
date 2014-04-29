<cfoutput>
	<cfparam name="URL.categoryID" default="0">
	<cfparam name="URL.page" default="1">
	<cfset URL.idpage = (URL.page -1)*9 />
	<cfquery name="qSumRecord" datasource="happy_water">
		SELECT Count(productID) as dem
		FROM product
		WHERE categoryID = #URL.categoryID#  and status = 1 and IsActive = 1
		ORDER BY productID

	</cfquery> 

	<cfquery name="qGetByCategory" datasource="happy_water">
		SELECT * 
		FROM product 
		WHERE categoryID = #URL.categoryID# and status = 1 and IsActive = 1
		ORDER BY productDate DESC
		LIMIT #URL.idpage#,9
	</cfquery>  
	
	<cfset sumpage = ceiling(qSumRecord.dem/9+1)>
	<div class="row clearfix">
		<cfloop query="qGetByCategory">
			<div class="col-md-4">
				<a href="#buildUrl('product.detail')#/?productID=#qGetByCategory.productID#" class="category-startpage">
				<img class="categories" src="#qGetByCategory.image#" width="300" height="300">
				<p class="bginfo">#qGetByCategory.description#</p>
				<div class="category-name kh_category-name">
					#qGetByCategory.productName#<br> 
					<span style="float:left;margin-left:5px;">#dollarformat(qGetByCategory.price*(100-qGetByCategory.discount)/100)#</span>
					<br>
					<cfif #qGetByCategory.discount# neq 0>
						<span style="float:left;margin-right:5px; text-decoration: line-through;">#dollarformat(qGetByCategory.price)#</span>
					
						<span style="font-size:20px; float:right;margin-right:5px;">Discount: #qGetByCategory.discount#%</span>
					</cfif>
				</div>			
				</a>
			</div>
		</cfloop>
	</div>
	<div class="row clearfix">
		<div class="col-md-12" align="center">
			<cfif #qSumRecord.dem# eq 0>
				No Product
				<cfelse>
					<ul class="pagination" style="float: none;">
					  <li><a href="?categoryID=#URL.categoryID#&page=#URL.page-1#" onclick="return checkPrev()">&laquo;</a></li>
					  <cfloop from="1" to="#sumpage#" index="i">			
						<li>
							<a href="?categoryID=#URL.categoryID#&page=#i#">#i#</a>
						</li>
					  </cfloop>
					  <li><a href="?categoryID=#URL.categoryID#&page=#URL.page+1#" onclick="return checkNext(#sumpage#)">&raquo;</a></li>
					</ul>
			</cfif>
		</div>
	</div>
</cfoutput>
