package business.delegates
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.genclass.Delegate;
	import model.GenModelLocator;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;
	
	public class MenuDelegate extends Delegate	
	{
		private var __locator:ServiceLocator = GenModelLocator.getInstance().services;  
		private var __getMenuService:HTTPService;
		private var __responder:IResponder;

		public function MenuDelegate(responder:IResponder)
		{
			__getMenuService = __locator.getHTTPService("getMenus");
			__responder = responder;
		}

		public function getMenus(user_id:int, module_id:int):void
		{
			var xmlCriteria:XML = new XML(	<criteria>
												<moodule_id>{module_id}</moodule_id>
												<user_id>{user_id}</user_id>
											</criteria>);
		
			dataService(__getMenuService);

			var token:AsyncToken = __getMenuService.send(xmlCriteria);
			token.addResponder(__responder);
		}
	}
}
