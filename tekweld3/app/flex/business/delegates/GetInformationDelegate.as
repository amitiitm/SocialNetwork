package business.delegates
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.genclass.Delegate;
	import model.GenModelLocator;
	import mx.controls.Alert;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;

	public class GetInformationDelegate extends Delegate
	{
		private var __locator:ServiceLocator = GenModelLocator.getInstance().services;
		private var __getInformationService:HTTPService;
		private var __responderInformation:IResponder;

		public function GetInformationDelegate(responder:IResponder)
		{
			__responderInformation = responder;
			__getInformationService = __locator.getHTTPService("getInformation");
		}

		public function getInformation(criteria:XML):void
		{
			//Alert.show(criteria);
			 dataService(__getInformationService);
			
			var token:AsyncToken = __getInformationService.send(criteria);
			token.addResponder(__responderInformation); 
		}
	}
}
