/**
*
* @file  /Users/Christopher/Documents/sites/api.christophervachon.com/wwwroot/application.cfc
* @author  
* @description
*
*/

component displayname=""  {

	this.name = 'ChristopherVachonVr0.0.1';
	this.sessionManagement = true;
	this.sessionTimeout = CreateTimespan(0,0,20,0);

	this.datasource = "cmv";
	this.ormEnabled = true;
	this.ormSettings = {
		dbcreate = "none",
		eventHandling = true,
		cfclocation = 'models',
		flushatrequestend = false,
		namingstrategy = "smart",
		dialect = "MySQL"
	};

	VARIABLES.api = {
		reloadOnEveryResquest = true
	};

	public any function onApplicationStart() {
		APPLICATION.cache = {
			controllers = {}
		};
	} // close onApplicationStart

	public any function onRequestStart() {
		if (VARIABLES.api.reloadOnEveryResquest) {
			structDelete(APPLICATION, "cache");
		}

		REQUEST.response = {
			statusCode = 200,
			headers = {},
			data = {}
		};
	} // close onRequestStart

	public any function onRequest() {
		if (REQUEST.response.statusCode == 200) {
			if (structKeyExists(CGI,"PATH_INFO") && (doesControllerExist(listGetAt(CGI.PATH_INFO,1,"/")))) {

				var _actionPrefix = CGI.REQUEST_METHOD;

				var _controllerName = listGetAt(CGI.PATH_INFO,1,"/");
				var _action = "";
				if (listLen(CGI.PATH_INFO,"/") == 1) {
					_action = "list";
				}
				if (listLen(CGI.PATH_INFO,"/") == 2) {
					_action = "view";
				}

				_action = _actionPrefix & "_" & _action;

				if (!structKeyExists(APPLICATION,"cache")) { APPLICATION.cache = {}; }
				if (!structKeyExists(APPLICATION.cache,"controllers")) { APPLICATION.cache.controllers = {}; }
				if (!structKeyExists(APPLICATION.cache.controllers, _controllerName)) {
					APPLICATION.cache.controllers[_controllerName] = createObject( 'component', "controllers." & _controllerName).init();
				}
				var _controller = APPLICATION.cache.controllers[_controllerName];

				var _requestArguments = {};
				if (structKeyExists(CGI,"QUERY_STRING")) {
					var params = listToArray(CGI.QUERY_STRING,"&");
					for (var param in params) {
						var _thisKey = listGetAt(param,1,"=");
						var _thisValue = ((listlen(param,"=") > 1)?listGetAt(param,2,"="):"null");
						_requestArguments[_thisKey] = _thisValue;
					}
				}
				if (listLen(CGI.PATH_INFO,"/") > 1) {
					_requestArguments.objectId = listGetAt(CGI.PATH_INFO,2,"/");
				}

				try {
					evaluate( '_controller.#_action#( _requestArguments )' );
				} catch (any e) {
					if (e.detail == "Ensure that the method is defined, and that it is spelled correctly.") {
						// method dosnt exist, throw a 404
						REQUEST.response.statusCode = 404;
						REQUEST.response.message = "Action Not Found";
					} else {
						// somethings went wrong in the controller... throw error...
						REQUEST.response.statusCode = 500;
						REQUEST.response.message = ((structKeyExists(e,"message"))?e.message:"I dunno... something aint right boss...");
					}
				}
			} else {
				// couldnt find the controller... throw a 404
				REQUEST.response.statusCode = 404;
				REQUEST.response.message = "Controller Not Found";
			} // close if structKeyExists(CGI,"PATH_INFO")
		} // close if REQUEST.response.statusCode == 200
	} // close onRequest

	public any function onRequestEnd() {
		// Set any Page Headers
		pc = getpagecontext().getresponse();
		if (structKeyExists(REQUEST.response,"headers")) {
			for (key in REQUEST.response.headers) {
				pc.setHeader(key,REQUEST.response.headers[key]);
			}
			structDelete(REQUEST.response, "headers");
		}
		if (structKeyExists(REQUEST.response,"statusCode")) {
			if (structKeyExists(REQUEST.response,"message")) {
				pc.getresponse().setstatus(REQUEST.response.statusCode, REQUEST.response.message);
			} else {
				pc.getresponse().setstatus(REQUEST.response.statusCode);
			}
		} else {
			pc.getresponse().setstatus(500);
			pc.getresponse().setstatustext("Lost Status Code");
		}

		include "json.cfm";
	} // close onRequestEnd

	public any function onError() {
		writeDump(ARGUMENTS); abort;
	} // close onError

	private boolean function doesControllerExist(string controllerName) {
		return fileExists(expandPath("controllers/#controllerName#.cfc"));
	} // close doesControllerExist
} // close component