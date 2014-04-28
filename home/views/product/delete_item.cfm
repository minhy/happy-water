<cfset temp = arrayDeleteAt(session.shoppingcart, #URL.id#)>
<cfdump eval=session.shoppingcart>
<cflocation addtoken="false"url="#getContextRoot()#/index.cfm/product/shopping">