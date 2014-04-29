<cfoutput>
	<cfparam name="URL.page" default="1">
	<cfset URL.idpage = (URL.page -1)*9 />
	<cfparam name="select" type="string" default="all">
	<cfset select = #URL.select#>

	<cfif select eq "all">

		<cfquery name="qSumColumn">
			select Count(productID) as dem
			from product where status = 1 and IsActive = 1
			order by productID
		</cfquery> 

		<cfquery name="qGetAll">
			select *
			from product where status = 1 and IsActive = 1
			limit #URL.idpage#,9
		</cfquery>  

		<cfset sumpage = ceiling(qSumColumn.dem/9)>

		<legend ><h1 style="color: ##0088cc;">All Products</h1></legend>

		<cfinclude template="selection.cfm">

		<div class="row clearfix">
			<div class="col-md-12" align="center">
				<div class="row clearfix">
					<cfloop query="qGetAll">
						<div class="col-md-4" style="margin-bottom:10px;">
							<img class="categories" src="#qGetAll.image#" width="200" height="200">
							<p class="bginfo kh_bginfo">
								<cfif #len(qGetAll.description)# gt 200>
									#left(qGetAll.description, 200)# ...	
									<cfelse>
										#qGetAll.description#
								</cfif>
									<br>
									<br>
									<br>
									<br>
									<input type="number" name="nQuantity#qGetAll.productID#"
									value="1" min="1" max="99" class="quantity form-control">
									<button style="float:left" class="btn btn-primary" type="button" name="btnBuyNow" onclick="btnBuyOnClick(#qGetAll.productID#)">Buy!</button>
							</p>
							<a href="#buildUrl('product.detail')#/?productID=#qGetAll.productID#">
							<div class="category-name kh_category-name">
								#qGetAll.productName#<br> 
								<span style="float:left;margin-left:5px;">#dollarformat(qGetAll.price*(100-qGetAll.discount)/100)#</span>
								<br>
								<cfif #qGetAll.discount# neq 0>
									<span style="float:left;margin-right:5px; text-decoration: line-through;">#dollarformat(qGetAll.price)#</span>
								
									<span style="font-size:20px; float:right;margin-right:5px;">Discount: #qGetAll.discount#%</span>
								</cfif>
							</div>						
							</a>
						</div>
					</cfloop>
				</div>
				<div class="row clearfix">
					<div class="col-md-12" align="center">
						<ul class="pagination" style="float: none;">
						  <li><a href="?select=all&page=#URL.page-1#" onclick="return checkPrev()">&laquo;</a></li>
						  <cfloop from="1" to="#sumpage#" index="i">			
							<li>
								<a href="?select=all&page=#i#">#i#</a>
							</li>
						  </cfloop>
						  <li><a href="?select=all&page=#URL.page+1#" onclick="return checkNext(#sumpage#)">&raquo;</a></li>
						</ul>
					</div>
				</div>
			</div>
		</div>
	</cfif>
	<cfif select eq "new">
		<cfquery name="qSumRecord" datasource="happy_water">
			SELECT Count(productID) as dem
			FROM product
			WHERE productDate BETWEEN DATE_SUB(CURDATE(), INTERVAL 7 DAY) AND CURDATE() and status = 1 and IsActive = 1
			ORDER BY productID
		</cfquery> 

		<cfquery name="qGetByNew" datasource="happy_water">
			SELECT * 
			FROM product 
			WHERE productDate BETWEEN DATE_SUB(CURDATE(), INTERVAL 7 DAY) AND CURDATE() and status = 1 and IsActive = 1
			ORDER BY productDate DESC
			LIMIT #URL.idpage#,9
		</cfquery>  

		<cfset sumpage = ceiling(qSumRecord.dem/9)>

		<legend ><h1 style="color: ##0088cc;">New Products</h1></legend>

		<cfinclude template="selection.cfm">

		<div class="row clearfix">
			<div class="col-md-12" align="center">
				<div class="row clearfix">
					<cfloop query="qGetByNew">
				<div class="col-md-4" style="margin-bottom:10px;">
			
					<img class="categories" src="#qGetByNew.image#" width="200" height="200">
					<p class="bginfo kh_bginfo">
						<cfif #len(qGetByNew.description)# gt 200>
									#left(qGetByNew.description, 200)# ...	
									<cfelse>
										#qGetByNew.description#
								</cfif>
							<br>
							<br>
							<br>
							<br>
							<input type="number" name="nQuantity#qGetByNew.productID#"
							value="1" min="1" max="99" class="quantity form-control">
							<button style="float:left" class="btn btn-primary" type="button" name="btnBuyNow" onclick="btnBuyOnClick(#qGetByNew.productID#)">Buy!</button>
					</p>
					<a href="#buildUrl('product.detail')#/?productID=#qGetByNew.productID#">
					<div class="category-name kh_category-name">
						#qGetByNew.productName#<br> 
						<span style="float:left;margin-left:5px;">#dollarformat(qGetByNew.price*(100-qGetByNew.discount)/100)#</span>
						<br>
						<cfif #qGetByNew.discount# neq 0>
							<span style="float:left;margin-right:5px; text-decoration: line-through;">#dollarformat(qGetByNew.price)#</span>
						
							<span style="font-size:20px; float:right;margin-right:5px;">Discount: #qGetByNew.discount#%</span>
						</cfif>
					</div>
					</a>
				</div>
			</cfloop>
				</div>
				<div class="row clearfix">
					<div class="col-md-12" align="center">
						<ul class="pagination" style="float: none;">
						  <li><a href="?select=new&page=#URL.page-1#" onclick="return checkPrev()">&laquo;</a></li>
						  <cfloop from="1" to="#sumpage#" index="i">			
							<li>
								<a href="?select=new&page=#i#">#i#</a>
							</li>
						  </cfloop>
						  <li><a href="?select=new&page=#URL.page+1#" onclick="return checkNext(#sumpage#)">&raquo;</a></li>
						</ul>
					</div>
				</div>
			</div>
		</div>
	</cfif>
	<cfif select eq "top">
		<cfquery name="qSumRecord">
			SELECT Count(productID) as dem 
			FROM product
			WHERE discount <> 0  and status = 1 and IsActive = 1
			ORDER BY discount DESC 
		</cfquery> 

		<cfquery name="qGetByTopdeal">
			SELECT * 
			FROM product
			WHERE discount <> 0 and status = 1 and IsActive = 1
			ORDER BY discount DESC 
			LIMIT #URL.idpage#,9
		</cfquery>  

		<cfset sumpage = ceiling(qSumRecord.dem/9)>

		<legend ><h1 style="color: ##0088cc;">Top Deal Products</h1></legend>

		<cfinclude template="selection.cfm">

		<div class="row clearfix">
			<div class="col-md-12" align="center">
				<div class="row clearfix">
					<cfloop query="qGetByTopdeal">
						<div class="col-md-4" style="margin-bottom:10px;">
							<img class="categories" src="#qGetByTopdeal.image#" width="200" height="200">
							<p class="bginfo kh_bginfo">
								<cfif #len(qGetByTopdeal.description)# gt 200>
									#left(qGetByTopdeal.description, 200)# ...	
									<cfelse>
										#qGetByTopdeal.description#
								</cfif>
									<br>
									<br>
									<br>
									<br>
									<input type="number" name="nQuantity#qGetByTopdeal.productID#"
									value="1" min="1" max="99" class="quantity form-control">
									<button style="float:left" class="btn btn-primary" type="button" name="btnBuyNow" onclick="btnBuyOnClick(#qGetByTopdeal.productID#)">Buy!</button>
							</p>
							<a href="#buildUrl('product.detail')#/?productID=#qGetByTopdeal.productID#">
							<div class="category-name kh_category-name">
								#qGetByTopdeal.productName#<br> 
								<span style="float:left;margin-left:5px;">#dollarformat(qGetByTopdeal.price*(100-qGetByTopdeal.discount)/100)#</span>
								<br>
								<cfif #qGetByTopdeal.discount# neq 0>
									<span style="float:left;margin-right:5px; text-decoration: line-through;">#dollarformat(qGetByTopdeal.price)#</span>
									
									<span style="font-size:20px; float:right;margin-right:5px;">Discount: #qGetByTopdeal.discount#%</span>
								</cfif>
							</div>
							</a>
						</div>
					</cfloop>
				</div>
				<div class="row clearfix">
					<div class="col-md-12" align="center">
						<ul class="pagination" style="float: none;">
						  <li><a href="?select=top&page=#URL.page-1#" onclick="return checkPrev()">&laquo;</a></li>
						  <cfloop from="1" to="#sumpage#" index="i">			
							<li>
								<a href="?select=top&page=#i#">#i#</a>
							</li>
						  </cfloop>
						  <li><a href="?select=top&page=#URL.page+1#" onclick="return checkNext(#sumpage#)">&raquo;</a></li>
						</ul>
					</div>
				</div>
			</div>
		</div>
	</cfif>
</cfoutput>
