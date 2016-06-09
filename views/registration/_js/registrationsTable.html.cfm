<div class="dataTables_wrapper">

    <div class="dataTables_filter" id="registrations_filter">
        <i class="icon icon-undo text-muted" data-toggle="tooltip" title="Reset the registrations table to its defaults"></i>
        <label>
            Search: 
            <input type="text" aria-controls="registrations-tables"> 
        </label>
    </div>
    <table id="registrations-table" class="table table-hover">
        <thead>
            <tr>
                <th tabindex="0" rowspan="1" colspan="1" class="col-md-2 sorting sortable" data-sort="id" role="columnheader" aria-controls="registrations-table" aria-label="Browser: activate to sort column ascending">
                    <span class="line"></span>
                    Registration ID
                </th>
                <th tabindex="0" rowspan="1" colspan="1" class="col-md-2 sorting_desc sortable"  data-sort="created" aria-sort="descending" role="columnheader" aria-controls="registrations-table" aria-label="Browser: activate to sort column ascending">
                    <span class="line"></span>
                    Date
                </th>
                <th tabindex="0" rowspan="1" colspan="1" class="col-md-2 sorting_desc sortable"  data-sort="Product.ModelNumber" aria-sort="descending" role="columnheader" aria-controls="registrations-table" aria-label="Browser: activate to sort column ascending">
                    <span class="line"></span>
                    Product
                </th>
                <th tabindex="0" rowspan="1" colspan="1" class="col-md-2 sorting sortable" role="columnheader" data-sort="Customer.LastName" aria-controls="registrations-table" aria-label="Browser: activate to sort column ascending">
                    <span class="line"></span>
                    End User
                </th>
                <th tabindex="0" rowspan="1" colspan="1" class="col-md-2 sorting sortable" role="columnheader" data-sort="Dealer.Name" aria-controls="registrations-table" aria-label="Browser: activate to sort column ascending">
                    <span class="line"></span>
                    Dealer
                </th>
                <th tabindex="0" rowspan="1" colspan="1" class="col-md-2" aria-controls="registrations-table" aria-label="Actions">
                    <span class="line"></span>
                    Actions
                </th>
            </tr>
        </thead> 
        <tbody></tbody>   
    </table>
    <div class="dataTables_info" id="registrations_table_info"></div>
</div>
