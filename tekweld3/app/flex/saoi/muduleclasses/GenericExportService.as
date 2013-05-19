package saoi.muduleclasses
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.genclass.URL;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	public class GenericExportService
	{
		public var __genModel:GenModelLocator ;
		public var __localModel:Object;
		public var __services:ServiceLocator;
		private var __responder:Responder;
		
		public function GenericExportService()
		{
			__genModel		= GenModelLocator.getInstance();
			__localModel	= __genModel.activeModelLocator;
			__services		= __genModel.services;
		}
		
		// artwork send for stitch estimation
		public function exportData(serviceName:String,paramXml:XML):void
		{
			if(paramXml!=null)
			{
				var orderId:String  = paramXml.children()[0].id.toString();
				if(orderId!='' && orderId!=null)
				{
					var http:HTTPService	= new HTTPService();
					http.url				= serviceName;
					var resend:HTTPService  = new CommonUtility().dataService(http);
					__responder 			= new mx.rpc.Responder(exportDataResultHandler,exportDataFaultHandler);
					
					var token:AsyncToken 	= resend.send(new XML(<params>
																	<id>{orderId}</id>
																</params>));
					token.addResponder(__responder);	
					
					CursorManager.setBusyCursor();
					__genModel.isLockScreen   = true;
				}
				else
				{
					Alert.show("Please select record");
				}
			}
			else
			{
				Alert.show("Please select record");
			}
			
		}
		
		private  function exportDataResultHandler(event:ResultEvent):void
		{
			CursorManager.removeBusyCursor();
			__genModel.isLockScreen   = false;
			
			var resultXml:XML			= XML(event.result);
			
			if(resultXml.name() == "errors")
			{
				if(resultXml.children().length() > 0) 
				{
					var message:String = '';
					
					for(var i:uint = 0; i < resultXml.children().length(); i++) 
					{
						message += resultXml.children()[i] + "\n";
					}
					Alert.show(message);
				} 
			}
			else
			{
				var url:String = __genModel.path.report_print  + XML(event.result)["result"].toString()
				var request:URLRequest = new URLRequest(url);
				
				navigateToURL(request);
			}
			
		}
		private function exportDataFaultHandler(event:FaultEvent):void
		{
			Alert.show("exportDataFaultHandler"+event.fault.faultDetail);
			
			CursorManager.removeBusyCursor();
			__genModel.isLockScreen   = false;
		}
		
	}
}