<cfoutput>

    <!-- morris bar & donut charts -->
    <div class="row section">
        <div class="col-md-12">
            <h4 class="title">Welcome to Suretix at #getSetting('tennantCompanyName')#</h4>
        </div>
        <div class="col-md-5 chart">
            <h5>Activity: Last 30 Days</h5>
            <div id="activity-counts" style="height: 250px;">#renderView("common/loaderCircle")#</div>    
        </div>
        <div class="col-md-6 chart">
            <h5>Product Comparison: Rolling 365 Days</h5>
            <div id="product-comparison-chart" style="height: 250px;">#renderView("common/loaderCircle")#</div>
        </div>
    </div>

    <div class="row section">
    <h4>Recent Registrations</h4>
    <div id="registrations-data">
        #renderView(view="common/commonLoader",args={"msg":"Loading Recent Registrations..."})#
    </div>

    <script type="text/template" id="registrations-table-content">
        #renderView('registration/_js/registrationsTable.html')#
    </script>
    <script type="text/template" id="registrations-table-datarow">
        #renderView('registration/_js/registrationRow.html')#
    </script>
    <script type="text/template" id="pagination-template">
        #renderView('common/_js/pagination.html')#
    </script>
    </div>


    <div class="row section">
    <h4>Recent Claims</h4>
    <div id="claims-data">
        #renderView(view="common/commonLoader",args={"msg":"Loading Recent Claims..."})#
    </div>

    <script type="text/template" id="claims-table-content">
        #renderView('claim/_js/claimsTable.html')#
    </script>
    <script type="text/template" id="claims-table-datarow">
        #renderView('claim/_js/claimRow.html')#
    </script>
    <script type="text/template" id="pagination-template">
        #renderView('common/_js/pagination.html')#
    </script>
    </div>

    <!-- morris stacked chart -->
    <div class="row hide">
        <div class="col-md-12">
            <h4 class="title">Morris.js stacked</h4>
        </div>
        <div class="col-md-12">
            <h5>Quarterly Apple iOS device unit sales</h5>
            <br>
            <div id="hero-area" style="height: 250px;"></div>
        </div>
    </div>



    <!-- morris graph chart -->
    <div class="row section hide">
        <div class="col-md-12">
            <h4 class="title">Morris.js <small>Monthly growth</small></h4>
        </div>
        <div class="col-md-12 chart">                        
            <div id="hero-graph" style="height: 230px;"></div>
        </div>
    </div>

</cfoutput>


