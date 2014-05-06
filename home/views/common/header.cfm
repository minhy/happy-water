<cfparam name="SESSION.isLoggedIn" default="false">
<cfparam name="SESSION.name" default="">

<cfoutput>
	<header id="header">
		<div class="container header">
			<div class="row clearfix">
				<a href="#getContextRoot()#">
					<div class="col-md-1 column logo"></div>
				</a>
				<div class="col-md-6 column">
					<cfinclude template="menu.cfm" />
				</div>
				<div class="col-md-4 column">
					<div class="row clearfix">
						<div class="col-md-8 column register">
					
							<cfif SESSION.isLoggedIn EQ true>
						
					
                        <a href="##" class="dropdown-toggle" data-toggle="dropdown">Hi! #SESSION.name# <b class="caret"></b></a>
                        <ul class="dropdown-menu">
                            
                        	<cfif SESSION.isAdmin EQ true>
                        		<li >
                            	<a href="#getContextRoot()#/index.cfm/admin:main">Admin Dashboard</a>
                            </li>
                        	</cfif>

                            <li >
                            	<a href="#getContextRoot()#/index.cfm/home:user_edit">User edit</a>
                            </li>

                            <li >
                            	<a href="#getContextRoot()#/index.cfm/home:changepassword">Change your password</a>
                            </li>

                            <li >
                            	<a href="#getContextRoot()#/index.cfm/home:product/recommended">Recommened Products</a>
                            </li>
                            
                        </ul>
                   	
							<a href="#getContextRoot()#/index.cfm/home:logout">Log Out</a>
							<cfelse>
							<a href="#getContextRoot()#/index.cfm/home:register">Register</a> / <a href="#getContextRoot()#/index.cfm/home:login">Sign In</a>
							
							</cfif>


						<!--- </cflock> --->

					</div>
						<div class="col-md-4 column cart">
							<a href="##" onclick="showShoppingCart()"><span class="glyphicon glyphicon-shopping-cart" data-toggle="modal" data-target="##myModal" id="aShoppingCart">(#arrayLen(session.shoppingcart)#products)</span></a>
						</div>
					</div>
				</div>
			</div>
		</div>
		<script type="text/javascript">

			var bCheckout;

			$( document ).ready(function() {
				countProduct();

				$("##aCheckout").click(function(){
					if(!bCheckout)
				    {
				    	alert('Your cart has no product ! Please choose product before you can check out !');
				    	return false;
				    }
				    else {
				    	window.location = "#buildUrl('product.checkout')#";
				      $('##checkout').submit();
				      return true;
				    }
				});
			});

			var numberProduct = 0;
			
			function formatUSD(currency) {
			      return "$" + currency.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, "$1,");
			  }
			
			function countProduct(){
			var count = 0;
			$.ajax({
			              type: "get",
			              url: "#getContextRoot()#/home/remote/shoppingcartservices.cfc?",
			              data: {
			              	method:"countProduct"
			              },
			              dataType: "json",
			              success: function(data){
			              		$("##aShoppingCart").html("("+ data + "products)");
			              }
			          });
			}
			
			  	function deleteProduct(productId){
			$.ajax({
			              type: "get",
			              url: "#getContextRoot()#/home/remote/shoppingcartservices.cfc?WSDL",
			              data: {
			                  method: "removeProduct",
			                  id: productId
			              },
			              dataType: "json",
			              success: function(data){
			              	showShoppingCart();
			              	countProduct();
				   }
			          });
			}
			
			  function changeQuantity(productID,quantity,price,i){
			    var total = 0;
			    $("[name='nQuantity" + productID + "']").val(quantity);
			    $("##tdTotal" + i).text(formatUSD(quantity*price));
			    $("##hdTotal" + i).val(quantity*price);
			    for(var j = 1; j<=numberProduct;j++)
			    {
			      total += Number($("##hdTotal" + j).val());
			      //alert(total);
			    }

			    if (total == 0)
			    	bCheckout = false;
			    else
			    	bCheckout = true;

			    total = formatUSD(Number(total));
			    $("##bTotal").html("Total:&nbsp;&nbsp;" + total);
			    $("##hdTotalPrice").val(total);    
			
			    $.ajax({
			               type: "get",
			               url: "#getContextRoot()#/home/remote/shoppingcartservices.cfc?WSDL",
			               data: {
			                   method: "updateQuantity",
			                   productID: productID,
			                   quantity:quantity
			               },
			               dataType: "json",
			               success: function(data){
			               }
			           });    
			  }
			
			function showShoppingCart(){
				$.ajax({
			               type: "get",
			               url: "#getContextRoot()#/home/remote/shoppingcartservices.cfc?WSDL",
			               data: {
			                   method: "showShoppingCart"
			               },
			               dataType: "json",
			               success: function(data){
			               	//alert(data);
			               	$(".trProduct").remove();
			               	$("##trTotal").remove();
			               	
			               	numberProduct = data.length;
			               	var s = "";
			               	var totalprice = 0;
			               	for(var i=0;i<data.length;i++){
			               		totalprice += data[i].PRICE*data[i].QUANTITY;
			               		s += "<tr class='trProduct' style='background-color:DDDDDD; font-size:13px;'>"
								    + "<td>" + Number(i+1) + "</td>"  
								    + "<td>" + data[i].NAME + "</td>"
								    + "<td style='text-align:right;'>" + formatUSD(Number(data[i].PRICE)) + "</td>"
								    + "<td style='text-align:center;'> <input type='number' value='"+ data[i].QUANTITY +"' min='0' max='99' onchange='changeQuantity(" + data[i].PRODUCTID + ",this.value," + data[i].PRICE + "," + Number(i+1)+ ")'> </td>"
								    + "<td id='tdTotal" + Number(i+1) +"' style='text-align:right;'>"+ formatUSD(Number(data[i].PRICE*data[i].QUANTITY)) + "</td>"
								    + "<td  style='text-align:right;'><a class='btn btn-danger' href='##' onclick='deleteProduct("+ data[i].PRODUCTID +")'>Remove</td>"
								    +"</tr>"
								    + "<input type='hidden' id='hdTotal" + Number(i+1) + "' value='" + Number(data[i].PRICE*data[i].QUANTITY) +"'>"
								    + "<input type='hidden' name='hdProductID' value='" + data[i].PRODUCTID +"'>";
					    	}
					    	s +=    "<tr id='trTotal'>"
								    + "<td>&nbsp;</td>"
								    + "<td>&nbsp;</td>"
								    + "<td>&nbsp;</td>"
								    + "<td>&nbsp;</td>"
								    + "<td><b id='bTotal' style='font-size:15px;'> Total: 	" + formatUSD(Number(totalprice)) + "</b></td>"
								    + "<td>&nbsp;</td>"
								    + "</tr>";
					    	$("##tbody").html(s);

					    	if(totalprice == 0)
					    		bCheckout = false;
					    	else
					    		bCheckout = true;
					   }
			           });
				}

				function btnBuyOnClick(productID){
					var quantity = $("[name='nQuantity" + productID + "']").val();


					$.ajax({
				               type: "get",
				               url: "#getContextRoot()#/home/remote/shoppingcartservices.cfc?",
				               data: {
				               	method:"updateShoppingCart",
				                   productID: productID,
				                   quantity:quantity
				               },
				               dataType: "json",
				               success: function(data){
				               	if(data == true){
				               		countProduct();
				               		alert("Succsess");
				               	}
				               	else
				               		alert("failed");
				               }
				           });
				}


		</script>
	</header>
</cfoutput>