<cfoutput>
	<cfparam name="URL.productID" default="0">
	<cfquery name="qGetProductByID" datasource="happy_water">
		select *, price*(100-discount)/100 as promotionprice
		from product
		where productID = 
		<cfqueryparam cfsqltype="cf_sql_integer" value="#URL.productID#">
	</cfquery>
	<cfquery name="qGetNewProduct" datasource="happy_water">
		select *, price*(100-discount)/100 as promotionprice
		from product
		where productID != <cfqueryparam value="#url.productID#" cfsqltype="cf_sql_integer">
		ORDER BY RAND()
		limit 6
	</cfquery>
	<!-- Master Page -->
	<legend><h1 style="color: ##0088cc;">Product Details: #qGetProductByID.productName#</h1></legend>
	<div class="row clearfix">
		<div class="col-md-8 showimg">
			<div>
				<img src="#qGetProductByID.image#" width="100%" height="600"/>
			</div>
			<p class="alert alert-info" style="word-wrap: break-word;">
				#qGetProductByID.text#
			</p>
			<!--- #view( "common/test" )# --->
		</div>

		<div class="col-md-4">
			<div class="header-title">
				<h3> FEATURED PRODUCTS</h3>
			</div>
			<cfset bought="0">
			<!--- <form name="fProduct" method="post" action="shopping.cfm"> --->
			<input type="hidden" name="productID" value="#url.productID#">
			<input type="hidden" name="productName" value="#qGetProductByID.productName#">
			<input type="hidden" name="price" value="#qGetProductByID.price#">
			<div class="alert alert-info">
				<div class="productDetails" style="width:100%; margin-bottom:10px;">
					<div style="width:100%;">
						Name: #qGetProductByID.productName#<br>
						<span>Price: #dollarformat(qGetProductByID.promotionprice)#</span>
						
					</div>
				</div>
				<div style="width:100%;">
					<div style="margin-left: 156px; width:5%;">
						<cfif #bought# eq 0>
						<div class="input-group" style="margin-right:5px;">
							<input type="number" name="nQuantity#qGetProductByID.productID#"
								value="1" min="1" max="99" class="form-control" style="width:70px">
							<span class="input-group-btn">
							<button class="btn btn-primary" type="button" name="btnBuyNow" onclick="btnBuyOnClick(#qGetProductByID.productID#)">Buy Now!</button>
							</span>
						</div>
						<cfelse>	
						</cfif>
					</div>
				</div>
			</div>
			<!---      </form> --->
			<div class="header-title">
				<h3>related products</h3>
			</div>

			<div id="divNewReleases">
				<cfloop query="qGetNewProduct">
						<table style="margin-bottom:10px; width:347px;">
							<tr class="alert alert-info">
								<td style="width:35px">
									<img class="productImg" style="margin-left: 5px;" src="#qGetNewProduct.image#" width="32" height="32">
								</td>
								<td>
									<a href="productDetail.cfm?productID=#qGetNewProduct.productID#"><span style="margin-right: 5px;">#qGetNewProduct.productName#</span></a>
									<br>#dollarformat(qGetNewProduct.promotionprice)#
								</td>
								<td>
									<div class="input-group" style="margin-right:5px; display:inline-block; width:115px; float:right;">
								<input type="number" name="nQuantity#qGetNewProduct.productID#"
									value="1" min="1" max="99" class="form-control" style="width:60px">
								<span class="input-group-btn">
								<button class="btn btn-primary" type="button" name="btnBuyNow" onclick="btnBuyOnClick(#qGetNewProduct.productID#)">Buy!</button>
								</span>
							</div>
								</td>
							</tr>
						</table>
				</cfloop>
		    </div>
		</div>
	</div>
	<!-- END Master Page -->
</cfoutput>