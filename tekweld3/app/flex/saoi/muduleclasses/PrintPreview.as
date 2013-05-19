package saoi.muduleclasses
{
	
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	public class PrintPreview
	{
		public var __genModel:GenModelLocator ;
		public var __localModel:Object;
		public var __services:ServiceLocator;
		private var __responder:Responder;
		private var commonUtility:CommonUtility   		  				= new CommonUtility();
		
		public function PrintPreview()
		{
			__genModel		= GenModelLocator.getInstance();
			__localModel	= __genModel.activeModelLocator;
			__services		= __genModel.services;
		}
		
		public function printPreview():void
		{
			if(__localModel.addEditObj.record!=null)
			{
				var orderId:String  = __localModel.addEditObj.record.children()[0].id.toString();
				if(orderId!='' && orderId!=null)
				{
					var resend:HTTPService  = commonUtility.dataService(__services.getHTTPService("printPreview"));
					__responder 			= new mx.rpc.Responder(printPreviewResultHandler,printPreviewFaultHandler);
					
					var token:AsyncToken 	= resend.send(new XML(<params>
																	<id>{orderId}</id>
																</params>));
					token.addResponder(__responder);	
					
					__genModel.isLockScreen   = true;
				}
				else
				{
					Alert.show("Please save record before view print preview");
				}
			}
			else
			{
				Alert.show("Please save record before view print preview");
			}
		}
		
		private  function printPreviewResultHandler(event:ResultEvent):void
		{
			__genModel.isLockScreen   = false;
			
			var resultXml:XML  		  = XML(event.result);
			
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
				var url:String 				= __genModel.path.report_print  + resultXml["result"].toString()
				var request:URLRequest 		= new URLRequest(url);
				navigateToURL(request);
			}
			
		}
		private function printPreviewFaultHandler(event:FaultEvent):void
		{
			Alert.show("printPreview"+event.fault.faultDetail);
			
			__genModel.isLockScreen   = false;
		}
		
	}
}