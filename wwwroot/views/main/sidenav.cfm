<cfscript>
	LOCAL.items = [
		{"label"="Home","url"="/","action"="main.default"}
	];
</cfscript>
<cfoutput>
	<section class='panel panel-default'>
		<div class="panel-heading text-capitalize">
			<h3 class="panel-title">Navigation</h3>
		</div>
		<ul class="list-group">
			<cfloop array="#LOCAL.items#" index="LOCAL.thisItem">
				<cfscript>
					if (RC.action == LOCAL.thisItem.action) {
						LOCAL.isThisActive = true;
					} else {
						LOCAL.isThisActive = false;
					}
				</cfscript>
				<li class="list-group-item#((LOCAL.isThisActive)?" active":"")#">
					<cfif LOCAL.isThisActive>
						#LOCAL.thisItem.label#
					<cfelse>
						<a href='/'>#LOCAL.thisItem.label#</a>
					</cfif>
				</li>
			</cfloop>
		</ul>
	</section>
</cfoutput>