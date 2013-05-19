package saoi.muduleclasses
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.genclass.URL;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	public class GetCurrentOrderLocation
	{
		public var __genModel:GenModelLocator ;
		public var __localModel:Object;
		public var __services:ServiceLocator;
		private var __responder:Responder;
		
		private var tiWorkFlow_location:Object;
		
		private var getCurrentLocation_service_url:String 				= '/sale/sales/find_order_status';
		private var commonUtility:CommonUtility   		  				= new CommonUtility();

		public function GetCurrentOrderLocation()
		{
			__genModel		= GenModelLocator.getInstance();
			__localModel	= __genModel.activeModelLocator;
			__services		= __genModel.services;
		}
		
		// artwork send for stitch estimation
		public function getCurrentLocation(trans_no:Object,tiWorkFlow_location:Object):void
		{
			this.tiWorkFlow_location			= tiWorkFlow_location;
			
			if(trans_no.dataValue!='' && trans_no.dataValue !=null)
			{
				var tempXml:XML								= new XML(<params><trans_no>{trans_no.dataValue}</trans_no></params>);
				var httpservice:HTTPService					= new HTTPService();
				httpservice.url								= getCurrentLocation_service_url;
				var http:HTTPService 						= commonUtility.dataService(httpservice);
				var __responder:IResponder 					= new mx.rpc.Responder(getCurrentLocationResultHandler,getCurrentLocationFaultHandler);
				var token:AsyncToken 						= http.send(tempXml);
				token.addResponder(__responder);
			}
			else
			{
				Alert.show("Please select record");
			}
			
		}
		
		private  function getCurrentLocationResultHandler(event:ResultEvent):void
		{
			CursorManager.removeBusyCursor();
			__genModel.isLockScreen   = false;
			
			tiWorkFlow_location.dataValue	= XML(event.result).toString();
			
		}
		private function getCurrentLocationFaultHandler(event:FaultEvent):void
		{
			Alert.show("getCurrentLocation"+event.fault.faultDetail);
			
			CursorManager.removeBusyCursor();
			__genModel.isLockScreen   = false;
		}
	}
}