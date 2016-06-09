<div class="dataTables_wrapper">


    <!--<div class="btn-group pull-left">
        <button class="results-filter glow middle danger small" data-filter="status" data-filter-value="1">Submitted</button>
        <button class="results-filter glow middle primary small" data-filter="status" data-filter-value="2">Processing</button>
        <button class="results-filter glow middle info small" data-filter="status" data-filter-value="3">Approved</button>
        <button class="results-filter glow right success small" data-filter="status" data-filter-value="4">Complete</button>
    </div>-->
    <div class="dataTables_filter" id="claims_filter">
        <i class="icon icon-undo text-muted" data-toggle="tooltip" title="Reset the claims table to its defaults"></i>
        <label>
            Search: 
            <input type="text" aria-controls="claims-tables"> 
        </label>
    </div>
    <table id="claims-table" class="table table-hover">
        <thead>
            <tr>
                <th tabindex="0" rowspan="1" colspan="1" class="col-md-2 sorting sortable" data-sort="id" role="columnheader" aria-controls="claims-table" aria-label="Browser: activate to sort column ascending">
                    <span class="line"></span>
                    Claim ID
                </th>
                <th tabindex="0" rowspan="1" colspan="1" class="col-md-2 sorting_desc sortable"  data-sort="FailureDate" aria-sort="descending" role="columnheader" aria-controls="claims-table" aria-label="Browser: activate to sort column ascending">
                    <span class="line"></span>
                    Date
                </th>
                <th tabindex="0" rowspan="1" colspan="1" class="col-md-2 sorting sortable" data-sort="Status" role="columnheader" aria-controls="claims-table" aria-label="Browser: activate to sort column ascending">
                    <span class="line"></span>
                    Status
                </th>
                <th tabindex="0" rowspan="1" colspan="1" class="col-md-2 sorting sortable" role="columnheader" data-sort="Customer.LastName" aria-controls="claims-table" aria-label="Browser: activate to sort column ascending">
                    <span class="line"></span>
                    End User
                </th>
                <th tabindex="0" rowspan="1" colspan="1" class="col-md-2 sorting sortable" role="columnheader" data-sort="Servicer.Name" aria-controls="claims-table" aria-label="Browser: activate to sort column ascending">
                    <span class="line"></span>
                    Servicer
                </th>
                <th tabindex="0" rowspan="1" colspan="1" class="col-md-2" aria-controls="claims-table" aria-label="Actions">
                    <span class="line"></span>
                    Claim Actions
                </th>
            </tr>
        </thead> 
        <tbody></tbody>   
    </table>
    <div class="dataTables_info" id="claims_table_info"></div>
</div>
