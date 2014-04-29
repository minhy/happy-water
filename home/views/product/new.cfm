<cfoutput>
	<cfparam name="URL.page" default="1">
	<cfset URL.idpage = (URL.page -1)*9 />
	<cfquery name="qSumRecord" datasource="happy_water">
		SELECT Count(productID) as dem
		FROM product
		WHERE productDate BETWEEN DATE_SUB(CURDATE(), INTERVAL 7 DAY) AND CURDATE() and status = 1 and IsActive = 1
		ORDER BY productID

	</cfquery> 

	<cfquery name="qGetByNew" datasource="happy_water">
		SELECT * 
		FROM product 
		WHERE productDate BETWEEN DATE_SUB(CURDATE(), INTERVAL 7 DAY) AND CURDATE() and status = 1 and IsActive = 1
		ORDER BY productDate DESC
		LIMIT #URL.idpage#,9
	</cfquery>  

	<cfset sumpage = ceiling(qSumRecord.dem/9)>

	<legend ><h1 style="color: ##0088cc;">New Products</h1></legend>

	<cfinclude template="selection.cfm">

	<div class="row clearfix">
		<div class="col-md-12" align="center">
			<div class="row clearfix">
				<cfloop query="qGetByNew">
			<div class="col-md-4" style="margin-bottom:10px;">
		
				<img class="categories" src="#qGetByNew.image#" width="200" height="200">
				<p class="bginfo">
					#qGetByNew.description#
						<br>
						<br>
						<br>
						<br>
						<input type="number" name="nQuantity#qGetByNew.productID#"
						value="1" min="1" max="99" class="quantity form-control">
						<button style="float:left" class="btn btn-primary" type="button" name="btnBuyNow" onclick="btnBuyOnClick(#qGetByNew.productID#)">Buy!</button>
				</p>
				<a href="#buildUrl('product.detail')#/?productID=#qGetByNew.productID#">
				<div class="category-name">
					#qGetByNew.productName#<br> 
					<span style="float:left;margin-left:5px;">#dollarformat(qGetByNew.price*(100-qGetByNew.discount)/100)#</span>
					<br>
					<cfif #qGetByNew.discount# neq 0>
						<span style="float:left;margin-right:5px; text-decoration: line-through;">#dollarformat(qGetByNew.price)#</span>
					
						<span style="font-size:20px; float:right;margin-right:5px;">Discount: #qGetByNew.discount#%</span>
					</cfif>
				</div>
				</a>
			</div>
		</cfloop>
			</div>
			<div class="row clearfix">
				<div class="col-md-12" align="center">
					<ul class="pagination" style="float: none;">
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
		</div>
	</div>
</cfoutput>
