package business.delegates
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.genclass.Delegate;
	import model.GenModelLocator;
	import mx.controls.Alert;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;
	
	public class InitializeDataEntryDelegate extends Delegate
	{
		private var __locator:ServiceLocator = GenModelLocator.getInstance().services;  
		private var __listFormatService:HTTPService;
		private var __responderListFormat:IResponder;
	
		
		public function InitializeDataEntryDelegate(responderListFormat:IResponder=null)
		{
			__responderListFormat = responderListFormat 
		}
		
		public function getListFormat():void
		{
			__listFormatService = __locator.getHTTPService("getListFormat");
			
			formatService(__listFormatService);

			var token:AsyncToken = __listFormatService.send();
			token.addResponder(__responderListFormat);
		}

	}
}
