package business.commands
{
	import business.delegates.PrintDelegate;
	import business.events.PrintRecordsEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import model.GenModelLocator;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.CursorManager;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
		
	public class PrintRecordsCommand implements ICommand
	{
		private var __genModel:GenModelLocator=GenModelLocator.getInstance();
		private var arrColl:ArrayCollection;
		
		public function execute(event:CairngormEvent):void
		{
			var printParameterXML:XML	=	(event as PrintRecordsEvent).printParameterXML;
			
			var callbacks:Responder 			= new Responder(printRecordsResultHandler, faultHandler);
			var delegate:PrintDelegate	=	new PrintDelegate(callbacks);
			
			delegate.printRecords(printParameterXML);
			Alert.show('Print Records Command');
		}
		private function printRecordsResultHandler(event:ResultEvent):void
		{
			CursorManager.removeBusyCursor();
			Application.application.enabled = true;
			
			var url:String = __genModel.path.report_print  + XML(event.result)["result"].toString()
			var request:URLRequest = new URLRequest(url);

			navigateToURL(request);
		}

		private function faultHandler(event:FaultEvent):void
		{
			Alert.show(PrintRecordsCommand + " : " + event.fault.toString());
		}		
		
	}
}