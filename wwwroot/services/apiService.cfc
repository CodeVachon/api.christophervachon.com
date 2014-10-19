/**
*
* @file  /Users/Christopher/Documents/sites/api.christophervachon.com/wwwroot/services/apiService.cfc
* @author  
* @description
*
*/

component output="false" displayname=""  {

	public function init(){
		return this;
	}

	public any function formatResponse(required any result, required array fields) {
		var _response = javaCast("Null","");
		if (isSimpleValue(ARGUMENTS.result)) {
			return ARGUMENTS.result;
		} else if (isObject(ARGUMENTS.result) || isStruct(ARGUMENTS.result)) {
			_response = {};
			if (isObject(ARGUMENTS.result)) {
				if (arrayIsEmpty(ARGUMENTS.fields)) { ARGUMENTS.fields = ["id"]; }
				for (var _key in ARGUMENTS.fields) {
					var _propertyName = listGetAt(_key,1,".");
					if (ARGUMENTS.result.hasProperty(_propertyName)) {
						var _propertyValue = ARGUMENTS.result.getProperty(_propertyName);
						if (isSimpleValue(_propertyValue)) {
							_response[_propertyName] = _propertyValue;
						} else {
							_response[_propertyName] = this.formatResponse(_propertyValue,listToArray(_key, "."));
						}
					}
				}
			} else {
				_response.message = "This is a structure";
			}
		} else { // must be an array
			_response = [];
			for (var _thing in ARGUMENTS.result) {
				arrayAppend(_response, this.formatResponse(_thing,ARGUMENTS.fields));
			}
		}

		return _response;

		/*
		var response = [];
		for (var _article in articleList) {
			var _articleData = {};
			for (var _property in _properties) {
				var _propertyName = listGetAt(_property, 1, ".");
				if (_article.hasProperty(_propertyName)) {
					var _value = _article.getProperty(_propertyName);
					if (isSimpleValue(_value)) {
						_articleData[_property] = _value;
					} else if (isArray(_value)) {
						var _values = [];
						for (var _thisValue in _value) {
							if (isObject(_thisValue)) {
								if (listLen(_property,".") > 1) {
									var _subProperties = listToArray(_property,".");
									var _generatedValues = {};
									for (var _subProperty in _subProperties) {
										if (_thisValue.hasProperty(_subProperty)) {
											if (isSimpleValue(_thisValue.getProperty(_subProperty))) {
												_generatedValues[_subProperty] = _thisValue.getProperty(_subProperty);
											}
										}
									}
									arrayAppend(_values, _generatedValues);
								} else {
									arrayAppend(_values, _thisValue.getId());
								}
							} else {
								arrayAppend(_values, _thisValue);
							}
						} // close for (var _thisValue in _value) 
						_articleData[_propertyName] = _values;
					} // close isArray(_value)
				} // close if _article.hasProperty
			} // close for (var _property in _properties)

			arrayAppend(response, _articleData);
		} // close for (var _article in articleList)
		*/
	}
}