<cfscript>
	var AppSettings = args.AppSettings;
	var Registration = args.Registration;
	var ProductItem = Registration.getItem();
	var Product = ProductItem.getProduct();
	var EndUser = ProductItem.getEndUser();
	var Dealer = ProductItem.getDealer();
	var RegistrationAnswers = deserializeJSON(Registration.getAnswers());
</cfscript>
<cfoutput>
<p>A new product registration has been received by the <a href="#AppSettings.base_url#">#AppSettings.tennantCompanyName# Suretix</a> system.</p>
<p>Please <a href="#AppSettings.base_url#">log in to the admin console</a> to make changes or view the full details of this registration</p>
<h3>Registration Summary</h3>
<table style="border: none;font-size: 12px" cellspacing="none" border="0">
	<thead>
		<tr>
			<th align="left" style="width:250px;font-size: 14px;color: ##696969">
				Customer Information:
				<br>
			</th>
			<th align="left" style="width:250px;font-size: 14px;color: ##696969">
				Dealer Information:
				<br>
			</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td style="width:250px">
				<strong>#EndUser.getFirstName()# #EndUser.getLastName()#</strong><br>
				#EndUser.getAddress1()#<br><cfif len(EndUser.getAddress2())>#EndUser.getAddress2()#<br></cfif>
				#EndUser.getCity()#, #EndUser.getState()#&nbsp;&nbsp;#EndUser.getZip()#<br>
				#EndUser.getCountry()#<br><br>

				<cfif len(EndUser.getPhone())>
					Phone: <a href="tel:#EndUser.getPhone()#">#EndUser.getPhone()#</a><br>
				</cfif>		

				<cfif len(EndUser.getAltPhone())>
					Alt. Phone: <a href="tel:#EndUser.getAltPhone()#">#EndUser.getAltPhone()#</a><br>
				</cfif>
				<cfif len(EndUser.getEmail())>
					Email: <a href="mailto:#EndUser.getEmail()#">#EndUser.getEmail()#</a><br>
				</cfif>

			</td>

			<td style="width:250px">
				
				<strong>#Dealer.getName()#</strong><br>
				#Dealer.getAddress1()#<br><cfif len(Dealer.getAddress2())>#Dealer.getAddress2()#<br></cfif>
				#Dealer.getCity()#, #Dealer.getState()#&nbsp;&nbsp;#Dealer.getZip()#<br>
				#Dealer.getCountry()#<br><br>

				<cfif len(Dealer.getPhone())>
					Phone: <a href="tel:#Dealer.getPhone()#">#Dealer.getPhone()#</a><br>
				</cfif>		

				<cfif len(Dealer.getAltPhone())>
					Alt. Phone: <a href="tel:#Dealer.getAltPhone()#">#Dealer.getAltPhone()#</a><br>
				</cfif>
				<cfif len(Dealer.getEmail())>
					Email: <a href="mailto:#Dealer.getEmail()#">#Dealer.getEmail()#</a><br>
				</cfif>

			</td>

		</tr>

		<tr>
			<th align="left" colspan="2" style="font-size: 14px;color: ##696969">
				<br>
				<hr>
				Product Information:
				<br>
			</th>
		</tr>

		<tr>
			<td colspan="2">
				<strong>Product Name:<br></strong> #Product.getName()#<br>
				<strong>Model Number:<br></strong> #Product.getModelNumber()#<br>
				<strong>Serial Number:<br></strong> #ProductItem.getSerialNumber()#<br>
				<strong>Installation Date:<br></strong> #dateFormat(ProductItem.getInstallDate(),'long')#<br>
			</td>
		</tr>

		<tr>
			<th align="left" colspan="2" style="font-size: 14px;color: ##696969">
				<br>
				<hr>
				Registration Question Responses:
				<br>
			</th>
		</tr>
		<tr>

			<td colspan="2">
				<cfloop array="#RegistrationAnswers#" index="Answer">
					<strong>#Answer.question#:</strong><br><em>#Answer.response#</em><br><br>
				</cfloop>
			</td>
		</tr>
	</tbody>

</table>

</cfoutput>