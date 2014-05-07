<cfoutput>
	<cfparam name="URL.page" default="1">
	<cfset URL.idpage = (URL.page -1)*9 />
	<cfparam name="URL.select" type="string" default="all">
	


		<cfset LOCAL.sumpage = rc.sumpage>
		<cfset LOCAL.querryGet = rc.querryGet>


		<legend ><h1 style="color: ##0088cc;">All Products</h1></legend>

		<cfinclude template="selection.cfm">

			<div class="row clearfix">
		<cfloop query="querryGet">
			<div class="col-md-4" style="margin-bottom:10px">
				<img class="categories" src="#getContextRoot()##querryGet.image#" width="200" height="200">
				<p class="bginfo kh_bginfo">
					<cfif #len(querryGet.description)# gt 200>
						#left(querryGet.description, 200)# ...	
						<cfelse>
							#querryGet.description#
					</cfif>
						<br>
						<br>
						<br>
						<br>
						<input type="number" name="nQuantity#querryGet.productID#"
						value="1" min="1" max="99" class="quantity form-control" style="width:60px">
						<button style="float:left" class="btn btn-primary" type="button" name="btnBuyNow" onclick="btnBuyOnClick(#querryGet.productID#)">Buy!</button>
				</p>
				<a href="#buildUrl('product.detail')#/?productID=#querryGet.productID#">
				<div class="category-name kh_category-name">
					#querryGet.productName#<br> 
					<span style="float:left;margin-left:5px;">#dollarformat(querryGet.price*(100-querryGet.discount)/100)#</span>
					<br>
					<cfif #querryGet.discount# neq 0>
						<span style="float:left;margin-right:5px; text-decoration: line-through;">#dollarformat(querryGet.price)#</span>
					
						<span style="font-size:20px; float:right;margin-right:5px;">Discount: #querryGet.discount#%</span>
					</cfif>
				</div>						
				</a>
			</div>
		</cfloop>
	</div>
	<div class="row clearfix">
		<div class="col-md-12" align="center">
			<ul class="pagination" style="float: none;">
			  <li><a href="?select=#URL.select#&page=#URL.page-1#" onclick="return checkPrev()">&laquo;</a></li>
			  <cfloop from="1" to="#sumpage#" index="i">
			  	<cfif i eq URL.page>
			  		<li class="active">
						<a href="?select=#URL.select#&page=#i#">#i#</a>
					</li>
				<cfelse>
					<li>
						<a href="?select=#URL.select#&page=#i#">#i#</a>
					</li>
			  	</cfif>			
			  </cfloop>
			  <li>
			  	<a href="?select=#URL.select#&page=#URL.page+1#" onclick="return checkNext(#sumpage#)">&raquo;</a>
			  </li>
			</ul>
		</div>
	</div>
</cfoutput>
