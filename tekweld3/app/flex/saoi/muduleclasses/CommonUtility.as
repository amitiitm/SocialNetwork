package saoi.muduleclasses
{
	import com.generic.genclass.URL;
	
	import mx.rpc.http.HTTPService;

	public class CommonUtility
	{
		public function CommonUtility()
		{
			
		}
		
		public function dataService(service:HTTPService):HTTPService
		{
			var urlObj:URL				=	new URL();
			service.url					=	urlObj.getURL(service.url);
			service.resultFormat 		= "e4x";					
			service.method 				= "POST";
			service.useProxy			= false;
			service.contentType			="application/xml";
			service.requestTimeout	 	= 1800
			service.showBusyCursor		= true;
			
			return service;
		}
		
	}
}