<footer id="footer">
	<div class="row clearfix">
		<div class="col-md-12 column">
			HAPPY WATER - ALL RIGHTS RESERVED
		</div>
	</div>
	<!-- Modal -->
	<form name="fShopCart" method="POST" action="#getContextRoot()#/index.cfm/product/chectOut">
		<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
			<div class="modal-dialog modal-lg">
				<div class="modal-content" style="margin-top: 100px;">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
						<h4 class="modal-title" id="myModalLabel">Your shopping cart</h4>
					</div>
					<div class="modal-body">
						<cfoutput>
							<div>
								<input type="hidden" id="numberProduct" value="#arrayLen(session.shoppingcart)#"/>
									<body>
										<div id="w">
											<div id="page">
												<table id="cart" class="table">
													<tbody>
														<cfif IsDefined('session.shoppingcart')>
														<cfset variables.totalprice = 0>
														<table class="table">
															<thead style="font-size:13px;">
																<th style="text-align:left;">##</b></th>
																<th style="text-align:left;">Product</th>
																<th style="text-align:right;">Price</th>
																<th style="text-align:center;">Quantity</th>
																<th style="text-align:right;">Total</th>
																<th style="text-align:right;">Action</th>
															</thead>
															<tbody  id="tbody">
															</tbody>
														</table>
														</cfif>
													</tbody>
												</table>
											</div>
										</div>
									</body>
								</html>
							</div>
						</cfoutput>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
						<a href="<cfoutput>#buildUrl('product.checkout')#</cfoutput>" class="btn btn-primary">Go to check out page !</a>
					</div>
				</div>
			</div>
		</div>
		<input type="hidden" name="totalPrice" id="hdTotalPrice"/> 
	</form>
</footer>