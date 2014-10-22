<cfscript>
	if (fileExists(expandPath("markdown/home.md"))) {
		LOCAL.mdService = new services.markdownService();
		writeOutput(LOCAL.mdService.convertToHtml(  fileRead(expandPath("markdown/home.md"))  ));
	} else {
		writeOutput("<h2>No Additional Details</h2>");
	}
</cfscript>