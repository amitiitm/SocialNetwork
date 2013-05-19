package business.delegates
{
	import business.LookupServices;
	
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.genclass.Delegate;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;

	public class GetLookupDataDelegate extends Delegate
	{
		private var __locator:ServiceLocator = new LookupServices();
		private var __lookupService:HTTPService;
		private var __responderLookup:IResponder;

		public function GetLookupDataDelegate(responder:IResponder)
		{
			__responderLookup = responder;
		}

		public function getLookupData(lookupName:String, user_id:int, company_id:int):void
		{
			var xmlCriteria:XML = new XML(	<criteria>
												<lookupname>{lookupName}</lookupname>
												<user_id>{user_id}</user_id>
												<company_id>{company_id}</company_id>
											</criteria>);

			__lookupService = __locator.getHTTPService(lookupName);

			dataService(__lookupService);
			
			var token:AsyncToken = __lookupService.send(xmlCriteria);
			token.addResponder(__responderLookup);
		}
	}
}
