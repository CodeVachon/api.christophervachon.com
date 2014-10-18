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
		var response = [];
		for (var _article in articleList) {

			var _tags = [];
			for (var _tag in _article.getTags()) {
				arrayAppend(_tags, {
					id = _tag.getId(),
					name = _tag.getName()
				});
			}

			arrayAppend(response, {
				id = _article.getId(),
				title = _article.getTitle(),
				summary = _article.getSummary(),
				pubDate = _article.getPublicationDate(),
				tags = _tags
			});
		}

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
				pubDate = _article.getPublicationDate(),
				tags = _tags
			};

			REQUEST.response.data = response;
			REQUEST.response.headers = {
			};
		}
	} // close get_list
} // close component
