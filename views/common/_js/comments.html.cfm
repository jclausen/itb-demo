<%
 var timestamp = (typeof(created) !== 'undefined')? new Date(created).toLocaleString() : 'Just now';
 if(versions.length > 0){
 	timestamp = new Date(versions[0].archived).toLocaleString()
 }
%>
<article data-commentid="<%= (typeof(id) !== 'undefined')? id:'new' %>" class="comment-block panel">
	<div class="panel-heading">
		<span class="commentBy"><%= user.firstname + ' ' +user.lastname %> says, </span>
	</div>
	<div class="panel-body">
		<blockquote>
			<%= content %>
		</blockquote>
		<% if($('section#survey.employee-view').length === 0){ %>
		<small class="comment-edit-controls pull-left">
			<i class="icon icon-pencil text-info" data-toggle="tooltip" title="Edit comment"></i> 
			<i class="icon icon-trash-o text-muted" data-toggle="tooltip" title="Delete comment"></i>
		</small>
		<% } %>
		<small class="commentDate pull-right"><%= timestamp %></small>
	</div>
</article>