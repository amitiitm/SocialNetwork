package business.delegates
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.genclass.Delegate;
	import model.GenModelLocator;
	import mx.controls.Alert;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;
	
	public class SaveEditableListDelegate extends Delegate
	{
		private var __locator:ServiceLocator = GenModelLocator.getInstance().services;
		private var __saveInboxService:HTTPService;
		private var __responder:IResponder;

		public function SaveEditableListDelegate(responder:IResponder)
		{
			__saveInboxService = __locator.getHTTPService("saveRecord");
			__responder = responder;
		}

		public function save(inboxXML:XML):void
		{
			dataService(__saveInboxService);

			var token:AsyncToken = __saveInboxService.send(inboxXML);
			token.addResponder(__responder);
		}
	}
}
