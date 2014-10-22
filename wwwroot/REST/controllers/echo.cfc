/**
*
* @file  /REST/controllers/echo.cfc
* @author  
* @description
*
*/

component output="false" displayname=""  {

	VARIABLES.apiService = javaCast("null","");

	public function init(){
		this.apiService = new REST.services.apiService();

		return this;
	} // close init

	/**
	* @method 	Echo
	* @action 	Get
	* @hint 	Returns back the data received
	* @use 		/REST/echo/
	*/
	public void function get_echo(args) {

		var _cgidata = {};
		for (var _key in CGI) {
			if (
				(left(_key,4) == "http") ||
				(left(_key,2) == "x-")
			) {
				_cgidata[_key] = CGI[_key];
			}
		}
		REQUEST.response.cgi = _cgidata;

		var _formdata = {};
		for (var _key in FORM) {
			_formdata[_key] = FORM[_key];
		}
		if (!structIsEmpty(_formdata)) {
			REQUEST.response.post = _formdata;
		}

		var _urldata = {};
		for (var _key in URL) {
			if (_key != "_rewrite") {
				if (_key == "fields") {
					var _fields = [];
					var _input = listToArray(URL[_key], ",");
					for (var i = 1; i<= arrayLen(_input); i++) {
						if (listLen(_input[i],".") > 1) {
							for (var j = 2; j <= listLen(_input[i],"."); j++) {
								arrayAppend(_fields,  listGetAt(_input[i],1,".") & "." & listGetAt(_input[i],j,".")  );
							}
						} else {
							arrayAppend(_fields,_input[i]);
						}
					}
					_urldata[_key] = _fields;
				} else {
					_urldata[_key] = URL[_key];
				}
			}
		}
		if (!structIsEmpty(_urldata)) {
			REQUEST.response.queryparams = _urldata;
		}
	} // close get_echo


} // close component