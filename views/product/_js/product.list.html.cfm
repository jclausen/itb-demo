<div class="dataTables_wrapper">

    <div class="dataTables_filter" id="products_filter">
        <i class="icon icon-undo text-muted" data-toggle="tooltip" title="Reset the products table to its defaults"></i>
        <label>
            Search: 
            <input type="text" aria-controls="products-tables"> 
        </label>
    </div>
    <table id="products-table" class="table table-hover">
        <thead>
            <tr>
                <th tabindex="0" rowspan="1" colspan="1" class="col-md-2 sorting sortable" data-sort="id" role="columnheader" aria-controls="products-table" aria-label="Browser: activate to sort column ascending">
                    <span class="line"></span>
                    Model Number
                </th>
                <th tabindex="0" rowspan="1" colspan="1" class="col-md-2 sorting_desc sortable"  data-sort="created" aria-sort="descending" role="columnheader" aria-controls="products-table" aria-label="Browser: activate to sort column ascending">
                    <span class="line"></span>
                    Name
                </th>
                <th tabindex="0" rowspan="1" colspan="1" class="col-md-2 sorting_desc sortable"  data-sort="Product.ModelNumber" aria-sort="descending" role="columnheader" aria-controls="products-table" aria-label="Browser: activate to sort column ascending">
                    <span class="line"></span>
                    Category
                </th>
                <th tabindex="0" rowspan="1" colspan="1" class="col-md-2 sorting sortable" role="columnheader" data-sort="Customer.LastName" aria-controls="products-table" aria-label="Browser: activate to sort column ascending">
                    <span class="line"></span>
                    Active
                </th>
                <th tabindex="0" rowspan="1" colspan="1" class="col-md-2" aria-controls="products-table" aria-label="Actions">
                    <span class="line"></span>
                    Actions
                </th>
            </tr>
        </thead> 
        <tbody class="products-list"></tbody>   
    </table>
</div>
