<div class="dataTables_wrapper">

    <!--- <div class="dataTables_filter" id="inventory_filter">
        <i class="icon icon-undo text-muted" data-toggle="tooltip" title="Reset the inventory table to its defaults"></i>
        <label>
            Search: 
            <input type="text" aria-controls="inventory-tables"> 
        </label>
    </div> --->
    <table id="inventory-table" class="table table-hover">
        <thead>
            <tr>
                <th tabindex="0" rowspan="1" colspan="1" class="col-md-2 sorting sortable" data-sort="serialnumber" role="columnheader" aria-controls="inventory-table" aria-label="Browser: activate to sort column ascending">
                    <span class="line"></span>
                    Serial Number
                </th>
                <th tabindex="0" rowspan="1" colspan="1" class="col-md-2 sorting_desc sortable"  data-sort="created" aria-sort="descending" role="columnheader" aria-controls="inventory-table" aria-label="Browser: activate to sort column ascending">
                    <span class="line"></span>
                    Distributor
                </th>
                <th tabindex="0" rowspan="1" colspan="1" class="col-md-2 sorting_desc sortable"  data-sort="Product.ModelNumber" aria-sort="descending" role="columnheader" aria-controls="inventory-table" aria-label="Browser: activate to sort column ascending">
                    <span class="line"></span>
                    Registration
                </th>
                <th tabindex="0" rowspan="1" colspan="1" class="col-md-2 sorting sortable" role="columnheader" data-sort="Customer.LastName" aria-controls="inventory-table" aria-label="Browser: activate to sort column ascending">
                    <span class="line"></span>
                    Claims
                </th>
                <th rowspan="1" colspan="1" class="col-md-1" role="columnheader"><span class="line"></span></th>
            </tr>
        </thead> 
        <tbody class="inventory-list"></tbody>   
    </table>
</div>
