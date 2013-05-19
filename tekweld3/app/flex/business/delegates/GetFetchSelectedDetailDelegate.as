package business.delegates
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.genclass.Delegate;
	
	import model.GenModelLocator;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;

	public class GetFetchSelectedDetailDelegate extends Delegate
	{
		private var __locator:ServiceLocator = GenModelLocator.getInstance().services;
		private var __fetchSelectedDetailService:HTTPService;
		private var __responderSelectedDetail:IResponder;
		
		public function GetFetchSelectedDetailDelegate(dataResponder:IResponder)
		{
			__responderSelectedDetail	=	dataResponder;
		}
	
		public function getSelectedDetail(id:String , dataServiceID:String, company_id:int):void
		{
			//Alert.show('cust_id'+ cust_id.toString());
			__fetchSelectedDetailService = __locator.getHTTPService(dataServiceID);
			dataService(__fetchSelectedDetailService);
			
			var criteria:XML	=	new XML(
											<criterias>
												<criteria>
													<default_request>N</default_request>
													<int1>{id}</int1><int2>{id}</int2>
													<company_id>{company_id}</company_id>
												</criteria>
											</criterias>
											)
			var token:AsyncToken = __fetchSelectedDetailService.send(criteria);
			token.addResponder(__responderSelectedDetail);
		}
	}
}

