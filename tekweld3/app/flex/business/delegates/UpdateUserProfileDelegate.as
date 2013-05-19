package business.delegates
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.genclass.Delegate;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.rpc.http.HTTPService;

	public class UpdateUserProfileDelegate extends Delegate
	{
		private var __locator:ServiceLocator = GenModelLocator.getInstance().services;
		private var __updateLastModuleService:HTTPService;
		
		public function updateLastModule(module_id:int, userID:int):void
		{
			var xml:XML = new XML(	<users>
										<user>
											<id>{userID}</id>
											<last_moodule_id>{module_id}</last_moodule_id>
										</user>
									</users>);

			__updateLastModuleService = __locator.getHTTPService("updateUserLastModule");
			dataService(__updateLastModuleService);
			__updateLastModuleService.send(xml);
		}
	}
}
