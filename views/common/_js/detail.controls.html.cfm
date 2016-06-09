<cfscript>
	param name="entityName" default="Claim";
</cfscript>
<cfoutput>
<div id="detail-controls" class="btn-group pull-right">
    <button class="glow left primary large comment-add" data-toggle="tooltip" title="Add Notes to this #entityName#"><i class="icon icon-comment"></i></button>
    <button class="glow right large gray print-page" data-toggle="tooltip" title="Print this #entityName#"><i class="icon icon-print"></i></button>
</div>
</cfoutput>