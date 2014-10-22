<cfscript>
	LOCAL.mdService = new services.markdownService();

	writeOutput(LOCAL.mdService.convertToHtml("## Header Tag"));
</cfscript>