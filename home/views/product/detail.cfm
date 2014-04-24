<script type="text/javascript">

		 $(document).ready( function () {
            var ptags=document.getElementsByTagName("p")
			for(var i=0;i<ptags.length;i++)
	    	if(ptags[i].innerHTML!="")
	       		ptags[i].setAttribute("class", "details")
        });
</script>
<cfoutput>
	<cfparam name="URL.productID" default="0">
				
				<cfquery name="qGetProductByID" datasource="happy_water">
					select *
					from product
					where productID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.productID#">
				</cfquery>

				<cfquery name="qGetNewProduct" datasource="happy_water">
					select *
					from product
					order by productID desc
					limit 4
				</cfquery>
				<div class="row clearfix">
					<div class="col-md-8 showimg">
						<div>
								<img src="#qGetProductByID.image#" width="100%" height="300"/>
						</div>
						#qGetProductByID.text#
					</div>
					<div class="col-md-4">
						<div class="header-title">
							 <h3> FEATURED PRODUCTS</h3>
						</div>
						<div class="featured">
							<div>
								Name: #qGetProductByID.productName#<br>
								<span>Price: $#qGetProductByID.price#</span>
							</div>
							<div>
								<input type="button" value="BUY NOW" class="btn btn-default" name="btnBuyNow"/>
							</div>
						</div>

						<div class="header-title">
							 <h3> NEW RELEASES</h3>
						</div>
						<cfloop query="qGetNewProduct">
							<div>
								<div>
									<a href="#getContextRoot()#/index.cfm/product/detail/?productID=#qGetNewProduct.productID#">
										<img class="productImg" src="#qGetNewProduct.image#" width="32" height="32">
										#qGetNewProduct.productName#
									</a><br>
									<span>$#qGetProductByID.price#</span>
								</div>
								<div>
									
								</div>
							</div>
							<br>
						</cfloop>
						
					</div>
				</div>
</cfoutput>