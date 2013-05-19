package saoi.muduleclasses
{
	
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.components.Inbox;
	import com.generic.genclass.URL;
	
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.getQualifiedClassName;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.CursorManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	
	
	public class PrintObject
	{
		[Bindable]
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var __printPickSlip:IResponder;
		private var __responderPrintList:IResponder;
		
		public function dataService(service:HTTPService):HTTPService
		{
			var urlObj:URL				=	new URL();
			service.url					=	urlObj.getURL(service.url);
			service.resultFormat 		= 	"e4x";					
			service.method 				= 	"POST";
			service.useProxy			= 	false;
			service.contentType			=	"application/xml";
			service.requestTimeout	 	= 	1800
			
			return service;
		}
		public function printInboxRecord(inbox:Inbox,idFlag:String):void
		{
			var index:int=-1;
			for(var i:int=0;i<inbox.dgDtl.rows.children().length();i++)
			{
				if(inbox.dgDtl.rows.children()[i].select_yn== 'Y')
				{
					index= i;
					break;
				}
			}
			
			if(index>=0)
			{
				var orderId:Number = Number(inbox.dgDtl.rows.children()[index].id.toString());
				if(orderId>0)
				{
					CursorManager.setBusyCursor();
					//__genModel.isLockScreen		= true;
					
					var __service:ServiceLocator = __genModel.services;
					
					var printPickSlip:HTTPService = dataService(__service.getHTTPService("printPickSlip"));
					__printPickSlip = new mx.rpc.Responder(printPickSlipResultHandler,printPickSlipFaultHandler);
					var token:AsyncToken = printPickSlip.send(new XML(<params>
																	<id>{orderId}</id>
																	<id_flag>{idFlag}</id_flag>
																</params>));
					token.addResponder(__printPickSlip);
				}
				else
				{
					Alert.show("Please Save or Retrieve recoed");
				}
			}
			else
			{
				Alert.show("Please Select Record");
			}	
		}
		private function printListRecord(object:Object,idFlag:String):void
		{
			var __localModel:Object = __genModel.activeModelLocator;
			
			if(__localModel.addEditObj.record != null)
			{
				var orderId:Number = Number(__localModel.addEditObj.record.children()[0].id.toString());
				if(orderId>0)
				{
					CursorManager.setBusyCursor();
					__genModel.isLockScreen  = true;
					
					var __service:ServiceLocator = __genModel.services;
					
					var printjob:HTTPService 	= dataService(__service.getHTTPService("printPickSlip"));
					__responderPrintList 		= new mx.rpc.Responder(printJobResultHandler,printJobFaultHandler);
					var token:AsyncToken 		= printjob.send(new XML(<params>
																	<id>{orderId}</id>
																	<id_flag>{idFlag}</id_flag>
																</params>));
					token.addResponder(__responderPrintList);
				}
				else
				{
					Alert.show("Please Save or Retrieve recoed");
				}
			}
		}
		private function printJobResultHandler(event:ResultEvent):void
		{
			CursorManager.removeBusyCursor();
			__genModel.isLockScreen  = false;
			
			var url:String = __genModel.path.report_print  + XML(event.result)["result"].toString()
			var request:URLRequest = new URLRequest(url);
			
			navigateToURL(request);
		}
		private function printJobFaultHandler(event:FaultEvent):void
		{
			Alert.show("Print Job Sales FilmJob" + " : " + event.fault.toString());
		}
		
		public function genratePickSlipHandler(object:Object):void
		{
			var lsClassName:String = getQualifiedClassName(object)
			
			if(lsClassName == "com.generic.components::Inbox")
			{
				printInboxRecord(Inbox(object),"L");
			}
			else
			{
				printListRecord(object,"O");
			}
			
		}
		private function printPickSlipResultHandler(event:ResultEvent):void
		{
			CursorManager.removeBusyCursor();
			//__genModel.isLockScreen  = false;;
			
			var url:String = __genModel.path.report_print  + XML(event.result)["result"].toString()
			var request:URLRequest = new URLRequest(url);
			
			navigateToURL(request);
		}
		public function printPickSlipFaultHandler(event:FaultEvent):void
		{
			Alert.show("printPickSlip#"+event.fault.faultDetail);
			
			CursorManager.removeBusyCursor();
			//__genModel.isLockScreen  = false;;
		}
		
	}
}