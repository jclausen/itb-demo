<%
if(typeof(classification) === 'undefined') var classification = 'dealer';
if(typeof(title) === 'undefined') var title = classification.toProperCase() + ' Information';
%>
<div class="<%=classification%>-detail" data-<%=classification.toLowerCase()%>-id="<%=dealer.id%>">
	<h4><%=title%></h4>
	<div class="dealer-address address">
	<strong><%=dealer.name%></strong><br>
	<span class="address-street"><%= dealer.address1 %></span><%= dealer.address2.length > 0 ? '<br><span class="address-street2">' + dealer.address2 +'</span>' : '' %><br>
	<span class="address-city"><%= dealer.city %></span>, <span class="address-state"><%= dealer.state %></span>&nbsp;&nbsp;<span class="address-zip"><%= dealer.zip %></span><br>
	<% if(dealer.email.length > 0){ %>
	<br>
	<strong>Email:</strong> <a href="mailto:<%= dealer.email %>"><%= dealer.email %></a>
	<% } %>
	<% if(!isNaN(parseInt(dealer.phone)) || dealer.phone.length > 0){ %>
	<br>
	<strong>Phone:</strong> <a href="tel:<%= dealer.phone %>"><%= dealer.phone %></a>
	<% } %>
	<% if(!isNaN(parseInt(dealer.altphone)) || dealer.altphone.length > 0){ %>
	<strong>Alt Phone:</strong> <a href="tel:<%= dealer.altphone %>"><%= dealer.altphone %></a>
	<% } %>	
	</div>
</div>