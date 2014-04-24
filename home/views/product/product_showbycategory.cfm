<cfoutput>
	<cfparam name="URL.categoryID" default="0">
	<cfparam name="URL.page" default="1">
	<cfset URL.idpage = (URL.page -1)*9 />
	<cfquery name="qSumRecord" datasource="happy_water">
		SELECT Count(productID) as dem
		FROM product
		WHERE categoryID = #URL.categoryID#
		ORDER BY productID

	</cfquery> 

	<cfquery name="qGetByCategory" datasource="happy_water">
		SELECT * 
		FROM product 
		WHERE categoryID = #URL.categoryID#
		ORDER BY productDate DESC
		LIMIT #URL.idpage#,9
	</cfquery>  

	<script type="text/javascript">

		 $(document).ready( function () {
            var ptags=document.getElementsByTagName("p")
			for(var i=0;i<ptags.length;i++)
	    	if(ptags[i].innerHTML!="")
	       		ptags[i].setAttribute("class", "bginfo")
        });

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
		<cfloop query="qGetByCategory">
			<div class="col-md-4">
				<a href="#buildUrl('product.product_detail')#/?productID=#qGetByCategory.productID#" class="category-startpage">
				<img class="categories" src="#qGetByCategory.image#" width="300" height="300">
				#qGetByCategory.description#
				<div class="category-name">#qGetByCategory.productName#</div>
				</a>
			</div>
		</cfloop>
	</div>
	<div class="row clearfix">
		<div class="col-md-12" align="center">
			<ul class="pagination">
			  <li><a href="?categoryID=#URL.categoryID#&page=#URL.page-1#" onclick="return checkPrev()">&laquo;</a></li>
			  <cfloop from="1" to="#sumpage#" index="i">			
				<li>
					<a href="?categoryID=#URL.categoryID#&page=#i#">#i#</a>
				</li>
			  </cfloop>
			  <li><a href="?categoryID=#URL.categoryID#&page=#URL.page+1#" onclick="return checkNext(#sumpage#)">&raquo;</a></li>
			</ul>
		</div>
	</div>
</cfoutput>
