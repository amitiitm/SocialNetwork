package business.delegates
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.genclass.Delegate;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;
	
	public class CreateUserDelegate extends Delegate
	{
		private var __locator:ServiceLocator = GenModelLocator.getInstance().services;
		private var __createUserService:HTTPService;
		private var __responder:IResponder;

		public function CreateUserDelegate(responder:IResponder) 
		{
			__createUserService = __locator.getHTTPService("createUser");
			__responder = responder;
		}
		
		public function createUser(userXML:XML):void
		{
			__createUserService = dataService(__createUserService);

			var token:AsyncToken = __createUserService.send(userXML);
			token.addResponder(__responder);
		}
	}
}
