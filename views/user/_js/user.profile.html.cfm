<div class="row header<%=window.profileIsEditable?' editable':''%>" data-user-id="<%=user.id%>">
    <div class="col-md-8">
        <div class="media">
            <div class="media-left">
                <img src="<%=user.gravatar%>&s=100" alt="contact" class="avatar img-circle">
            </div>
            <div class="media-right">
                <h3 class="name"><%=user.firstname%> <%=user.lastname%></h3><br>
                <h4 class="area"><%=user.company%></h4>
            </div>
        </div>
    </div>


    <% if(window.profileIsEditable) { %>
        <% if(window.profileMayDelete) { %>
            <a class="btn-flat icon pull-right delete-user" data-toggle="tooltip" title="" data-placement="top" data-original-title="Delete user">
                <i class="icon-trash"></i>
            </a>
        <% } %>
         <a class="btn-flat primary large pull-left edit-user save-editable">
            <i class="icon-pencil"></i> Edit
        </a>
    <% } %>
</div>
<div class="profile-box">

    <div class="col-md-12 section">
        <h6><strong>Job Title:</strong> <%=user.title%></h6>
        
        <h6><strong>Suretix System Role:</strong> <%=user.role.name%></h6>
        <br>

        <h6>Contacts:</h6>
        <p><strong><i class="icon-envelope"></i> Email:</strong> <a href="mailto:<%=user.email%>"><%=user.email%></a></p>
        <p><strong><i class="icon-phone"></i> Phone:</strong> <a href="tel:<%=user.phone%>"><%=user.phone.length?user.phone:'Not Available'%></a></p>
        <% if(user.skype.length) { %>
            <p><strong><i class="icon-skype"></i> Skype:</strong> <a href="skype:<%=user.skype%>"><%=user.skype.length?user.skype:'Not Available'%></a></p>
        <% } %>
    </div>
</div>