<cfoutput>
	<cfparam name="URL.page" default="1">
	<cfset URL.idpage = (URL.page -1)*9 />

	<cfset local.products = rc.products>
	<cfset local.sumrecord = rc.sumrecord>

	<cfset sumpage = ceiling(sumrecord.dem/9)>

	<legend ><h1 style="color: ##0088cc;">Products</h1></legend>

	<cfinclude template="selection.cfm">

		<div class="row clearfix">
		<cfloop query="products">
			<div class="col-md-4" style="margin-bottom:10px">
				<img class="categories" src="#products.image#" width="200" height="200">
				<p class="bginfo kh_bginfo">
					<cfif #len(products.description)# gt 200>
						#left(products.description, 200)# ...	
						<cfelse>
							#products.description#
					</cfif>
						<br>
						<br>
						<br>
						<br>
						<input type="number" name="nQuantity#products.productID#"
						value="1" min="1" max="99" class="quantity form-control" style="width:60px">
						<button style="float:left" class="btn btn-primary" type="button" name="btnBuyNow" onclick="btnBuyOnClick(#products.productID#)">Buy!</button>
				</p>
				<a href="#buildUrl('product.detail')#/?productID=#products.productID#">
				<div class="category-name kh_category-name">
					#products.productName#<br> 
					<span style="float:left;margin-left:5px;">#dollarformat(products.price*(100-products.discount)/100)#</span>
					<br>
					<cfif #products.discount# neq 0>
						<span style="float:left;margin-right:5px; text-decoration: line-through;">#dollarformat(products.price)#</span>
					
						<span style="font-size:20px; float:right;margin-right:5px;">Discount: #products.discount#%</span>
					</cfif>
				</div>						
				</a>
			</div>
		</cfloop>
	</div>
	<div class="row clearfix">
		<div class="col-md-12" align="center">
			<cfif #sumrecord.dem# eq 0>
				No product
			<cfelse>
				<ul class="pagination" style="float: none">
				  <li><a href="?page=#URL.page-1#" onclick="return checkPrev()">&laquo;</a></li>
				  <cfloop from="1" to="#sumpage#" index="i">
					<cfif i eq URL.page>
				  		<li class="active">			
							<a href="?page=#i#">#i#</a>
						</li>
					<cfelse>
						<li>			
							<a href="?page=#i#">#i#</a>
						</li>
					  </cfif>
				  </cfloop>
				  <li><a href="?page=#URL.page+1#" onclick="return checkNext(#sumpage#)">&raquo;</a></li>
				</ul>
			</cfif>
		</div>
	</div>
</cfoutput>