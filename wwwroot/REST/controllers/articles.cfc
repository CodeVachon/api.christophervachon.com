/**
*
* @file  /REST/controllers/articles.cfc
* @author  
* @description
*
*/

component output="false" displayname=""  {

	VARIABLES.apiService = javaCast("null","");
	VARIABLES.articleService = javaCast("null","");

	public function init() {
		this.apiService = new REST.services.apiService();
		this.articleService = new REST.services.articleService();
		return this;
	} // close init

	/**
	* @method 	List
	* @action 	Get
	* @hint 	Lists out articles
	* @use 		/REST/articles/
	*/
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

		REQUEST.response.data = this.apiService.formatResponse(articleList, _properties);
		REQUEST.response.headers = {
			"X-Total-Count" = 100,
			"X-Page" = _serArgs.page
		};
	} // close get_list


	/**
	* @method 	View
	* @action 	Get
	* @hint 	Gets Details of a Specific Article.  I wonder what happens if I need to use a new line
	* @use 		/REST/articles/[articleId]
	*/
	public function get_view(args) {
		var _serArgs = {
			articleId = args.objectId
		};

		var _article = this.articleService.getArticle(_serArgs);

		if (isNull(_article)) {
			REQUEST.response.statusCode = 404;
			REQUEST.response.message = "Article Not Found";
		} else {

			if (structKeyExists(args,"fields")) {
				_properties = listToArray(args.fields,",");
			} else {
				_properties = ["id","title","summary","body","publicationDate","tags"];
			}

			REQUEST.response.data = this.apiService.formatResponse(_article, _properties);;
			REQUEST.response.headers = {};
		}
	} // close get_list
} // close component
