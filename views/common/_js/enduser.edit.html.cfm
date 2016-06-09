<form action="javascript:void(0)" name="enduser-edit-form" class="enduser-edit-form" id="enduser-information">
	
	
	<div class="req form-group field-box">
		<label for="firstName">
			First Name
		</label>
		<input type="text" name="FirstName" value="<%=enduser.firstname%>" data-required="true" id="FirstName" class="form-control inline-input">			
	</div>


	<div class="req form-group field-box">
		<label for="lastName">
			Last Name
		</label>
		<input type="text" name="LastName" value="<%=enduser.lastname%>" data-required="true" id="LastName" class="form-control inline-input">			
	</div>

	<!-- begin address block -->
	<div class="address-block">

		<div class="req form-group field-box street">
			<label for="Address1">
				Address 1
			</label>
			<input type="text" name="Address1" value="<%=enduser.address1%>" data-required="true" id="Address1" class="form-control inline-input">			
		</div>


		<div class="form-group field-box street">
			<label for="Address2">
				Address 2
			</label>
			<input type="text" name="Address2" value="<%=enduser.address2%>" id="Address2" class="form-control inline-input">			
		</div>


		<div class="req form-group field-box city">
			<label for="City">
				City
			</label>
			<input type="text" name="City" value="<%=enduser.city%>" data-required="true" id="City" class="form-control inline-input">		
		</div>
		
		<div class="req form-group field-box state">
			<label for="State">
				State
			</label>
			<select name="State" data-required="true" id="State" class="form-control">
				<% for(var i in states){ %>
					<option value="<%= states[i].abbr %>"<%=(enduser.state === states[i].abbr) ? ' selected': '' %>><%= states[i].abbr %></option>
				<% } %>
			</select>			
		</div>

		<div class="req form-group field-box zip">
		<label for="Zip">
			Zip
		</label>
		<input type="text" name="Zip" value="<%=enduser.zip%>" data-required="true" id="Zip" class="form-control inline-input">
		</div>

	</div>
	<div class="clearfix"></div>
	<!-- end address block -->
	<div class="req form-group field-box">
		<label for="Country">
			Country
		</label>
		<select name="Country" data-required="true" id="Country" class="form-control">
			<option value="United States"<%=(enduser.country === 'United States') ? ' selected': '' %>>United States</option>
			<option value="Canada"<%=(enduser.country === 'Canada') ? ' selected': '' %>>Canada</option>
		</select>			
	</div>

	<div class="form-group field-box">
	<label for="Email">
		Email Address
	</label>
	<input type="text" name="Email" value="<%=enduser.email%>" id="Email" class="form-control inline-input">			
	</div>


	<div class="form-group field-box">
	<label for="Phone">
		Primary Phone
	</label>
	<input type="text" name="Phone" value="<%=enduser.phone%>" id="Phone" class="form-control inline-input">			
	</div>


	<div class="form-group field-box">
	<label for="AltPhone">
		Alternate Phone
	</label>
	<input type="text" name="AltPhone" value="<%=enduser.altphone%>" id="AltPhone" class="form-control inline-input">			
	</div>

</form>