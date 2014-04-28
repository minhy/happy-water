<cfoutput>
	<cfparam name="URL.page" default="1">
	<cfset URL.idpage = (URL.page -1)*9 />
	<cfquery name="qSumColumn" datasource="happy_water">
		select Count(productID) as dem
		from product where status = 1 and IsActive = 1
		order by productID

	</cfquery> 

	<cfquery name="qGetAll" datasource="happy_water">
		select *
		from product where status = 1 and IsActive = 1
		limit #URL.idpage#,9
	</cfquery>  

	<cfset sumpage = ceiling(qSumColumn.dem/9)>
	<div class="row clearfix">
		<div class="col-md-9" align="center">
			<div class="row clearfix">
				<cfloop query="qGetAll">
					<div class="col-md-4" style="margin-bottom:10px;">
						<img class="categories" src="#qGetAll.image#" width="200" height="200">
						<p class="bginfo">
							#qGetAll.description#
								<br>
								<br>
								<br>
								<br>
								<input type="number" name="nQuantity#qGetAll.productID#"
								value="1" min="1" max="99" class="form-control" style="width:50px; float:left; margin-left: 40px;">
								<button style="float:left" class="btn btn-primary" type="button" name="btnBuyNow" onclick="btnBuyOnClick(#qGetAll.productID#)">Buy!</button>
						</p>
						<a href="#buildUrl('product.detail')#/?productID=#qGetAll.productID#">
						<div class="category-name" style="width:200px; padding:3px;">#qGetAll.productName#</div>
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