package business.delegates
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.components.Criteria;
	import com.generic.customcomponents.GenList;
	import com.generic.genclass.Delegate;
	import model.GenModelLocator;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;
	
	public class GetGenListDataDelegate extends Delegate
	{
		private var __locator:ServiceLocator = GenModelLocator.getInstance().services;
		private var __listDataService:HTTPService;
		private var __responderListData:IResponder;
		
		public function GetGenListDataDelegate(responder:IResponder)
		{
			__responderListData = responder;
		}
	
		public function getRows(genList:GenList):void
		{
			__listDataService = __locator.getHTTPService(genList.dataServiceID);

			// Later we will remove
			var criteria:XML = new XML(	<criterias>
											<criteria>
												<str1> </str1><str2>ZZZZ</str2>
												<str3> </str3><str4>ZZZZ</str4>
												<str5> </str5><str6>ZZZZ</str6>
												<default_request>N</default_request>
											</criteria>
										</criterias>)

			dataService(__listDataService);

			var token:AsyncToken = __listDataService.send(criteria);
			token.addResponder(__responderListData);
		}
	}
}



