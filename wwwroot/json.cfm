<cfscript>
	param name='REQUEST.response' default=structNew();
	param name='REQUEST.pretty' default=true;

	apiService = new services.apiService();
	json = apiService.parseToJSON(data=REQUEST.response, pretty=REQUEST.pretty);

</cfscript>
<cfcontent reset="true" type="text/plain"><cfoutput>#json#</cfoutput>