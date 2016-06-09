<%
 if(typeof(window.currentUser) !== 'undefined'){
    var roleThreshold = window.currentUser.role.sortorder;
 } else {
    var roleThreshold = 1;
 }
%>
<form name="user-edit-form" class="user-edit" data-user-id="<%= user.id %>" action="javascript:void(0)">
    <fieldset>
        <legend>Contact Information</legend>
            <div class="col-md-12 field-box">
                <label>First Name:</label>
                <input class="form-control" name="FirstName" type="text" value="<%=user.firstname%>" />
            </div>

            <div class="col-md-12 field-box">
                <label>Last Name:</label>
                <input class="form-control" name="LastName" type="text" value="<%=user.lastname%>" />
            </div>

            <div class="col-md-12 field-box">
                <label>Company:</label>
                <input class="form-control" name="Company" type="text" value="<%=user.company%>" />
            </div>

            <div class="col-md-12 field-box">
                <label>Title:</label>
                <input class="form-control" name="Title" type="text" value="<%=user.title%>" />
            </div>

            <div class="col-md-12 field-box">
                <label>Phone:</label>
                <input class="form-control" name="Phone" type="text" value="<%=user.phone%>" />
            </div>

            <div class="col-md-12 field-box">
                <label>Skype:</label>
                <input class="form-control" name="Skype" type="text" value="<%=user.skype%>" />
            </div>
    </fieldset>

    <fieldset>
        <legend>Login/Permissions</legend>
        <div class="roles col-md-12 field-box">
            <label>System Role:</label>
            <select name="Role" class="form-control">
                <% 
                for(var i in window.roles) { 
                    var role = window.roles[i];
                    if(role.sortorder >= roleThreshold && role.sortorder < 4){
                %>
                    <option value="<%=role.id%>" <%= user.role.id === role.id ? 'selected' : '' %>><%=role.name%></option>
                <% 
                    }
                  } 
                %>
            </select>
        </div>

        <div class="col-md-12 field-box">
            <label>Email:</label>
            <input class="form-control" name="Email" type="text" value="<%=user.email%>"/>
        </div>

        <label>Change Password:</label>

        <% if(typeof(user.id) !== 'undefined') { %>
            <div class="col-md-12 field-box">
                <label>Current Password:</label>
                <input class="form-control" name="CurrentPassword" type="password"/>
            </div>
        <% } %>

        <div class="col-md-12 field-box">
            <label><%= typeof(user.id) !== 'undefined' ? 'New ' : '' %>Password:</label>
            <input class="form-control" name="NewPassword" type="password"/>
        </div>

        <div class="col-md-12 field-box">
            <label>Verify Password:</label>
            <input class="form-control" name="VerifyPassword" type="password"/>
        </div>
    </fieldset>

    <% if(typeof(user.id) !== 'undefined' && user.id !== window.currentUser.id && window.currentUser.role.name.indexOf("Administrator") > -1) { %>
        <fieldset align="center" style="padding-top:30px;">
            <button id="deleteUser" class="btn-flat danger"><i class="icon icon-trash"></i> Delete User</button>
        </fieldset>
    <% } %>

</form>
