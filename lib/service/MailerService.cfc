component name="MailerService" accessors=true{
	property name="Mailer" inject="MailService@cbmailservices";
	property name="template" default="_templates/email";
	property name="ViewRenderer" inject="Renderer@coldbox";
	property name="AppSettings" inject="wirebox:properties";

	/**
	* Send an email using the default template
	* A content or view argument must be passed to this method
	* 
	* @param string to
	* @param string from
	* @param string subject			the subject line
	* @param string [content]		the HTML content for the email			 
	* @param string [view]			a view to use as the email content.
	* @param string viewArgs 		a structure of arguments for the view
	**/
	public function send(required string to, required string from='', required string subject, string content, string view, struct viewArgs={}){

		var message = Mailer.newMail(
			to=ARGUMENTS.to,
			from=len(ARGUMENTS.from)?ARGUMENTS.from:AppSettings.mailsettings.from,
			subject=ARGUMENTS.subject
			);

		if(!isNull(ARGUMENTS.content)){
			var messageBody = ViewRenderer.renderView(view=template,args={"AppSettings":AppSettings,"content":ARGUMENTS.content});
		} else {
			var messageBody = ViewRenderer.renderView(
				view=template,
				args={"AppSettings":AppSettings,"content":ViewRenderer.renderView(view=ARGUMENTS.view,args=ARGUMENTS.viewArgs)}
				);
		}

		message.setHTML(messageBody);
		return Mailer.send(message);
	}
}