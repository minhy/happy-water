/**
*
* @file  /C/Working/railoExpress/webapps/teamwork/home/controllers/product.cfc
* @author  
* @description
*
*/

component output="false" displayname=""  {

	public function init(){
		return this;
	}
	public void function showall(struct rc){
		rc.products = EntityLoad("product");
		
		//return this;
	}
}