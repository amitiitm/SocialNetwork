package business.delegates
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.genclass.Delegate;
	import model.GenModelLocator;
	import mx.controls.Alert;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;
	
	public class LoginPwdChangeDelegate extends Delegate
	{
		private var __locator:ServiceLocator = GenModelLocator.getInstance().services;
		private var __loginPwdChangeService:HTTPService;
		private var __responder:IResponder;

		public function LoginPwdChangeDelegate(responder:IResponder) 
		{
			__loginPwdChangeService = __locator.getHTTPService("loginPwdChange");
			__responder = responder;
		}

		public function loginPwdChange(userXML:XML):void
		{
			__loginPwdChangeService = dataService(__loginPwdChangeService);

			var token:AsyncToken = __loginPwdChangeService.send(userXML);
			token.addResponder(__responder);
		}
	}
}
