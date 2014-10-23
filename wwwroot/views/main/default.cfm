<cfscript>
	if (fileExists(expandPath("markdown/home.md"))) {
		writeOutput(APPLICATION.mdParser.convertToHtml(  fileRead(expandPath("markdown/home.md"))  ));
	} else {
		writeOutput("<h2>No Additional Details</h2>");
	}
</cfscript>