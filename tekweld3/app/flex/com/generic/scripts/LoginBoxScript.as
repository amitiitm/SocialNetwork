import business.events.CreateCompanyEvent;
import business.events.CreateUserEvent;
import business.events.ForgotPasswordEvent;
import business.events.LoginPwdChangeEvent;
import business.events.UserLoginEvent;

import com.generic.events.LoginEvent;
import com.generic.genclass.GenObject;
import com.generic.genclass.GenValidator;

import flash.desktop.Updater;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.ProgressEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.SharedObject;
import flash.net.URLRequest;
import flash.net.URLStream;
import flash.ui.Keyboard;
import flash.utils.ByteArray;

import model.GenModelLocator;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.rpc.IResponder;

import valueObjects.LoginVO;

private var user_id:String;
private var sharedObj:SharedObject;


private function handleForgotLogInIdBtnMouseOver():void
{
	//     ForgotLogInId.useHandCursor;
	//     ForgotLogInId.setStyle("htmlLinkover","#000000");
	//     ForgotLogInId.setStyle("textDecoration", "underline");
}

private function handleForgotLogInIdBtnMouseOut():void
{
	//  ForgotLogInId.setStyle("textDecoration", "normal");
}

private function handleForgotPasswordBtnMouseOver():void
{
	RegYourComNow.useHandCursor;
	ForgotPassword.setStyle("textDecoration", "underline");
}

private function handleForgotPasswordBtnMouseOut():void
{
	ForgotPassword.setStyle("textDecoration", "normal");
}

private function handleRegYourComNowBtnMouseOver():void
{
	RegYourComNow.setStyle("text-roll-over-color","#067AB4");
	RegYourComNow.useHandCursor;
	RegYourComNow.setStyle("textDecoration", "underline");
}

private function handleRegYourComNowBtnMouseOut():void
{
	RegYourComNow.setStyle("textDecoration", "normal");
}

private function initEntry(): void
{
	tiCompany.drawFocus(true);
	initSharedObject();
} 

private function initSharedObject():void{
	
	sharedObj = SharedObject.getLocal("companyInfo");
	
	if (sharedObj.size > 0)
	{
		tiCompany.text		=	sharedObj.data.company;
		tiCompanyName.text	=	sharedObj.data.companyname;
		tiLogin.text		=	sharedObj.data.logIn;
	}
	
}

//Already User can Logged in directly.
private function enterPressed(event:KeyboardEvent):void
{
	if(event.keyCode == Keyboard.ENTER)
	{
		login();
	}
}

private function login():void 
{
	var genObjects:ArrayCollection = new GenObject().getGenObjects(vbSignIn)
	var genValidator:GenValidator = new GenValidator()
	var validators:Array = genValidator.applyValidation(genObjects)
	
	
	if(genValidator.runCustomValidator(validators) >= 0)
	{
		GenModelLocator.comapnyShortName	=	"http://" +tiCompanyName.text;
		var loginObj:LoginVO = new LoginVO();
		var callbacks:IResponder = new mx.rpc.Responder(handleAccountLoginResult, null);
		var userLoginEvent:UserLoginEvent;
		
		loginButton.enabled = false;
		
		loginObj = new LoginVO();
		loginObj.code = tiCompany.text;
		loginObj.password = tiPassword.text;
		loginObj.login = tiLogin.text
		
		userLoginEvent = new UserLoginEvent(loginObj, callbacks);
		userLoginEvent.dispatch();
	}
}

private function handleAccountLoginResult(isSuccess:Boolean):void 
{
	loginButton.enabled = true;
	
	if(isSuccess)
	{
		if(cbRememberMe.selected)
		{
			sharedObj.data.company 		= tiCompany.text;
			sharedObj.data.logIn 		= tiLogin.text;
			sharedObj.data.companyname 	= tiCompanyName.text;
			sharedObj.flush();
		}
		else
		{
			sharedObj.clear();
		}
		
		if(parseInt(GenModelLocator.getInstance().user.total_logins) > 0)
		{
			this.dispatchEvent(new LoginEvent('login'));
		}
		else
		{
			vsForms.selectedChild = vbLoginPwdChange 			
		}
	}
}

private function createNewCompany():void
{
	var genObjects:ArrayCollection = new GenObject().getGenObjects(vbCompany)
	var genValidator:GenValidator = new GenValidator()
	var validators:Array = genValidator.applyValidation(genObjects)
	
	if(genValidator.runCustomValidator(validators) >= 0)
	{
		var callbacks:IResponder = new mx.rpc.Responder(handleCreateUserResult, null);
		var createUserEvent:CreateUserEvent;
		
		var userXML:XML = new XML
			(
				<main_users>
					<main_user>
						<first_name>{tiFirstName.text}</first_name>
						<last_name>{tiLastName.text}</last_name>
						<email>{tiEmail.text}</email>
					</main_user>
				</main_users>
			)
		
		createUserEvent = new CreateUserEvent(userXML, callbacks)
		createUserEvent.dispatch()
	}
}


private function handleCreateUserResult(result:Object):void
{
	user_id = result.user_id;
	
	if(result.LoginFlag)
	{
		var callbacks:IResponder = new mx.rpc.Responder(handleCreateCompanyResult, null);
		var createCompanyEvent:CreateCompanyEvent;
		
		var companyXML:XML = new XML(	<main_companies user_id={user_id}>
											<main_company>
												<code>{tiBusinessLoginName.text}</code>
												<name>{tiBusinessName.text}</name>
												<email_address>{tiBusinessEmail.text}</email_address>
												<phone>{tiPhone.text}</phone>
												<address1>{tiBusinessAddress1.text}</address1>
												<address2>{tiBusinessAddress2.text}</address2>
												<city>{tiBusinessCity.text}</city>
												<state>{tiBusinessState.text}</state>
												<zip>{tiBusinessZip.text}</zip>
											</main_company>
										</main_companies>
		)
		
		createCompanyEvent = new CreateCompanyEvent(companyXML, callbacks)
		createCompanyEvent.dispatch()
	}
	else
	{
		Alert.show("Error in creating user")	
	}
}

private function handleCreateCompanyResult(isSuccess:Boolean):void
{
	if(isSuccess)
	{
		//vsForms.selectedChild = vbLogin
		Alert.show("Company has been created,\nPlease check you e-mail .....")
	}
	else
	{
		Alert.show("Error in creating company")
	}
}

private function handleForgotPasswordResult(isSuccess:Boolean):void
{
	if(isSuccess)
	{
		//vsForms.selectedChild = vbLogin
		Alert.show("Password has been reset,\nPlease check you e-mail .....")
	}
	else
	{
		Alert.show("Error in password resetting")
	}
}
private function changeToForgotPasswordView():void
{
	vsForms.selectedChild	=	vbForgotPassword;
}
private function handleForgotPasswordBackBtnClick():void
{
	vsForms.selectedChild	=	vbSignIn;
}
private function handleForgotPasswordBtnClick():void
{
	var genObjects:ArrayCollection = new GenObject().getGenObjects(vbForgotPassword)
	var genValidator:GenValidator = new GenValidator()
	var validators:Array = genValidator.applyValidation(genObjects)
	
	if(genValidator.runCustomValidator(validators) >= 0)
	{
		var callbacks:IResponder = new mx.rpc.Responder(handleForgotPasswordResult, null);
		var forgotPasswordEvent:ForgotPasswordEvent;
		
		var userXML:XML = new XML(	<users>
										<user>
											<company>{tiCompany.text}</company>
											<login>{tiForgotPassword.text}</login>
										</user>
									</users>
		)
		
		forgotPasswordEvent = new ForgotPasswordEvent(userXML, callbacks)
		forgotPasswordEvent.dispatch()
		
		Alert.show("Please check you e-mail .....")
	}
}

private function handleNewCompanyBtnClick():void
{
	vsForms.selectedChild = vbUser
}

private function handleBtnNextClick():void
{
	var genObjects:ArrayCollection = new GenObject().getGenObjects(vbUser)
	var genValidator:GenValidator = new GenValidator()
	var validators:Array = genValidator.applyValidation(genObjects)
	
	if(genValidator.runCustomValidator(validators) >= 0)
	{
		vsForms.selectedChild = vbCompany
	}
}

private function handleBtnBackClick():void
{
	vsForms.selectedChild = vbUser
}

private function changeLoginPwd():void
{
	var user_id:int = GenModelLocator.getInstance().user.userID;
	var genObjects:ArrayCollection = new GenObject().getGenObjects(vbLoginPwdChange)
	var genValidator:GenValidator = new GenValidator()
	var validators:Array = genValidator.applyValidation(genObjects)
	
	if(genValidator.runCustomValidator(validators) >= 0)
	{
		if(tiNewPassword.text == tiReEnterPassword.text)
		{
			var callbacks:IResponder = new mx.rpc.Responder(handleLoginPwdChangeResult, null);
			var createLoginPwdChange:LoginPwdChangeEvent;
			
			var userXML:XML = new XML(	<users>
											<user>
												<id>{user_id}</id>
												<old_password>{tiOldPassword.text}</old_password>
												<new_password>{tiNewPassword.text}</new_password>
											</user>
										</users>
			)
			
			createLoginPwdChange = new LoginPwdChangeEvent(userXML, callbacks)
			createLoginPwdChange.dispatch()
		}
		else
		{
			Alert.show("Password does not match with confirm password, please reenter")
			tiNewPassword.text = ""
			tiReEnterPassword.text = ""
		}
	}
}

private function handleLoginPwdChangeResult(isSuccess:Boolean):void
{
	if(isSuccess)
	{
		this.dispatchEvent(new LoginEvent('login'));
	}
	else
	{
		vsForms.selectedChild = vbLogin 			
	}
}
/*to take update of air application */
private var _airFileUrl:String;
private var _latestVersion:String;
private var stream:URLStream;

public function switchTOUpdateApplicationMode(currentVersion:String,latestVersion:String,airFileUrl:String):void
{
	vsForms.selectedChild	=	vbupdateApplication;
	_airFileUrl				=	airFileUrl;
	_latestVersion			=	latestVersion;
	textUploadStatus.text = "You are running version " +currentVersion + ". However, version " + latestVersion +" is available. Click the update button to update.";
}
private function updateApplication():void 
{
	btnUpdateApplicationBack.height		=	0;
	btnUpdateApplicationBack.width		=	0;
	btnUpdateApplicationBack.visible	=	false;
	
	btnUpdateApplicationStopUpdate.height	=	26;
	btnUpdateApplicationStopUpdate.width	=	90;
	btnUpdateApplicationStopUpdate.visible	=	true;
	
	stream = new URLStream();
	stream.addEventListener(ProgressEvent.PROGRESS,progressHandler);
	stream.addEventListener(Event.COMPLETE,downloadCompleteHandler);
	stream.load(new URLRequest(_airFileUrl));
	textUploadStatus.text = "Downloading update";
}
private function progressHandler(event:ProgressEvent):void {
	textUploadStatus.text = "Downloading update " +
		event.bytesLoaded + " of " + event.bytesTotal + " bytes";
}
private function downloadCompleteHandler(event:Event):void {
	textUploadStatus.text = "Download complete";
	var urlStream:URLStream = event.target as URLStream;
	var file:File =File.applicationStorageDirectory.resolvePath("newVersion.air");
	var fileStream:FileStream = new FileStream();
	fileStream.open(file, FileMode.WRITE);
	var bytes:ByteArray = new ByteArray();
	urlStream.readBytes(bytes);
	fileStream.writeBytes(bytes);
	fileStream.close();
	var updater:Updater = new Updater();
	updater.update(file, _latestVersion);
	vsForms.selectedChild	=	vbSignIn;
}
private function stopUpdate():void
{
	stream.close();
	vsForms.selectedChild	=	vbSignIn;
}