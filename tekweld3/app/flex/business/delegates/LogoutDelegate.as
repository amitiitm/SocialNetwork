package business.delegates
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.genclass.Delegate;
	import model.GenModelLocator;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;
	
	public class LogoutDelegate extends Delegate
	{
		private var __locator:ServiceLocator = GenModelLocator.getInstance().services;  
		private var __logoutService:HTTPService;
		private var __responder:IResponder;
		
		public function LogoutDelegate(responder:IResponder)
		{
			__logoutService = __locator.getHTTPService("getLogout");
			__responder = responder;
		}
		
		public function getLogout():void
		{
			objectService(__logoutService);
			
			var token:AsyncToken = __logoutService.send();
			token.addResponder(__responder);
		}
	}
}
