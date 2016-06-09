<cfscript>
	var Claim = args.Claim;
	var ProductItem = Claim.getItem();
	var Product = ProductItem.getProduct();
	var EndUser = Claim.getEndUser();
	var Servicer = Claim.getServicer();
	var RegistrationAnswers = deserializeJSON(Claim.getAnswers());
</cfscript>
<cfoutput>

<h3>Claim Summary</h3>
<table style="border: none;font-size: 12px" cellspacing="none" border="0">
	<thead>
		<tr>
			<th align="left" style="width:250px;font-size: 14px;color: ##696969">
				Servicer Information:
				<br>
			</th>

			<th align="left" style="width:250px;font-size: 14px;color: ##696969">
				End User Information:
				<br>
			</th>

		</tr>
	</thead>
	<tbody>
		<tr>

			<td width="50%" align="left">

				<strong>#Servicer.getName()#</strong><br>
				#Servicer.getAddress1()#<br><cfif len(Servicer.getAddress2())>#Servicer.getAddress2()#<br></cfif>
				#Servicer.getCity()#, #Servicer.getState()#&nbsp;&nbsp;#Servicer.getZip()#<br>
				#Servicer.getCountry()#<br><br>

				<cfif len(Servicer.getPhone())>
					<strong>Phone:</strong><br><a href="tel:#Servicer.getPhone()#">#Servicer.getPhone()#</a><br>
				</cfif>		

				<cfif len(Servicer.getAltPhone())>
					<strong>Alt. Phone:</strong><br><a href="tel:#Servicer.getAltPhone()#">#Servicer.getAltPhone()#</a><br>
				</cfif>

				<cfif len(Servicer.getEmail())>
					<strong>Notification Email:</strong><br><a href="mailto:#Claim.getNotificationEmail()#">#Claim.getNotificationEmail()#</a><br>
				</cfif>

			</td>

			<td width="50%" align="left">

				<strong>#EndUser.getFirstName()# #EndUser.getLastName()#</strong><br>
				#EndUser.getAddress1()#<br><cfif len(EndUser.getAddress2())>#EndUser.getAddress2()#<br></cfif>
				#EndUser.getCity()#, #EndUser.getState()#&nbsp;&nbsp;#EndUser.getZip()#<br>
				#EndUser.getCountry()#<br><br>

				<cfif len(EndUser.getPhone())>
					<strong>Phone:</strong><br><a href="tel:#EndUser.getPhone()#">#EndUser.getPhone()#</a><br>
				</cfif>		

				<cfif len(EndUser.getAltPhone())>
					<strong>Alt. Phone:</strong><br><a href="tel:#EndUser.getAltPhone()#">#EndUser.getAltPhone()#</a><br>
				</cfif>
				<cfif len(EndUser.getEmail())>
					<strong>Email:</strong><br><a href="mailto:#EndUser.getEmail()#">#EndUser.getEmail()#</a><br>
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
			<td colspan="2" align="left">
				<strong>Product Name:<br></strong> #Product.getName()#<br>
				<strong>Model Number:<br></strong> #Product.getModelNumber()#<br>
				<strong>Serial Number:<br></strong> #ProductItem.getSerialNumber()#<br>
				<strong>Installation Date:<br></strong> #dateFormat(ProductItem.getInstallDate(),'long')#<br>
				<strong>Date of Failure:<br></strong> #dateFormat(Claim.getFailureDate(),'long')#<br>
			</td>
		</tr>

		<tr>
			<th align="left" colspan="2" style="font-size: 14px;color: ##696969">
				<br>
				<hr>
				Explanation of Failure:
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