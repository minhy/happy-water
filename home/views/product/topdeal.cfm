<cfoutput>
	<cfparam name="URL.page" default="1">
	<cfset URL.idpage = (URL.page -1)*9 />
	<cfquery name="qSumRecord">
		SELECT Count(productID) as dem 
		FROM product
		WHERE discount <> 0  and status = 1 and IsActive = 1
		ORDER BY discount DESC 
	</cfquery> 

	<cfquery name="qGetByTopdeal">
		SELECT * 
		FROM product
		WHERE discount <> 0 and status = 1 and IsActive = 1
		ORDER BY discount DESC 
		LIMIT #URL.idpage#,9
	</cfquery>  

	<cfset sumpage = ceiling(qSumRecord.dem/9+1)>



	<div class="row clearfix">
		<div class="col-md-9" align="center">
			<div class="row clearfix">
				<cfloop query="qGetByTopdeal">
					<div class="col-md-4">
						<a href="#buildUrl('product.detail')#/?productID=#qGetByTopdeal.productID#" class="category-startpage">
						<img class="categories" src="#qGetByTopdeal.image#" width="200" height="200">
						<p class="bginfo">#qGetByTopdeal.description#</p>
						<div class="category-name">#qGetByTopdeal.productName#</div>
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
