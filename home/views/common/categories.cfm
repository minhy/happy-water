<cfoutput>
<cfquery name="qCategories" datasource="happy_water">
	SELECT *
	FROM category
	WHERE parentID = 1
	ORDER BY categoryID
</cfquery> 
<section id="categories" class="section">
	<div class="row clearfix">
		<cfloop query="qCategories">
			<div class="col-md-4">
			<a href="#getContextRoot()#/index.cfm/product/showbycategory/?categoryID=#qCategories.categoryID#" class="category-startpage">
			<img class="categories" src="#getContextRoot()#/home/images/Wine_Penfolds_1.jpg">
			<div class="category-name">#qCategories.categoryName#</div>
			</a>
		</div>
		</cfloop>
	</div>
</section>
</cfoutput>