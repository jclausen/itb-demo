<%
if(typeof(title) === 'undefined') title = 'End User Information';
%>
<div class="end-user-detail" data-enduser-id="<%=enduser.id%>">
	<h4><%=title%></h4>
	<div class="enduser-address address">
	<strong><%=enduser.firstname + ' ' + enduser.lastname%></strong><br>
	<span class="address-street"><%= enduser.address1 %></span><%= enduser.address2.length > 0 ? '<br><span class="address-street2">' + enduser.address2 +'</span>' : '' %><br>
	<span class="address-city"><%= enduser.city %></span>, <span class="address-state"><%= enduser.state %></span>&nbsp;&nbsp;<span class="address-zip"><%= enduser.zip %></span><br>
	<% if(enduser.email.length > 0){ %>
	<br>
	<strong>Email:</strong> <a href="mailto:<%= enduser.email %>"><%= enduser.email %></a>
	<% } %>
	<% if(!isNaN(parseInt(enduser.phone)) || enduser.phone.length > 0){ %>
	<br>
	<strong>Phone:</strong> <a href="tel:<%= enduser.phone %>"><%= enduser.phone %></a>
	<% } %>
	<% if(!isNaN(parseInt(enduser.altphone)) || enduser.altphone.length > 0){ %>
	<br>
	<strong>Alt Phone:</strong> <a href="tel:<%= enduser.altphone %>"><%= enduser.altphone %></a>
	<% } %>
	</div>
</div>