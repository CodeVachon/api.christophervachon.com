<cfscript>
	LOCAL.controller = createObject( 'component', "controllers." & RC.controllerName).init();

	LOCAL.controllerFunctions = GetMetaData(LOCAL.controller).functions;
	LOCAL.controllerMethods = {};
	for (i=1; i <= arrayLen(LOCAL.controllerFunctions); i++) {
		if (
			(LOCAL.controllerFunctions[i].access == "public") &&
			(arrayFind(["init","before","after"], LOCAL.controllerFunctions[i].name) == 0) 
		) {
			LOCAL.controllerMethods[LOCAL.controllerFunctions[i].name] = LOCAL.controllerFunctions[i];
		}
	}

	LOCAL.keysSorted = structKeyArray(LOCAL.controllerMethods);
	arraySort(LOCAL.keysSorted, "textnocase", "asc");

	LOCAL.mdService = new services.markdownService();

	if (fileExists(expandPath("markdown/#RC.controllerName#/info.md"))) {
		LOCAL.header = LOCAL.mdService.convertToHtml(  fileRead(expandPath("markdown/#RC.controllerName#/info.md"))  );
		LOCAL.header &= "<hr />";
	} else {
		LOCAL.header = "<h2 class='text-capitalize'>#RC.controllerName#</h2>";
	}

</cfscript>
<cfoutput>

	#LOCAL.header#

	<cfloop array="#LOCAL.keysSorted#" index="LOCAL.key">
		<section class='panel panel-info' id="#LOCAL.key#">
			<div class="panel-heading text-capitalize">
				<h3 class="panel-title">#((structKeyExists(LOCAL.controllerMethods[LOCAL.key], "method"))?LOCAL.controllerMethods[LOCAL.key].method:LOCAL.key)#</h3>
			</div>
			<div class="panel-body">
				<dl class="dl-horizontal">
					<cfloop list="access,action,description,hint,use" index="LOCAL.thisKey">
						<cfif structKeyExists(LOCAL.controllerMethods[LOCAL.key], LOCAL.thisKey)>
							<dt class="text-capitalize">#LOCAL.thisKey#</dt>
							<dd>#LOCAL.controllerMethods[LOCAL.key][LOCAL.thisKey]#</dd>
						</cfif>
					</cfloop>
				</dl>

				<cfscript>
					LOCAL.additionalContent = "";
					if (fileExists(expandPath("markdown/#RC.controllerName#/#LOCAL.key#.md"))) {
						LOCAL.additionalContent = LOCAL.mdService.convertToHtml(  fileRead(expandPath("markdown/#RC.controllerName#/#LOCAL.key#.md"))  );
						writeOutput("<hr>");
					}
					writeOutput(LOCAL.additionalContent);
				</cfscript>
			</div>
		</section>
	</cfloop>
</cfoutput>