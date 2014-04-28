<!---- Contain shipping fee --->
<cfparam name="shippingfee" type="float" default="0">



<!--- Get total price to cart--->
<cfset totalprice=0>

<cfloop array='#session.shoppingcart#' index="item">
		<cfset totalprice=totalprice+(item.price * item.quantity)>
</cfloop>



	<!--- teamplate checkout--->
<cfoutput>
	<cfparam name="form.countries" default=""/>
<form  name="checkout" method="POST" action=" ">
	<div id="page">
		<table id="cart" class="table">
		    <tbody>	          
				<table class="table">
					<thead>
						<th>##</b></th>
						<th>Product</th>
						<th>Price</th>
						<th>Quantity</th>
						<th>Total</th>
					</thead>

					<!--- get product detail in cart --->
					<cfloop from="1"to="#arrayLen(session.shoppingcart)#"index="i">
						<cfset total[i] = session.shoppingcart[i].price * session.shoppingcart[i].quantity>
						<tr style="background-color:##<cfif i MOD 2>EFEFEF<cfelse>FFFFFF</cfif>;">

							<!---No column--->
							<td>#i#</td>

							<!---Name column--->
							<td>#session.shoppingcart[i].name#</td>

							<!---Price column--->
							<td>#DollarFormat(session.shoppingcart[i].price)#</td>

							<!---Quantity column--->
							<td>#session.shoppingcart[i].quantity#</td>							

							<!---Total price for product type --->
							<td id="tdTotal#i#">
								#DollarFormat(total[i])#
							</td>
						</tr>
					</cfloop>

					<!---Total price--->
					<tr style="background-color:##DDDDDD;">
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td><b id="bTotal">Total:&nbsp;&nbsp;#DollarFormat(variables.totalprice)#</b></td>
					</tr>
				</table>

		    </tbody>
	    </table>
		
		<!--- choose nation --->
		<div style="margin:0; text-align:center;">
			<button id="modal-461273" href="##modal-container-461273" role="button" class="btn btn-primary" data-toggle="modal">Check Out Now</button>
		</div>	
			<div class="modal fade" id="modal-container-461273" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							

							<script type="text/javascript">
								$(document).ready(function(){
									$('select').on('change', function (e) {
									    var optionSelected = $("option:selected", this);
									    $('##shippingfee').val(this.value);
									});
								});
							</script>


							<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
							<h4 class="modal-title" id="myModalLabel">
								Tell us where is your location !
							</h4>
						</div>
						<div class="modal-body">
							<label for="countries">Choose your country</label>
							<div class="form-group">
								<div class="clearfix">
									<select class="form-control" name="countries" id="countries" >
										<option value="0">Viet Nam</option>
										<option value="30">Laos</option>
										<option value="30">Cambodia</option>
										<option value="40">Brunei</option>
										<option value="30">East Timor</option>								
										<option value="40">Indonesia</option>
										<option value="50">Malaysia</option>
										<option value="50">Myanmar (Burma)</option>
										<option value="40">Philippines </option>
										<option value="50">Singapore</option>
										<option value="50">Thailand</option>								
									</select>
								</div>
							</div>
							<label for="shippingfee">Your shipping fee</label>
							<div class="form-group">
								<div class="clearfix">
									<input type="number" class="form-control" name="shippingfee" id="shippingfee" value="#shippingfee#" disabled>
								</div>
							</div>
						</div>
						<div class="modal-footer">
							 <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button> 
							 <button type="submit" name="submit" class="btn btn-primary">Ok</button>
						</div>
					</div>
					
				</div>
				
			</div>
			


	</div>
</form>
</cfoutput> 
	<!--- End teamplate checkout--->

<!--- <cfif CGI.REQUEST_METHOD EQ 'POST'> --->
<cfif isDefined("form.submit")>

		<!--- set today to add orderDate--->
	<cfset toDay=dateFormat( now(),"yyyy/MM/dd")>
	<cfset shipping = #form.countries#/>
	<cfset totalship = #shipping#+#totalprice#/>

		<!--- insert order to database --->
	<cfquery name="AddToOrder" datasource="happy_water" result="od">
		INSERT INTO `order`
		(userID, orderDate, shippingFee, total)
		VALUES
		('#4#', '#toDay#', '#shippingfee#', '#totalship#')
	</cfquery>

		<!--- insert order detail to database --->


	<cfloop array="#session.shoppingcart#" index="item">
		<cfquery name="AddToOrderDetail" datasource="happy_water">
			INSERT INTO `orderdetail`
			(orderID, productID, quantity,price)
			VALUES
			('#od.GENERATED_KEY#', '#item.productID#', '#item.quantity#', '#item.price#')
		</cfquery>

	</cfloop>


<cfscript>
	arrayClear(session.shoppingcart);
</cfscript>
<cfif #ArrayLen(session.shoppingcart)# eq 0>
	<cflocation url="#buildUrl('home:main')#">
</cfif>

</cfif>






  