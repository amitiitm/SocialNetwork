package business.delegates
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.genclass.Delegate;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;

	public class ViewDelegate extends Delegate
	{
		private var __locator:ServiceLocator = GenModelLocator.getInstance().services;
		private var __saveViewService:HTTPService;
		private var __viewFormatService:HTTPService;
		private var __viewService:HTTPService;
		private var __responderViewFormat:IResponder;		
		private var __responderView:IResponder;
		
		public function ViewDelegate() {}
		
		public function getViewFormat(__responderViewFormat:IResponder):void
		{
			__viewFormatService = __locator.getHTTPService("getViewFormat");
			
			formatService(__viewFormatService);

			var token:AsyncToken = __viewFormatService.send();
			token.addResponder(__responderViewFormat);
		}
		
		public function getViews(userID:int, documentID:int , __responderView:IResponder):void
		{
			var xml:XML = new XML(	<criteria>
										<user_id>{userID}</user_id>
										<document_id>{documentID}</document_id>										
									</criteria>);
									
			__viewService = __locator.getHTTPService("getViews");
			dataService(__viewService);

			var token:AsyncToken = __viewService.send(xml);
			token.addResponder(__responderView);
		}
				
		public function saveView(view:XML, userID:int, documentID:int):void
		{
			var xml:XML = new XML(<criterias></criterias>);
			xml.appendChild(view.copy())

			__saveViewService = __locator.getHTTPService("saveView");
			dataService(__saveViewService);
			__saveViewService.send(xml);
		}
	}
}