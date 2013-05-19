package business.delegates
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.customcomponents.GenDataGrid;
	import com.generic.genclass.Delegate;
	import model.GenModelLocator;
	import mx.controls.Alert;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;

	public class GetGenDataGridFormatDelegate extends Delegate
	{
		private var __locator:ServiceLocator = GenModelLocator.getInstance().services;
		private var __gridFormatService:HTTPService;
		private var __responderGridFormat:IResponder;
		
		public function GetGenDataGridFormatDelegate(responder:IResponder)
		{
			__responderGridFormat = responder;
		}
	
		public function getGridFormat(formatServiceID:String):void
		{
			__gridFormatService = __locator.getHTTPService(formatServiceID);

			formatService(__gridFormatService);

			var token:AsyncToken = __gridFormatService.send();
			token.addResponder(__responderGridFormat);
		}
	}
}
