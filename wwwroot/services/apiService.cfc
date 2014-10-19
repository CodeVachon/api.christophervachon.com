/**
*
* @file  /Users/Christopher/Documents/sites/api.christophervachon.com/wwwroot/services/apiService.cfc
* @author  
* @description
*
*/

component output="false" displayname=""  {

	public function init() { return this; }


	public any function formatResponse(required any result, array fields = []) {
		var _response = javaCast("Null","");

		if (isSimpleValue(ARGUMENTS.result)) {
			// no formatting required, return as is 
			return ARGUMENTS.result;
		} else if (isObject(ARGUMENTS.result) || isStruct(ARGUMENTS.result)) {
			_response = {};
			if (isObject(ARGUMENTS.result)) {
				if (arrayIsEmpty(ARGUMENTS.fields)) { ARGUMENTS.fields = ["id"]; } // if no specific fields are asked for, return the object id 
				for (var _key in ARGUMENTS.fields) {
					var _propertyName = listGetAt(_key,1,".");
					if (ARGUMENTS.result.hasProperty(_propertyName)) {
						var _propertyValue = ARGUMENTS.result.getProperty(_propertyName);
						if (isSimpleValue(_propertyValue)) {
							_response[_propertyName] = _propertyValue;
						} else {
							var _thisValuesFields = listToArray(_key, ".");
							ArrayDeleteAt(_thisValuesFields, 1); // remove the propertyName from the array
							_response[_propertyName] = this.formatResponse(_propertyValue,_thisValuesFields);
						}
					} else {
						_response[_propertyName] = "unknown property";
					} // close if (ARGUMENTS.result.hasProperty(_propertyName))
				} // close for (var _key in ARGUMENTS.fields) 
			} else { // close if is Object
				for (var _structKey in ARGUMENTS.result) {
					_response[_structKey] = this.formatResponse(_thing,ARGUMENTS.fields);
				}
			} // close if is Object -- else
		} else { 
			// must be an array
			_response = [];
			for (var _thing in ARGUMENTS.result) {
				arrayAppend(_response, this.formatResponse(_thing,ARGUMENTS.fields));
			}
		} // close if ARGUMENTS.result type

		return _response;
	} // close formatResponse


	public string function parseToJSON(any data, numeric depth = 0, boolean pretty = true) {
		ARGUMENTS.depth++;

		if (ARGUMENTS.pretty) {
			_tabChar = "   ";
			_spaceChar = " ";
			_newLineChar = chr(10);
		} else {
			_tabChar = "";
			_spaceChar = "";
			_newLineChar = "";
		}

		string = "";
		if (isSimpleValue(ARGUMENTS.data)) {
			if (isNumeric(ARGUMENTS.data)) {
				string = ARGUMENTS.data;
			} else if (isBoolean(ARGUMENTS.data)) {
				if (ARGUMENTS.data) {
					string = 'true';
				} else {
					string = 'false';
				}
			} else if (isDate(ARGUMENTS.data)) {
				string = '"#GetHttpTimeString(ARGUMENTS.data)#"';
			} else {
				string = '"#JSStringFormat(ARGUMENTS.data)#"';
			}
		} else if (isStruct(ARGUMENTS.data)) {
			string &= "{" & _newLineChar;
			for (key in ARGUMENTS.data) {
				string &= repeatString(_tabChar, ARGUMENTS.depth) & '"#lcase(key)#":#_spaceChar##this.parseToJSON(ARGUMENTS.data[key], ARGUMENTS.depth)#,' & _newLineChar;
			}
			string = reReplace(string,",$","","one");
			string &= repeatString(_tabChar, ARGUMENTS.depth-1) & "},";
		} else {
			string &= "[" & _newLineChar;
			for (key in ARGUMENTS.data) {
				string &= repeatString(_tabChar, ARGUMENTS.depth) & '#this.parseToJSON(key, ARGUMENTS.depth)#,' & _newLineChar;
			}
			string = reReplace(string,",$","","one");
			string &= repeatString(_tabChar, ARGUMENTS.depth-1) & "],";
		}
		string = reReplace(string,",$","","one");
		return string;
	} // close parseToJSON


} // close component
