component extends="BaseController" output=false{
	property name="MailerService" inject="model:MailerService";
	property name="AppSettings" inject="wirebox:properties";
	include '/includes/helpers/loginHelper.cfm';
	
	public function preHandler(event, rc, prc, action, eventArguments){
		event.setLayout('Login');
		super.preHandler(argumentCollection=arguments);
	}

	public function index(event,rc,prc){
		setNextEvent(url='/login');
	}

	/**
	 * Login form
	 * @param event,rc,prc (Coldbox request contexts)
	 **/
	public void function login(event,rc,prc){
		if(isUserInRole("Reporter")) setNextEvent(url="/logout");
		//login processing
		if(event.getHTTPMethod() is "POST"){
			var user =getModel("User").getUserFromLogin(rc);
			if(!isNull(user)){
				loginUser(user,rc);
				flash.put('hello','Welcome, #user.getFirstName()#!');
				setNextEvent(url=event.getValue("returnto",'/'));
				abort;
			} else {
				messagebox.error("The username and password provided could not be authenticated.  Please try again.");
			}
		} else {
			rc.returnto='/';
			if(event.valueExists('_securedURL')){
				rc.returnto=rc._securedURL;
			}
		}
		
		event.setView('authorization/login');
	}
	/**
	 * Logout Function
	 **/
	public void function logout(event,rc,prc){
		user=getModel("User").findByEmail(getAuthUser());
		//process logout, flash and redirect
		if(!isNull(user)){
		logoutUser();
			MessageBox.info('Goodbye, #user.getFirstName()#!  You have been successfully logged out.');
		}

		setNextEvent(url='/login');
	}

	/**
    * Forgot Password
    **/
    public void function forgot_password(event,rc,prc){
    	var user=getModel("User");
    	if(event.getHTTPMethod() is "POST"){
    		user=user.findByEmail(event.getValue("email",''));
    		if(!isNull(user)){
    			var rtoken = createUUID();
    			user.setResetToken(rtoken).save(flush=true);
    			rc.user=user;
    			sendResetEmail(user);
    			Messagebox.info('Your request to reset your password has been received.  Check your email for instructions.');
    			setNextEvent(url='/login');
    		} else{
    			Messagebox.error('The email address you provided could not be found in the system.  Please try again or contact and administrator');
    			setNextEvent(url='/login');
    		}
    	}
    	event.setView('authorization/forgot_password');
    }

    public void function reset_password(event,rc,prc){
    	if(event.valueExists("token")){
    		user=getModel("User").findByResetToken(rc.token);
    		if(!isNull(user)){
    			flash.put('user_record',user);
    			if(event.getHTTPMethod() is "POST"){
    				//if our passwords match
    				if(len(rc.pw_new) and (rc.pw_new eq rc.pw_new_verify)){
    					user.save(flush=true);
    					rc.password=getModel("UserService").toSecurePassword(rc.pw_new);
    					//erase token
    					user.setResetToken(javacast('null',''));
    					//now update our password
    					user.setPassword(rc.password);
    					user.save(flush=true);
    					//login our user
						loginUser(user,rc);
						Messagebox.info('Welcome back, #user.getFirstName()#!');
						setNextEvent(url=flash.get("returnto",'/'));
    				} else{
    					Messagebox.error("The passwords you provided don't match. Please try again.");
    				}
    			}
    			event.setView('authorization/reset_password');
    		} else{
  		  		Messagebox.error('Invalid Reset Token or the Token Provided Has Expired');
    			setNextEvent(url='/login');
    		}
    	} else{
    		Messagebox.error('No reset token was provided. Please check your email.');
    		setNextEvent(url='/login');
    	}
    }
	
	/**
     * Private Methods
     **/
    private function sendResetEmail(user){
    	return MailerService.send(argumentCollection={
				"to":user.getEmail(),
				"from":getSetting("email_from"),
				"subject":"Instructions to Reset Your #getSetting("site_title")# Password",
				"view"='email/PasswordResetInstructions',
				viewArgs={"user":user,"AppSettings":AppSettings}
			});
    }

}