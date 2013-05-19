package business.delegates
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.genclass.Delegate;
	import model.GenModelLocator;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;
	
	public class SaveImportedXMLDelegate extends Delegate
	{
		private var __locator:ServiceLocator = GenModelLocator.getInstance().services;
		private var __saveService:HTTPService;
		private var __responder:IResponder;

		public function SaveImportedXMLDelegate(responder:IResponder)
		{
			__saveService = __locator.getHTTPService("saveImportedRecords");
			__responder = responder;
		}

		public function saveImportedXML(aXML:XML):void
		{
			dataService(__saveService);

			var token:AsyncToken = __saveService.send(aXML);
			token.addResponder(__responder);
		}
	}
}

