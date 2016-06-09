<cfscript>
	var AppSettings = args.AppSettings;
	var EndUser = args.EndUser;
</cfscript>
<cfoutput>
<p>Dear #EndUser.getFirstName()#,<br></p>
<p>Thank you for registering your Suretix product. We have received your registration information.</p>
<p>We trust that you will enjoy the energy-efficient and environmentally friendly features of your Suretix product for years to come.</p>
<p>Suretix is committed to designing and developing innovative products that enhance comfort. Our goal is to maximize energy efficiency and minimize environmental impact both in our products and in our manufacturing processes and facilities. If you’d like to learn more about Suretix’s innovative technology and company values please visit our <a href="#getSetting("tennantBaseURL")#">website</a>.</p>
<p>If you ever do need technical support for your product please contact our Customer Care department at <cfoutput>#getSetting("tennantSupportPhone")#</cfoutput>.</p>
<p>Suretix products are built to the highest quality standards and we trust you will enjoy years of trouble-free service.</p>
<p>In the unlikely instance that you need to make a warranty claim, please complete our <a href="/warrantly-claim/">Warranty Claim Form</a>.</p>

</cfoutput>