package business.delegates
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.genclass.Delegate;
	import model.GenModelLocator;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;

	public class GetRecordDelegate extends Delegate
	{
		private var __locator:ServiceLocator = GenModelLocator.getInstance().services;
		private var __getRecordService:HTTPService;
		private var __responder:IResponder;

		public function GetRecordDelegate(responder:IResponder)
		{
			__getRecordService = __locator.getHTTPService("getRecord");
			__responder = responder;
		}
		
		public function getRecord(recordsXml:XML):void
		{
			//var params:XML = new XML(<params></params>)
			//var str:String = "<id>" + id + "</id>"

			//params.appendChild((XML)(str));
			
			dataService(__getRecordService);

			var token:AsyncToken = __getRecordService.send(recordsXml);
			token.addResponder(__responder);
		}
	}
}
