<cfoutput>
<h1>Export Registration Data</h1>
<div class="row form-wrapper">
	<form name="registrationExport" class="" action="" method="POST">
		<div class="col-md-7 col-sm-6 col-xs-12 margin-bottom-50">
			<fieldset>
                <hr>
				<div class="field-box form-group col-xs-6">
                    <label>Start Date</a></label>
                    <input type="text" placeholder="mm/dd/yyyy" class="form-control datepicker" name="startDate">                       
                </div>

                <div class="field-box form-group col-xs-6">
                    <label>End Date</a></label>
                    <input type="text" placeholder="mm/dd/yyyy" class="form-control datepicker" name="endDate">                       
                </div>
			</fieldset>
            <fieldset class="text-center">
                <button name="submitExport" class="btn-flat default"><i class="icon icon-download"></i> Process Export</button>
            </fieldset>
		</div>
        <div class="clearfix"></div>
	</form>
</div>
</cfoutput>