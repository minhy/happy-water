<cfoutput>
	<cfparam name="URL.page" default="1">
	<cfset URL.idpage = (URL.page -1)*9 />
	<cfquery name="qSumRecord" datasource="happy_water">
		SELECT Count(productID) as dem
		FROM product
		WHERE productDate BETWEEN DATE_SUB(CURDATE(), INTERVAL 7 DAY) AND CURDATE()
		ORDER BY productID

	</cfquery> 

	<cfquery name="qGetByNew" datasource="happy_water">
		SELECT * 
		FROM product 
		WHERE productDate BETWEEN DATE_SUB(CURDATE(), INTERVAL 7 DAY) AND CURDATE()
		ORDER BY productDate DESC
		LIMIT #URL.idpage#,9
	</cfquery>  

	<script type="text/javascript">
        function checkPrev(){
        	var search= window.location.search;
        	var result= search.substr(6,1);
            if(result<=1)
            {
            	return false;
            }           
            else{
            	return true;
            }
             
        }
        function checkNext(totalPage){
        	var search= window.location.search;
        	var result= search.substr(6,1);
            if(result>=totalPage)
            {
            	return false;
            }           
            else{
            	return true;
            }
             
        }
     </script>

	<cfset sumpage = qSumRecord.dem/9+1>
	<div class="row clearfix">
		<cfloop query="qGetByNew">
			<div class="col-md-4">
				<a href="#buildUrl('product.product_detail')#/?productID=#qGetByNew.productID#" class="category-startpage">
				<img class="categories" src="#qGetByNew.image#" width="300" height="300">
				<p class="bginfo">#qGetByNew.description#</p>
				<div class="category-name">#qGetByNew.productName#</div>
				</a>
			</div>
		</cfloop>
	</div>
	<div class="row clearfix">
		<div class="col-md-12" align="center">
			<ul class="pagination">
			  <li><a href="?page=#URL.page-1#" onclick="return checkPrev()">&laquo;</a></li>
			  <cfloop from="1" to="#sumpage#" index="i">			
				<li>
					<a href="?page=#i#">#i#</a>
				</li>
			  </cfloop>
			  <li><a href="?page=#URL.page+1#" onclick="return checkNext(#sumpage#)">&raquo;</a></li>
			</ul>
		</div>
	</div>
</cfoutput>
