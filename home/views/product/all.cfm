<cfoutput>
	<cfparam name="URL.page" default="1">
	<cfset URL.idpage = (URL.page -1)*9 />
	<cfquery name="qSumColumn">
		select Count(productID) as dem
		from product
		order by productID

	</cfquery> 

	<cfquery name="qGetAll">
		select *
		from product
		limit #URL.idpage#,9
	</cfquery>  

	<cfset sumpage = qSumColumn.dem/9+1>
	<div class="row clearfix">
		<cfloop query="qGetAll">
			<div class="col-md-4">
				<a href="#buildUrl('product.detail')#/?productID=#qGetAll.productID#" class="category-startpage">
				<img class="categories" src="#qGetAll.image#" width="300" height="300">
				<p class="bginfo">#qGetAll.description#</p>
				<div class="category-name">#qGetAll.productName#</div>
				</a>
			</div>
		</cfloop>
	</div>
	
	<div class="row clearfix">
		<div class="col-md-12" align="center">
			<ul class="pagination">
			  <li><a href="product.cfm?page=#URL.page-1#" onclick="return checkPrev()">&laquo;</a></li>
			  <cfloop from="1" to="#sumpage#" index="i">			
				<li>
					<a href="product.cfm?page=#i#">#i#</a>
				</li>
			  </cfloop>
			  <li><a href="product.cfm?page=#URL.page+1#" onclick="return checkNext(#sumpage#)">&raquo;</a></li>
			</ul>
		</div>
	</div>
</cfoutput>