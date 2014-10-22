/**
*
* @file  /Users/Christopher/Documents/sites/api.christophervachon.com/wwwroot/docs/application.cfc
* @author  
* @description
*
*/

component extends="framework.framework1" {

	this.name = "API-Docs";

	VARIABLES.framework = {
		generateSES = true,
		SESOmitIndex = true,
		applicationKey = 'fw1',
		reloadApplicationOnEveryRequest = (this.getEnvironment() == "dev"),
		routes = [
			{"/on/:contollerName"="/main/view/controllerName/:contollerName"}
		]
	};
	
	function setupRequest() {
		REQUEST.CONTEXT.controllerPath = expandPath('../controllers');
	}

	function setupApplication() {
	}
}