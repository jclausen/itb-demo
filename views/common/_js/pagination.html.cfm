<% if(pages > 1) { %>
<div class="dataTables_paginate paging_full_numbers" id="example_paginate">
    <a tabindex="0" class="first paginate_button paginate_button_disabled" id="example_first">First</a>
    <a tabindex="0" class="previous paginate_button paginate_button_disabled" id="example_previous">Previous</a>
    <span>
        <% for(var i = 1;i <= pages;i++) { %>
        <a tabindex="0" class="<%= i===1 ? 'paginate_active' : 'paginate_button' %>"><%= i %></a>
        <% } %>
    </span>
    <a tabindex="0" class="next paginate_button" id="example_next">Next</a>
    <a tabindex="0" class="last paginate_button" id="example_last">Last</a>
</div>
<% } %>