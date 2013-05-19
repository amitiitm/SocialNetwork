package business.delegates
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.genclass.Delegate;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;

	public class LayoutDelegate extends Delegate
	{
		private var __locator:ServiceLocator = GenModelLocator.getInstance().services;
		private var __saveLayoutService:HTTPService;
		private var __getLayoutService:HTTPService;
		private var __getColumnListService:HTTPService;
		
		public function LayoutDelegate() {}
		
		public function saveLayout(layout:XML):void
		{
			
			var xml:XML = new XML(<report_layouts/>);
			xml.appendChild(layout.copy())

			__saveLayoutService = __locator.getHTTPService("saveLayout");
			dataService(__saveLayoutService);
			__saveLayoutService.send(xml);
		}
		public function getLayouts(userID:int, documentID:int , __responderGetLayout:IResponder):void
		{
			var xml:XML = new XML(	<criteria>
										<user_id>{userID}</user_id>
										<document_id>{documentID}</document_id>										
									</criteria>);	
									
			__getLayoutService = __locator.getHTTPService("getLayouts");
			
			dataService(__getLayoutService);
			
			var token:AsyncToken = __getLayoutService.send(xml);
			token.addResponder(__responderGetLayout);
		}		
		public function getColumnList(userID:int, documentID:int , __responderGetColumn:IResponder):void
		{
			var xml:XML = new XML(	<criteria>
										<document_id>{documentID}</document_id>										
									</criteria>);	

			__getColumnListService = __locator.getHTTPService("getColumnsList");
			
			//formatService(__getColumnListService);
			dataService(__getColumnListService);

			var token:AsyncToken = __getColumnListService.send(xml);
			token.addResponder(__responderGetColumn);
		}		
			
	}
}
