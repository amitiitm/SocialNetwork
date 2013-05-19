package business.delegates
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.genclass.Delegate;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;
	
	public class ExportDelegate extends Delegate	
	{
		private var __locator:ServiceLocator = GenModelLocator.getInstance().services;
		private var __getExportURLService:HTTPService;
		private var __responder:IResponder;
		
		public function ExportDelegate(responder:IResponder)
		{
			__getExportURLService = __locator.getHTTPService("export");
			__responder = responder;
		}

		public function getExportURL(exportXMLList:XML):void
		{
			dataService(__getExportURLService);
			
			var token:AsyncToken = __getExportURLService.send(exportXMLList);
			token.addResponder(__responder);
		}
	}
}
