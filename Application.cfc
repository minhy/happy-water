component extends="lib.framework" {
	
	this.defaultdatasource = "happy_water";
	this.tag.cflocation.addtoken = false;

	this.datasources.happy_water = {
	  class: 'org.gjt.mm.mysql.Driver'
	, connectionString: 'jdbc:mysql://localhost:3306/happy_water?useUnicode=true&characterEncoding=UTF-8&useLegacyDatetimeCode=true'
	, username: 'root'
	, password: "encrypted:4cdc1b1d8d3c39e517d9bce553e815be6373078bf66de8d5"
	};
	function setupApplication() {
		// manage model and controllers with DI/1:
		var bf = new lib.ioc( "model, controllers" );
		setBeanFactory( bf );
	}

	 variables.framework = {};
	 // setup subsystems
	 variables.framework.usingSubsystems = true;
	 variables.framework.siteWideLayoutSybsystem = 'common';
	 // variables.framework.defaultSubsystem = ''
	 variables.framework.defaultSection = 'main';
	 variables.framework.defaultItem = 'default';
	 variables.framework.reloadApplicationOnEveryRequest = true;
	
}
