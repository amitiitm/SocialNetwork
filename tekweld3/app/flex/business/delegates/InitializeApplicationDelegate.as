package business.delegates
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.genclass.Delegate;
	import model.GenModelLocator;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;
	
	public class InitializeApplicationDelegate extends Delegate
	{
		private var __locator:ServiceLocator = GenModelLocator.getInstance().services;  
		
		private var __getModuleService:HTTPService;
		private var __getMenuService:HTTPService;
		private var __getMasterDataService:HTTPService;
		private var __getPathsService:HTTPService;
		private var __getDefaultSetupService:HTTPService;
		
		
		private var __responderModule:IResponder;
		private var __responderMenu:IResponder;
		private var __responderMasterData:IResponder;
		private var __responderPaths:IResponder;
		private var __responderDefaultSetup:IResponder;
		
		public function InitializeApplicationDelegate(responderModule:IResponder, responderMenu:IResponder, responderMasterData:IResponder, responderPaths:IResponder,responderDefaultSetup:IResponder)
		{
			__getModuleService 				= __locator.getHTTPService("getModules");
			__getMenuService 				= __locator.getHTTPService("getMenus");
			__getMasterDataService 			= __locator.getHTTPService("getMasterData");
			__getPathsService 				= __locator.getHTTPService("getPaths");
			__getDefaultSetupService 		= __locator.getHTTPService("getDefaultSetupData");
		
						 
			__responderModule 				= responderModule;
			__responderMenu 				= responderMenu;
			__responderMasterData 			= responderMasterData;
			__responderPaths				= responderPaths;
			__responderDefaultSetup			= responderDefaultSetup;
		}
		
		public function getModules(ll_userID:int):void
		{
			var params:XML = new XML(<params></params>)
			var str:String = "<id>" + ll_userID + "</id>"

			params.appendChild((XML)(str));

			dataService(__getModuleService);

			var token:AsyncToken = __getModuleService.send(params);
			token.addResponder(__responderModule);
		}
		
		public function getMenus(ll_userID:int):void
		{
			var params:XML = new XML(<params></params>)
			var str:String = "<id>" + ll_userID + "</id>"

			params.appendChild((XML)(str));	
			
			dataService(__getMenuService);

			var token:AsyncToken = __getMenuService.send(params);
			token.addResponder(__responderMenu);
		}
		
		public function getMasterData():void
		{
			var xml:XML = new XML(<params>
									<type_cd value='trans_flag'>
										<subtype_cd value='trans_flag'/>
									</type_cd>
								</params>);
								
			dataService(__getMasterDataService);

			var token:AsyncToken = __getMasterDataService.send(xml);
			token.addResponder(__responderMasterData);
		}
		
		public function getPaths():void
		{
			dataService(__getPathsService);

			var xml:XML = new XML(<params>
									<type_cd value='paths'>
										<subtype_cd value='paths'/>
									</type_cd>
								</params>);

			var token:AsyncToken = __getPathsService.send(xml);
			token.addResponder(__responderPaths);
		}
		public function getDefaultSetup():void
		{
			dataService(__getDefaultSetupService);
			
			var xml:XML = new XML();
			
			var token:AsyncToken = __getDefaultSetupService.send(xml);
			token.addResponder(__responderDefaultSetup);
		}
	}
}
