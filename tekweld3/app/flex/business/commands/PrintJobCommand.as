package business.commands
{
	import business.delegates.PrintDelegate;
	import business.delegates.PrintJobDelegate;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.CursorManager;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
		
	public class PrintJobCommand implements ICommand
	{
		private var __genModel:GenModelLocator=GenModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			if(__genModel.activeModelLocator.addEditObj.record!=null)
			{
				var orderId:Number 					=	Number(__genModel.activeModelLocator.addEditObj.record.children()[0].id.toString());
				var printParameterXML:XML			=	new XML(<params>
																<id>{orderId}</id>
															</params>);
			
				var callbacks:Responder 			= 	new Responder(printJobResultHandler, faultHandler);
				var delegate:PrintJobDelegate		=	new PrintJobDelegate(callbacks);
				
				CursorManager.setBusyCursor();
				Application.application.enabled = false;
				delegate.printJob(printParameterXML);
			}
			else
			{
				Alert.show("Please Save or Retrieve record");
			}
			
		}
		private function printJobResultHandler(event:ResultEvent):void
		{
			CursorManager.removeBusyCursor();
			Application.application.enabled = true;
			
			var url:String = __genModel.path.report_print  + XML(event.result)["result"].toString()
			var request:URLRequest = new URLRequest(url);

			navigateToURL(request);
		}

		private function faultHandler(event:FaultEvent):void
		{
			CursorManager.removeBusyCursor();
			Application.application.enabled = true;
			Alert.show(PrintJobCommand + " : " + event.fault.toString());
		}		
		
	}
}