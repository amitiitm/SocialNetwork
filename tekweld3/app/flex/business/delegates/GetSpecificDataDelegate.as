package business.delegates
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.genclass.Delegate;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;

	public class GetSpecificDataDelegate extends Delegate
	{
		private var __locator:ServiceLocator = GenModelLocator.getInstance().services;
		private var __getSpecificFormatService:HTTPService;
		private var __responder:IResponder;

		public function GetSpecificDataDelegate(responder:IResponder)
		{
			__responder = responder;
		}
		
		public function getFormat(doc_id:String):void
		{
			__getSpecificFormatService = __locator.getHTTPService("getPrintSpecificFormat");
			
			var _criteria:XML = new XML(<params>
							   				<document_id>{doc_id}</document_id>
				                		</params>); 
			
			dataService(__getSpecificFormatService);
			
			
			var token:AsyncToken = __getSpecificFormatService.send(_criteria);
			token.addResponder(__responder); 
		}
	}
}


