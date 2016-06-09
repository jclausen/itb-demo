<script type="text/javascript">
	window.STX_TOKEN='d584edea-766f-11e5-9118-b0d20dc6bd60';
	window.STX_HTTP_SERVER='';
</script>
<section id="suretix-Claim">
	<div class="col-xs-12 fuelux">
		<h2><cfoutput>#getSetting("tennantCompanyName")#</cfoutput> Warranty Claim Form</h2>
		<form id="stx-reg-form" class="wizard" action="javascript:void(0)">
			<ul class="wizard-steps steps" style="margin-top: 75px">
                <li data-target="#step1" class="active">
                    <span class="step">1</span>
                    <span class="title">Product <br> information</span>
                </li>
                <li data-target="#step2">
                    <span class="step">2</span>
                    <span class="title">Servicer <br> information</span>
                </li>
                <li data-target="#step3">
                    <span class="step">3</span>
                    <span class="title">End User <br> information</span>
                </li>

                <li data-target="#step4">
                    <span class="step">4</span>
                    <span class="title">Claim Submission<br> complete</span>
                </li>
            </ul>
        	<div class="clearfix"></div>
        	<div class="col-xs-12 col-sm-10 col-sm-offset-1">
				<span class="pull-right"><i class="fa fa-asterisk req-indicator"></i> Required Fields</p>	
            </div>
			<div class="step-content col-xs-12 col-sm-10 col-sm-offset-1">
				<div class="step-pane active" id="step1" data-content-id="claim-product">
					<div class="pane-title">
						
						<p>Claims must be filed within 30 days from date of service.</p>

						<p><em>If requesting a warranty claim on multiple products, please submit a separate claim form for each product.</em></p>
						
						<p>Please enter your product information.</p>
					</div>
					<div class="clearfix"></div>
					<div class="pane-content"><div class="col-xs-12 text-muted" align="center"><i class="text-muted icon icon-spin icon-spinner icon-5x"></i></div></div>
				</div>

				<div class="step-pane" id="step2" data-content-id="claim-servicer">
					<div class="pane-content"><div class="col-xs-12 text-muted" align="center"><i class="text-muted icon icon-spin icon-spinner icon-5x"></i></div></div>
				</div>

				<div class="step-pane" id="step3" data-content-id="claim-customer">
					<div class="pane-content"><div class="col-xs-12 text-muted" align="center"><i class="text-muted icon icon-spin icon-spinner icon-5x"></i></div></div>
				</div>

				<div class="step-pane claim-confirmation" id="step4" data-restrict="previous">
					<div class="pane-content"><div class="col-xs-12 text-muted" align="center"><i class="text-muted icon icon-spin icon-spinner icon-5x"></i></div></div>

				</div>

			</div>	
			
		
			<label style="display:none">Please omit this field <input type="text" name="xsAdditionalInfo" value=""/></label>
			
			<div class="actions submits centered" style="padding-bottom:50px;">
				<button id="btnReverseClaim" class="btn btn-default btn-lg btn-flat inverse previous hide" disabled>&nbsp;&nbsp;&nbsp;<i class="fa fa-angle-double-left"></i> Back&nbsp;&nbsp;&nbsp;</button>
				<button id="btnAdvanceClaim" class="btn btn-default btn-lg btn-flat success advance" disabled>&nbsp;&nbsp;&nbsp;Next <i class="fa fa-angle-double-right"></i>&nbsp;&nbsp;&nbsp;</button>
			</div>
		</form>
	</div>
</section>
<cfoutput>
<!-- Templates -->
<script type="text/template" id="claim-product">
<cfinclude template='form/claim_product.html'>
</script>
<script type="text/template" id="claim-customer">
<cfinclude template='form/enduser.html'>
</script>
<script type="text/template" id="claim-servicer">
<cfinclude template='form/dealer.html'>
<cfinclude template='form/questions.html'>
</script>
<script type="text/template" id="claim-confirmation">
<cfinclude template='form/claim_confirmation.html'>
</script>
<script type="text/template" id="api-error">
<cfinclude template='form/api_error_response.html'>
</script>
<!-- Question Answer Templates -->
<cfinclude template="form/question_answers.html">
</cfoutput>