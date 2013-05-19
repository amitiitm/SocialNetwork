package business.delegates
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.genclass.Delegate;
	import model.GenModelLocator;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;
	
	import valueObjects.LoginVO;
	
	public class UserLoginDelegate extends Delegate
	{
		private var __locator:ServiceLocator = GenModelLocator.getInstance().services;
		private var __loginService:HTTPService;
		private var __responder:IResponder;
		private static var __relative_login_url:String	=	"";
		
		public function UserLoginDelegate(responder:IResponder) 
		{
			__loginService = __locator.getHTTPService("getLogin");
			__responder = responder;
		}
		
		public function login(loginObj:LoginVO):void
		{
			//__loginService = objectService(__loginService);
			
			if(__relative_login_url == "") //means login first time
			{
				__relative_login_url	=	__loginService.url.toString();
			}
			__loginService.resultFormat = "e4x";
			__loginService.method = "POST";
			__loginService.useProxy = false;
			
			__loginService.url	=	getLoginURL();
			
			var token:AsyncToken = __loginService.send({code:loginObj.code, login: loginObj.login, password: loginObj.password});
			token.addResponder(__responder);
		}
		private function getLoginURL():String
		{
			var url:String;
			
			if(GenModelLocator.main_url == "")
			{
				//dealing with web 
				url	=	__relative_login_url
			}
			else
			{
				url = GenModelLocator.comapnyShortName + GenModelLocator.main_url.toString() + __relative_login_url;
			}
			return url;
		}
	}
}