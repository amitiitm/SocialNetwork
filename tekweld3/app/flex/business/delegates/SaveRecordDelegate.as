package business.delegates
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.genclass.Delegate;
	import model.GenModelLocator;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;
	
	public class SaveRecordDelegate extends Delegate
	{
		private var __locator:ServiceLocator = GenModelLocator.getInstance().services;
		private var __saveRecordService:HTTPService;
		private var __responder:IResponder;

		public function SaveRecordDelegate(responder:IResponder)
		{
			__saveRecordService = __locator.getHTTPService("saveRecord");
			__responder = responder;
		}
		public function saveRecords(recordsXml:XML):void
		{
			dataService(__saveRecordService);

			var token:AsyncToken = __saveRecordService.send(recordsXml);
			token.addResponder(__responder);
		}
	}
}
