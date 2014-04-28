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

	<cfset sumpage = ceiling(qSumRecord.dem/9+1)>

	<div class="row clearfix">
		<div class="col-md-9" align="center">
			<div class="row clearfix">
				<cfloop query="qGetByNew">
			<div class="col-md-4">
				<a href="#buildUrl('product.detail')#/?productID=#qGetByNew.productID#" class="category-startpage">
				<img class="categories" src="#qGetByNew.image#" width="200" height="200">
				<p class="bginfo">#qGetByNew.description#</p>
				<div class="category-name">#qGetByNew.productName#</div>
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
		</div>
		<div class="col-md-3" align="center">
			<cfinclude template="selection.cfm">
		</div>
	</div>
</cfoutput>
