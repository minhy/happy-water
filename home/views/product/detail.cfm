<cfoutput>
	<cfparam name="URL.productID" default="0">
	<cfquery name="qGetProductByID" datasource="happy_water">
		select *
		from product
		where productID = 
		<cfqueryparam cfsqltype="cf_sql_integer" value="#URL.productID#">
	</cfquery>
	<cfquery name="qGetNewProduct" datasource="happy_water">
		select *
		from product
		order by productID desc
		limit 4
	</cfquery>
	<!-- Master Page -->
	<div class="row clearfix">
		<div class="col-md-8 showimg">
			<div>
				<img src="#qGetProductByID.image#" width="100%" height="300"/>
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
						<span>Price: $#qGetProductByID.price#</span>
						
					</div>
				</div>
				<div style="width:100%;">
					<div style="margin-left: 90px; width:5%;">
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
				<h3> NEW RELEASES</h3>
			</div>

			<div id="divNewReleases">
				<cfloop query="qGetNewProduct">
						<div class="alert alert-info">
							<a href="productDetail.cfm?productID=#qGetNewProduct.productID#">
							<img class="productImg" src="#qGetNewProduct.image#" width="32" height="32">
							#qGetNewProduct.productName#
							</a><br>
							<span>
								$#qGetProductByID.price#
							</span>
							<div class="input-group" style="margin-right:5px; display:inline-block; width:105px; float:right; top: -16px;">
								<input type="number" name="nQuantity#qGetNewProduct.productID#"
									value="1" min="1" max="99" class="form-control" style="width:50px">
								<span class="input-group-btn">
								<button class="btn btn-primary" type="button" name="btnBuyNow" onclick="btnBuyOnClick(#qGetNewProduct.productID#)">Buy!</button>
								</span>
							</div>
						</div>
				</cfloop>
		    </div>
		</div>
	</div>
	<!-- END Master Page -->
</cfoutput>