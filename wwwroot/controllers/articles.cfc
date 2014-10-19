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
				if (_property == "tags") {
					var _tags = [];
					for (var _tag in _article.getTags()) {
						arrayAppend(_tags, {
							id = _tag.getId(),
							name = _tag.getName()
						});
					}
					_articleData[_property] = _tags;
				} else {
					if (_article.hasProperty(_property)) {
						_articleData[_property] = _article.getProperty(_property);
					}
				}
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
