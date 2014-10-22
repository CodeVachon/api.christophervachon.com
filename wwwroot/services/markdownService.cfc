/**
*
* @file  /Users/Christopher/Documents/sites/api.christophervachon.com/wwwroot/docs/services/markdownService.cfc
* @author  
* @description More info on PegDown: http://www.decodified.com/pegdown/api/
*
*/

component output="false" displayname=""  {

	VARIABLES.javaLoader = javaCast("null","");
	VARIABLES.markdownProcessor = javaCast("null","");

	public function init(){
		var paths = [
			"#expandPath('bin/parboiled-java-1.1.5.jar')#",
			"#expandPath('bin/asm-all-4.0.jar')#",
			"#expandPath('bin/parboiled-core-1.1.5.jar')#",
			"#expandPath('bin/pegdown-1.4.2.jar')#"
		];

		VARIABLES.javaloader = createObject("component", "javaloader.JavaLoader").init(paths, false);
		VARIABLES.markdownProcessor = VARIABLES.javaloader.create("org.pegdown.PegDownProcessor").init(javaCast("int", 65535));

		return this;
	}

	public string function convertToHtml(required string markdown) {
		var _html = this.getPegDown().markdownToHtml(ARGUMENTS.markdown);
		_html = replaceNoCase(_html,"<table>","<table class='table table-bordered'>","all");
		return _html;
	}

	public any function getJavaLoader() {
		return VARIABLES.javaloader;
	}

	public any function getPegDown() {
		return VARIABLES.markdownProcessor;
	}
}