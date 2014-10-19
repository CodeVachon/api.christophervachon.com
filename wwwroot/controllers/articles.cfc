/**
*
* @file  /Users/Christopher/Documents/sites/api.christophervachon.com/wwwroot/controllers/articles.cfc
* @author  
* @description
*
*/

component output="false" displayname=""  {

	VARIABLES.articleService = javaCast("null","");

	public function init() {
		this.articleService = new services.articleService();
		return this;
	} // close init


	public function get_list(args) {
		var _serArgs = {};
		_serArgs.page = ((structKeyExists(args,"page"))?args.page:1);
		_serArgs.itemsPerPage = ((structKeyExists(args,"itemsPerPage"))?args.itemsPerPage:5);
		var articleList = this.articleService.getArticles(_serArgs);
		
		if (structKeyExists(args,"fields")) {
			_properties = listToArray(args.fields,",");
		} else {
			_properties = ["id","title","summary","publicationDate"];
		}

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

		REQUEST.response.data = response;
		REQUEST.response.headers = {
			"X-Total-Count" = 100,
			"X-Page" = _serArgs.page
		};
	} // close get_list


	public function get_view(args) {
		var _serArgs = {
			articleId = args.objectId
		};

		var _article = this.articleService.getArticle(_serArgs);

		if (isNull(_article)) {
			REQUEST.response.statusCode = 404;
			REQUEST.response.message = "Article Not Found";
		} else {
			var _tags = [];
			for (var _tag in _article.getTags()) {
				arrayAppend(_tags, {
					id = _tag.getId(),
					name = _tag.getName()
				});
			}

			var response = {
				id = _article.getId(),
				title = _article.getTitle(),
				summary = _article.getSummary(),
				body = _article.getBody(),
				pubDate = _article.getPublicationDate(),
				tags = _tags
			};

			REQUEST.response.data = response;
			REQUEST.response.headers = {
			};
		}
	} // close get_list
} // close component
