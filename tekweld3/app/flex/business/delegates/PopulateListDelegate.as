package business.delegates
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.genclass.Delegate;
	import model.GenModelLocator;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;
	import mx.controls.Alert;
	
	public class PopulateListDelegate extends Delegate	
	{
		private var __locator:ServiceLocator = GenModelLocator.getInstance().services;
		private var __populateListService:HTTPService;
		private var __responder:IResponder;
		
		public function PopulateListDelegate(responder:IResponder)
		{
			__populateListService = __locator.getHTTPService("getList");
			__responder = responder;
		}

		public function populateList(selectedView:XML):void
		{
			dataService(__populateListService);

			var token:AsyncToken = __populateListService.send(selectedView);
			token.addResponder(__responder);
		}
	}
}
