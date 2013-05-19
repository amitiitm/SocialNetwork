package business.delegates
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.genclass.Delegate;
	import model.GenModelLocator;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;
	
	public class CreateCompanyDelegate extends Delegate
	{
		private var __locator:ServiceLocator = GenModelLocator.getInstance().services;
		private var __createCompanyService:HTTPService;
		private var __responder:IResponder;

		public function CreateCompanyDelegate(responder:IResponder) 
		{
			__createCompanyService = __locator.getHTTPService("createCompany");
			__responder = responder;
		}
		
		public function createCompany(companyXML:XML):void
		{
			__createCompanyService = dataService(__createCompanyService);

			var token:AsyncToken = __createCompanyService.send(companyXML);
			token.addResponder(__responder);
		}
	}
}