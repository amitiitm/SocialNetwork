package business.delegates
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.genclass.Delegate;
	import model.GenModelLocator;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;
	
	public class ForgotPasswordDelegate extends Delegate
	{
		private var __locator:ServiceLocator = GenModelLocator.getInstance().services;
		private var __resetPasswordService:HTTPService;
		private var __responder:IResponder;

		public function ForgotPasswordDelegate(responder:IResponder) 
		{
			__resetPasswordService = __locator.getHTTPService("resetPassword");
			__responder = responder;
		}
		
		public function resetPassword(userXML:XML):void
		{
			__resetPasswordService = dataService(__resetPasswordService);

			var token:AsyncToken = __resetPasswordService.send(userXML);
			token.addResponder(__responder);
		}
	}
}
