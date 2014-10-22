<cfscript>
	LOCAL.dir = DirectoryList(RC.controllerPath,false,"name","*.cfc");
</cfscript>
<cfoutput>
	<section class='panel panel-default'>
		<div class="panel-heading text-capitalize">
			<h3 class="panel-title">Items</h3>
		</div>
		<ul class="list-group">
			<cfloop array="#LOCAL.dir#" index="LOCAL.filePath">
				<cfscript>
					LOCAL.fileName = replaceNoCase(LOCAL.filePath,".cfc","","one");
					if ((structKeyExists(RC, "controllerName")) && (RC.controllerName == LOCAL.fileName)) {
						LOCAL.isThisActive = true;
					} else {
						LOCAL.isThisActive = false;
					}
				</cfscript>
				<li class="list-group-item text-capitalize#((LOCAL.isThisActive)?" active":"")#">
					<cfif LOCAL.isThisActive>
						#LOCAL.fileName#
					<cfelse>
						<a href='/docs/#LOCAL.fileName#'>#LOCAL.fileName#</a>
					</cfif>
				</li>
			</cfloop>
		</ul>
	</section>
</cfoutput>