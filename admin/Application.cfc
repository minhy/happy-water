component extends="lib.framework" {
	

	this.defaultdatasource = "happy_water";
	this.tag.cflocation.addtoken = false;

	this.datasources.happy_water = {
	  class: 'org.gjt.mm.mysql.Driver'
	, connectionString: 'jdbc:mysql://xuanlv:3306/happy_water?useUnicode=true&characterEncoding=UTF-8&useLegacyDatetimeCode=true' 
	, username: 'xuanlv' 
	, password: "encrypted:ec0af40e040338dbb276b113105ebc65ac126caecfe461d0"
	};
	
	function setupApplication() {
		// manage model and controllers with DI/1:
		var bf = new lib.ioc( "model, controllers" );
		setBeanFactory( bf );
	}
	
}
