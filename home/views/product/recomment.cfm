<script type="text/javascript">

		 $(document).ready( function () {
            var ptags=document.getElementsByTagName("p")
			for(var i=0;i<ptags.length;i++)
	    	if(ptags[i].innerHTML!="")
	       		ptags[i].setAttribute("class", "bginfo")
        });
</script>
<cfoutput>
	<cfparam name="URL.page" default="1">
	<cfset URL.idpage = (URL.page -1)*9 />
	<cfquery name="qSumRecord" datasource="happy_water">
		select Count(`product`.`productID`) as dem 
		from `product_re`, `product`, `user`
		where `product`.`productID` = `product_re`.`productid `
		and `product_re`.`groupre_id` = `user`.`groupre_id`
		and `user`.`userID`=1

	</cfquery> 

	<cfquery name="qRecomment" datasource="happy_water">
		select `product`.* 
		from `product_re`, `product`, `user`
		where `product`.`productID` = `product_re`.`productid `
		and `product_re`.`groupre_id` = `user`.`groupre_id`
		and `user`.`userID`=1
		LIMIT #URL.idpage#,9
	</cfquery>  


	<cfset sumpage = qSumRecord.dem/9+1>
	<div class="row clearfix">
		<cfloop query="qRecomment">
			<div class="col-md-4">
				<a href="#buildUrl('product.detail')#/?productID=#qRecomment.productID#" class="category-startpage">
				<img class="categories" src="#qRecomment.image#" width="300" height="300">
				#qRecomment.description#
				<div class="category-name">#qRecomment.productName#</div>
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