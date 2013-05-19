package business.delegates
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.genclass.Delegate;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;

	public class FetchRecordDelegate extends Delegate
	{
		private var __locator:ServiceLocator = GenModelLocator.getInstance().services;
		private var __fetchRecordFormatService:HTTPService; 
		private var __fetchRecordDataService:HTTPService;
		private var __responderRecordFormat:IResponder;
		private var __responderRecordData:IResponder;
		
		public function FetchRecordDelegate(formatResponder:IResponder ,dataResponder:IResponder)
		{
			__responderRecordFormat =	formatResponder;
			__responderRecordData	=	dataResponder;
		}
	
		public function getFetchRecordFormat(formatServiceID:String):void
		{
			__fetchRecordFormatService = __locator.getHTTPService(formatServiceID);

			formatService(__fetchRecordFormatService);

			var token:AsyncToken = __fetchRecordFormatService.send();
			token.addResponder(__responderRecordFormat);
		}
		
		public function getFetchRecordData(id:String , dataServiceID:String, company_id:int):void
		{
			//Alert.show('cust_id'+ cust_id.toString());
			__fetchRecordDataService = __locator.getHTTPService(dataServiceID);
			dataService(__fetchRecordDataService);
			
			var fetchDocCriteria:XML	=	new XML(
													<criterias>
														<criteria>
															<default_request>N</default_request>
															<int1>{id}</int1><int2>{id}</int2>
															<company_id>{company_id}</company_id>
														</criteria>
													</criterias>
													)
			var token:AsyncToken = __fetchRecordDataService.send(fetchDocCriteria);
			token.addResponder(__responderRecordData);
		}
		public function getFetchRecordDataFromCriteria(criteriaXML:XML , dataServiceID:String):void
		{
			__fetchRecordDataService = __locator.getHTTPService(dataServiceID);
			dataService(__fetchRecordDataService);
			
			var token:AsyncToken = __fetchRecordDataService.send(criteriaXML);
			token.addResponder(__responderRecordData);
		}
		
	}
}
