<cfoutput>
	<header id="header">
		<div class="container header">
			<div class="row clearfix">
				<div class="col-md-2 column logo">
				</div>
				<div class="col-md-6 column">
					<cfinclude template="menu.cfm" />
				</div>
				<div class="col-md-4 column">
					<div class="row clearfix">
						<div class="col-md-6 column register">
							<a href="##">Register</a> / <a href="##">Sign In</a>
						</div>
						<div class="col-md-6 column cart">
							<a href="##" onclick="showShoppingCart()"><span class="glyphicon glyphicon-shopping-cart" data-toggle="modal" data-target="##myModal" id="aShoppingCart">(#arrayLen(session.shoppingcart)#products)</span></a>
						</div>
					</div>
				</div>
			</div>
		</div>
		<script type="text/javascript">
			var numberProduct = 0;
			
			function formatUSD(currency) {
			      return "$" + currency.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, "$1,");
			  }
			
			function countProduct(){
			var count = 0;
			$.ajax({
			              type: "get",
			              url: "http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT#/home/remote/shoppingcartservices.cfc?",
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
			              url: "http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT#/home/remote/shoppingcartservices.cfc?WSDL",
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
			    total = formatUSD(Number(total));
			    $("##bTotal").html("Total:&nbsp;&nbsp;" + total);
			    $("##hdTotalPrice").val(total);    
			
			    $.ajax({
			               type: "get",
			               url: "http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT#/home/remote/shoppingcartservices.cfc?WSDL",
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
			               url: "http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT#/home/remote/shoppingcartservices.cfc?WSDL",
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
			               		s += "<tr class='trProduct' style='background-color:DDDDDD;'>"
								    + "<td>" + Number(i+1) + "</td>"  
								    + "<td>" + data[i].NAME + "</td>"
								    + "<td>" + formatUSD(Number(data[i].PRICE)) + "</td>"
								    + "<td> <input type='number' value='"+ data[i].QUANTITY +"' min='0' max='99' onchange='changeQuantity(" + data[i].PRODUCTID + ",this.value," + data[i].PRICE + "," + Number(i+1)+ ")'> </td>"
								    + "<td id='tdTotal" + Number(i+1) +"'>"+ formatUSD(Number(data[i].PRICE*data[i].QUANTITY)) + "</td>"
								    + "<td><a href='##' onclick='deleteProduct("+ data[i].PRODUCTID +")'>Remove</td>"
								    +"</tr>"
								    + "<input type='hidden' id='hdTotal" + Number(i+1) + "' value='" + Number(data[i].PRICE*data[i].QUANTITY) +"'>"
								    + "<input type='hidden' name='hdProductID' value='" + data[i].PRODUCTID +"'>";
					    	}
					    	s +=    "<tr id='trTotal'>"
								    + "<td>&nbsp;</td>"
								    + "<td>&nbsp;</td>"
								    + "<td>&nbsp;</td>"
								    + "<td>&nbsp;</td>"
								    + "<td><b id='bTotal'> Total: 	" + formatUSD(Number(totalprice)) + "</b></td>"
								    + "<td>&nbsp;</td>"
								    + "</tr>";
					    	$("##tbody").html(s);
					   }
			           });
				}
		</script>
	</header>
</cfoutput>