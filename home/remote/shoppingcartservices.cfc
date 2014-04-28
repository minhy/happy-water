<cfcomponent output="false">
	<cffunction name="updateQuantity"
		access="remote"
	    output="false"
	    returnformat="JSON">

	    <cfargument name="productID"
	    	type="numeric">

	    <cfargument name="quantity"
	    	type="numeric">

			<cfloop array="#session.shoppingcart#" index="item">
	    		<cfif item.productID eq arguments.productID>
	    			<cfset item.quantity = arguments.quantity>
	    			<cfreturn item.quantity>
	    		</cfif>
	    	</cfloop>
	</cffunction>

	<cffunction name="updateShoppingCart"
		access="remote"
	    output="false"
	    returnformat="JSON">

	    <cfargument name="productID"
	    	type="numeric">

	    <cfargument name="quantity"
	    	type="numeric">

	    <cfquery name="qGetProductByID" datasource="happy_water">
			select *
			from product
			where productID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.productID#">
		</cfquery>

		<cfscript>
			//return session.shoppingcart;
			//return session.shoppingcart[1]; 
			//return arrayLen(session.shoppingcart); 
		    LOCAL.isNewitem = true;
		    try 
		    {
			    	//return false;
			    		for( j=1; j <= arrayLen(session.shoppingcart); j++) 
				        {
			                if(session.shoppingcart[j].productid == qGetProductByID.productID) 
			                {
			                   session.shoppingcart[j].quantity +=  arguments.quantity;
			                   LOCAL.isNewitem = false; 
			                   //return session.shoppingcart;                  
			                   return true;
			                }
				        }

				        if(LOCAL.isNewitem) 
				        {
				            product = structNew();
				            product.productID = qGetProductByID.productID;
				            product.name = qGetProductByID.productName;
				            product.price = qGetProductByID.price;
				            product.quantity = arguments.quantity;
				            arrayAppend(session.shoppingcart, product);
				            //return session.shoppingcart; 
				            return  true;
				        }
			    	   
		    }
		    catch (any ex) {
				return ex;
		    }
		</cfscript>
	</cffunction>
	<cffunction name="showShoppingCart"
		access="remote"
	    output="false"
	    returnformat="JSON">
		<cfreturn session.shoppingcart>
		<cfreturn list>
	</cffunction>

	<cffunction name="removeProduct"
		access="remote"
	    output="false"
	    returnformat="JSON">

	    <cfargument name="id"
	    	type="numeric">

	    <cfscript>
	    	for( j=1; j <= arrayLen(session.shoppingcart); j++) 
	        {
                if(session.shoppingcart[j].productid == arguments.id) 
                {
                   arrayDeleteAt(session.shoppingcart, j);                 
                   return true;
                }
	        }
	    </cfscript>

	</cffunction>

	<cffunction name="countProduct"
  		access="remote"
     	output="false"
     	returnformat="JSON">

	     <cfscript>
	      return arrayLen(session.shoppingcart);
	     </cfscript>

 </cffunction>
</cfcomponent>