<%
var lastlogin = new Date(user.lastlogin).toLocaleString();
if(lastlogin === 'Invalid Date') lastlogin = "Never";
%>
<tr class="first">
    <td>
        <div class="media">
            <div class="media-left">
                <a href="/user/profile/id/<%=user.id%>"><img src="<%=user.gravatar%>&s=60" alt="contact" class="img-circle avatar hidden-phone" data-toggle="tooltip" title="Go to gravatar.com to set your own profile image."></a>
            </div>
            <div class="media-right">
                <a href="/user/profile/id/<%=user.id%>" class="name"><%=user.firstname%> <%=user.lastname%></a><br>
                <span class="subtext"><%=user.title.length?user.title+', ':''%><%=user.company%></span>
            </div>
        </div>
    </td>
    <td style="white-space:nowrap;padding-right: 15px">
        <a href="mailto:<%=user.email%>"><i class="icon icon-envelope"></i> <%=user.email%></a>
    </td>
    <td>
        <a href="tel:<%=user.phone%>" data-toggle="tooltip" title="Click to call <%=user.firstname%> <%=user.lastname%>"><i class="icon icon-phone"></i> <%=user.phone%></a>
        
        <% if(user.skype.length) { %>
        <br>
        <a href="skype:<%=user.skype%>" data-toggle="tooltip" title="Click to call <%=user.firstname%> <%=user.lastname%> via Skype"><i class="icon icon-skype"></i><%=user.skype%></a>
        <% } %>
    </td>
    <td>
        <i class="icon icon-check-circle icon-2x <%=user.loggedin?'text-success':'text-muted'%>"></i>
        <br><span class="subtext"><small>Last Login:</small><br><%=lastlogin%></span>
    </td>
    <td>
        <%= user.role.name %>
    </td>
</tr>