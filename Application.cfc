component extends="lib.framework" {
	
	this.name = "SessionCaching";
    this.sessionmanagement = true;
    this.sessionTimeout = CreateTimeSpan(0,0,30,30);
    
    function onSessionStart() {
        session.uniqueID      = CreateUUID();
        session.shoppingcart  = arrayNew(1);
        Session.isAdmin       = false;
	 	Session.isLoggedIn    = false;
    }

	this.defaultdatasource = "happy_water";
	this.tag.cflocation.addtoken = false;

	this.datasources.happy_water = { class: 'org.gjt.mm.mysql.Driver' , connectionString: 'jdbc:mysql://xuanlv:3306/happy_water?useUnicode=true&characterEncoding=UTF-8&useLegacyDatetimeCode=true' , username: 'xuanlv' , password: "encrypted:ec0af40e040338dbb276b113105ebc65ac126caecfe461d0" };
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
