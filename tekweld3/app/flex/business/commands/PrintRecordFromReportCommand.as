package business.commands
{
	import business.delegates.PrintDelegate;
	import business.events.PrintRecordFromReportEvent;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.customcomponents.GenCustomReportDataGrid;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import model.GenModelLocator;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.CursorManager;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	public class PrintRecordFromReportCommand implements ICommand
	{
		private var __genModel:GenModelLocator=GenModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			var customReportObj:GenCustomReportDataGrid	=	__genModel.activeModelLocator.reportObj.customReportDataGrid;
			
			if(customReportObj.selectedItem != null)
			{
				if(XML(customReportObj.selectedItem).children().length()>0)
				{
					CursorManager.setBusyCursor();
					Application.application.enabled	= false;
					
					var printInExcel:String	=	(event as PrintRecordFromReportEvent).printInExcel;
					
					var callbacksPrint:Responder = new Responder(printCommandResultHandler, faultHandler);
					var delegate:PrintDelegate = new PrintDelegate(callbacksPrint)
					
					var row:XML	=	XML(customReportObj.selectedItem).copy();
					
					row.printInExcel	=	printInExcel.toString();
					row.date_format		=	__genModel.user.date_format;
					
					
					
					delegate.printRecordFromReport(row);
				}
				else
				{
					Alert.show('Please select row  to print');
				}
			}
			else
			{
				Alert.show('Please select row  to print');
			}
		}
		
		private function printCommandResultHandler(event:ResultEvent):void
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
			
			Alert.show(event.fault.toString());	
		}		
	}
}
