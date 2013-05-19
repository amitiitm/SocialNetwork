package melt.calculateoffer.business.delegate
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.genclass.Delegate;
	
	import model.GenModelLocator;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;
	
	public class CalculateOfferDelegate extends Delegate
	{
		private var __locator:ServiceLocator  = GenModelLocator.getInstance().services;
		private var __calculateOfferService:HTTPService;
		private var __responder:IResponder;
		
		public function CalculateOfferDelegate(responder:IResponder)
		{
			__calculateOfferService  = __locator.getHTTPService("calculateOffer");
			__responder = responder;
		}

		public function calculateOffer(calculateOfferXml:XML):void
		{
			__calculateOfferService = dataService(__calculateOfferService);

			var token:AsyncToken = __calculateOfferService.send(calculateOfferXml);
			token.addResponder(__responder);
		}
	}
}