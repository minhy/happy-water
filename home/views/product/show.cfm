<cfoutput>
	<cfparam name="URL.page" default="1">
	<cfset URL.idpage = (URL.page -1)*9 />
	<cfparam name="URL.select" type="string" default="all">
	

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


		<cfquery name="qSumColumn1" datasource="happy_water">
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

		<cfquery name="qSumColumn2">
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

		<cfif URL.select eq "all">
		
			<cfset sumpage = ceiling(qSumColumn.dem/9)>
			<cfset querryGet=qGetAll>

		<cfelseif URL.select eq "new">

			<cfset sumpage = ceiling(qSumColumn1.dem/9)>
			<cfset querryGet=qGetByNew>

		<cfelse >
			<cfset sumpage = ceiling(qSumColumn2.dem/9)>
			<cfset querryGet=qGetByTopdeal>
		</cfif>



		<legend ><h1 style="color: ##0088cc;">All Products</h1></legend>

		<cfinclude template="selection.cfm">

		<div class="row clearfix">
			<div class="col-md-12" align="center">
				<div class="row clearfix">
					<cfloop query="querryGet">
						<div class="col-md-4" style="margin-bottom:10px;">
							<img class="categories" src="#querryGet.image#" width="200" height="200">
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
						  <li><a href="?select=all&page=#URL.page-1#" onclick="return checkPrev()">&laquo;</a></li>
						  <cfloop from="1" to="#sumpage#" index="i">
						  	<cfif i eq URL.page>
						  		<li class="active">
									<a href="?select=all&page=#i#">#i#</a>
								</li>
							<cfelse>
								<li>
									<a href="?select=all&page=#i#">#i#</a>
								</li>
						  	</cfif>			
						  </cfloop>
						  <li>
						  	<a href="?select=all&page=#URL.page+1#" onclick="return checkNext(#sumpage#)">&raquo;</a>
						  </li>
						</ul>
					</div>
				</div>
			</div>
		</div>

		</cfoutput>
