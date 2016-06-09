<%
	if(typeof(classification) === 'undefined'){
		classification='Dealer';
	}
%>
<form action="javascript:void(0)" name="dealer-edit-form" class="dealer-edit-form form-condensed" id="<%=classification.toLowerCase()%>-information">

	<div class="req form-group field-box">
		<label for="Name">
			Company / Name
		</label>
		<input type="text" name="Name" value="<%=dealer.name%>" data-required="true" id="<%=classification%>_Name" class="form-control inline-input">		
	</div>


	<!-- begin address block -->
	<div class="address-block">

		<div class="req form-group field-box street">
			<label for="Address1">
				Address 1
			</label>
			<input type="text" name="Address1" value="<%=dealer.address1%>" data-required="true" id="<%=classification%>_Address1" class="form-control inline-input">			
		</div>


		<div class="form-group field-box street">
			<label for="Address2">
				Address 2
			</label>
			<input type="text" name="Address2" value="<%=dealer.address2%>" id="<%=classification%>_Address2" class="form-control inline-input">			
		</div>


		<div class="req form-group field-box city">
			<label for="City">
				City
			</label>
			<input type="text" name="City" value="<%=dealer.city%>" data-required="true" id="<%=classification%>_City" class="form-control inline-input">		
		</div>


		<div class="req form-group field-box state">
			<label for="State">
				State
			</label>
			<select name="State" data-required="true" id="<%=classification%>_State" class="form-control">
				<% for(var i in states){ %>
					<option value="<%= states[i].abbr %>"<%=(dealer.state === states[i].abbr) ? ' selected': '' %>><%= states[i].abbr %></option>
				<% } %>
			</select>			
		</div>

		<div class="form-group field-box zip">
			<label for="Zip">
				Zip
			</label>
			<input type="text" name="Zip" value="<%=dealer.zip%>" id="<%=classification%>_Zip" class="form-control inline-input">
		</div>

	</div>


	<div class="req form-group field-box">
		<label for="Country">
			Country
		</label>
		<select name="Country" data-required="true" id="<%=classification%>_Country" class="form-control">
			<option value="United States"<%=(dealer.country === 'United States') ? ' selected': '' %>>United States</option>
			<option value="Canada"<%=(dealer.country === 'Canada') ? ' selected': '' %>>Canada</option>
		</select>			
	</div>


	<div class="form-group field-box">
		<label for="Phone">
			Phone
		</label>
		<input type="text" name="Phone" value="<%=dealer.phone%>" id="<%=classification%>_Phone" class="form-control inline-input">			
	</div>


	<div class="form-group field-box">
		<label for="Email">
			Email
		</label>
		<input type="text" name="Email" value="<%=dealer.email%>" id="<%=classification%>_Email" class="form-control inline-input">			
	</div>
			
</form>