package saoi.muduleclasses
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.genclass.URL;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	public class CommonLinksServices
	{
		public var __genModel:GenModelLocator ;
		public var __localModel:Object;
		public var __services:ServiceLocator;
		private var __responder:Responder;
		
		public function CommonLinksServices()
		{
			__genModel		= GenModelLocator.getInstance();
			__localModel	= __genModel.activeModelLocator;
			__services		= __genModel.services;
		}
		public function dataService(service:HTTPService):HTTPService
		{
			var urlObj:URL				=	new URL();
			service.url					=	urlObj.getURL(service.url);
			service.resultFormat 		= "e4x";					
			service.method 				= "POST";
			service.useProxy			= false;
			service.contentType			="application/xml";
			service.requestTimeout	 	= 1800
			service.showBusyCursor		= true
				
			return service;
		}
		
		// artwork send for stitch estimation
		public function sendArtworkForStitchEstimation():void
		{
			if(__localModel.addEditObj.record!=null)
			{
				var orderId:String  = __localModel.addEditObj.record.children()[0].id.toString();
				if(orderId!='' && orderId!=null)
				{
					var resend:HTTPService  = dataService(__services.getHTTPService("sendArtworkForEstimation"));
					__responder 			= new mx.rpc.Responder(sendArtworkForStitchEstimationResultHandler,sendArtworkForStitchEstimationFaultHandler);
					
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
		
		private  function sendArtworkForStitchEstimationResultHandler(event:ResultEvent):void
		{
			CursorManager.removeBusyCursor();
			__genModel.isLockScreen   = false;
			
			Alert.show(event.result.toString());
			
		}
		private function sendArtworkForStitchEstimationFaultHandler(event:FaultEvent):void
		{
			Alert.show("ResendArtworkSendToCustomer"+event.fault.faultDetail);
			
			CursorManager.removeBusyCursor();
			__genModel.isLockScreen   = false;
		}
		
		// resend invoices
		public function resendInvoice():void
		{
			if(__localModel.addEditObj.record!=null)
			{
				var orderId:String  = __localModel.addEditObj.record.children()[0].id.toString();
				if(orderId!='' && orderId!=null)
				{
					var resend:HTTPService = dataService(__services.getHTTPService("resendInvoice"));
					__responder			   = new mx.rpc.Responder(resendInvoiceResultHandler,resendInvoiceFaultHandler);
					
					var token:AsyncToken = resend.send(new XML(<params>
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
		private function resendInvoiceResultHandler(event:ResultEvent):void
		{
			CursorManager.removeBusyCursor();
			__genModel.isLockScreen   = false;
			
			Alert.show(event.result.toString());
			
		}
		private function resendInvoiceFaultHandler(event:FaultEvent):void
		{
			Alert.show("ResendInvoice"+event.fault.faultDetail);
			
			CursorManager.removeBusyCursor();
			__genModel.isLockScreen   = false;
		}
		
		// resend acknowlegment
		
		public function resendAcknowledgment():void
		{
			if(__localModel.addEditObj.record!=null)
			{
				var orderId:String  = __localModel.addEditObj.record.children()[0].id.toString();
				if(orderId!='' && orderId!=null)
				{
					var resend:HTTPService 	= dataService(__services.getHTTPService("resendAcknowledgment"));
					__responder				 = new mx.rpc.Responder(resendAckResultHandler,resendAckFaultHandler);
					
					var token:AsyncToken = resend.send(new XML(<params>
															<id>{orderId}</id>
															</params>));
					token.addResponder(__responder);	
					
					CursorManager.setBusyCursor();
					__genModel.isLockScreen  = true;
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
		public function resendAckResultHandler(event:ResultEvent):void
		{
			CursorManager.removeBusyCursor();
			__genModel.isLockScreen  = false;
			
			Alert.show(event.result.toString());
			
		}
		public function resendAckFaultHandler(event:FaultEvent):void
		{
			Alert.show("ResendAck"+event.fault.faultDetail);
			
			CursorManager.removeBusyCursor();
			__genModel.isLockScreen  = false;
		}
		
		// 
		// send quotation to customer
		
		public function sendQuotationToCustomer():void
		{
			if(__localModel.addEditObj.record!=null)
			{
				var orderId:String  = __localModel.addEditObj.record.children()[0].id.toString();
				if(orderId!='' && orderId!=null)
				{
					var resend:HTTPService 	= dataService(__services.getHTTPService("sendQuotationToCustomer"));
					__responder				 = new mx.rpc.Responder(sendQuotationToCustomerResultHandler,sendQuotationToCustomerFaultHandler);
					
					var token:AsyncToken = resend.send(new XML(<params>
															<id>{orderId}</id>
															</params>));
					token.addResponder(__responder);	
					
					__genModel.isLockScreen  = true;
				}
				else
				{
					Alert.show("Please save record before send to customer");
				}
			}
			else
			{
				Alert.show("Please save record before send to customer");
			}
			
			
		}
		public function sendQuotationToCustomerResultHandler(event:ResultEvent):void
		{
			__genModel.isLockScreen  = false;
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
				Alert.show(event.result.toString());
			}
			
			
		}
		public function sendQuotationToCustomerFaultHandler(event:FaultEvent):void
		{
			__genModel.isLockScreen  = false;
			Alert.show("sendQuotationToCustomer"+event.fault.faultDetail);
		}
		
		// resend proof
		
		public function reSendProof():void
		{
			if(__localModel.addEditObj.record!=null)
			{
				var orderId:String  = __localModel.addEditObj.record.children()[0].id.toString();
				if(orderId!='' && orderId!=null)
				{
					var resend:HTTPService 	= dataService(__services.getHTTPService("reSendProof"));
					__responder				 = new mx.rpc.Responder(reSendProofResultHandler,reSendProofFaultHandler);
					
					var token:AsyncToken = resend.send(new XML(<params>
															<id>{orderId}</id>
															</params>));
					token.addResponder(__responder);	
					
					CursorManager.setBusyCursor();
					__genModel.isLockScreen  = true;
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
		public function reSendProofResultHandler(event:ResultEvent):void
		{
			CursorManager.removeBusyCursor();
			__genModel.isLockScreen  = false;
			
			Alert.show(event.result.toString());
			
		}
		public function reSendProofFaultHandler(event:FaultEvent):void
		{
			Alert.show("reSendProof"+event.fault.faultDetail);
			
			CursorManager.removeBusyCursor();
			__genModel.isLockScreen  = false;
		}
		
		// sned tracking info
		
		public function sendTrackingInfo():void
		{
			if(__localModel.addEditObj.record!=null)
			{
				var orderId:String  = __localModel.addEditObj.record.children()[0].id.toString();
				if(orderId!='' && orderId!=null)
				{
					var resend:HTTPService 	= dataService(__services.getHTTPService("sendTrackingInfo"));
					__responder				 = new mx.rpc.Responder(sendTrackingInfoResultHandler,sendTrackingInfoFaultHandler);
					
					var token:AsyncToken = resend.send(new XML(<params>
															<id>{orderId}</id>
															</params>));
					token.addResponder(__responder);	
					
					CursorManager.setBusyCursor();
					__genModel.isLockScreen  = true;
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
		public function sendTrackingInfoResultHandler(event:ResultEvent):void
		{
			CursorManager.removeBusyCursor();
			__genModel.isLockScreen  = false;
			
			Alert.show(event.result.toString());
			
		}
		public function sendTrackingInfoFaultHandler(event:FaultEvent):void
		{
			Alert.show("sendTrackingInfo"+event.fault.faultDetail);
			
			CursorManager.removeBusyCursor();
			__genModel.isLockScreen  = false;
		}
		
	}
}