<cfscript>
	param name='REQUEST.response' default=structNew();
	param name='REQUEST.pretty' default=true;

	if (REQUEST.pretty) {
		_tabChar = "   ";
		_spaceChar = " ";
		_newLineChar = chr(10);
	} else {
		_tabChar = "";
		_spaceChar = "";
		_newLineChar = "";
	}

	function parseToJSON(any data, numeric depth = 0) {
		ARGUMENTS.depth++;
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
				string = '"#HTMLEditFormat(ARGUMENTS.data)#"';
			}
		} else if (isStruct(ARGUMENTS.data)) {
			string &= "{" & _newLineChar;
			for (key in ARGUMENTS.data) {
				string &= repeatString(_tabChar, ARGUMENTS.depth) & '"#lcase(key)#":#_spaceChar##parseToJSON(ARGUMENTS.data[key], ARGUMENTS.depth)#,' & _newLineChar;
			}
			string = reReplace(string,",$","","one");
			string &= repeatString(_tabChar, ARGUMENTS.depth-1) & "},";
		} else {
			string &= "[" & _newLineChar;
			for (key in ARGUMENTS.data) {
				string &= repeatString(_tabChar, ARGUMENTS.depth) & '#parseToJSON(key, ARGUMENTS.depth)#,' & _newLineChar;
			}
			string = reReplace(string,",$","","one");
			string &= repeatString(_tabChar, ARGUMENTS.depth-1) & "],";
		}
		string = reReplace(string,",$","","one");
		return string;
	}

	json = parseToJSON(REQUEST.response);

</cfscript>
<cfcontent reset="true" type="text/plain"><cfoutput>#json#</cfoutput>