package business.commands
{
	import business.delegates.PrintDelegate;
	import business.events.PrintDataInSpecificFormatEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.components.PrintDataInSpecificFormatDetail;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.CursorManager;
	import mx.managers.PopUpManager;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
		
	public class PrintDataInSpecificFormatCommnad implements ICommand
	{
		private var __genModel:GenModelLocator=GenModelLocator.getInstance();
		private var printDataXML:XML;
		public function execute(event:CairngormEvent):void
		{
			if(__genModel.activeModelLocator.viewObj.selectedView	==	null	|| __genModel.activeModelLocator.viewObj.selectedView	==	XML(undefined))
			{
				Alert.show('please wait view is being populated.');
				return;
			}
			
			if(__genModel.activeModelLocator.documentObj.printFormatXML != XML(undefined) && __genModel.activeModelLocator.documentObj.printFormatXML.children().length() > 0)
			{
				var printFormats:XML	=	__genModel.activeModelLocator.documentObj.printFormatXML; 
				var dataType:String	=	(event as PrintDataInSpecificFormatEvent).dataType;
				var objPrintDataInSpecificFormatDetail:PrintDataInSpecificFormatDetail
				if(dataType	==	'REPORT')
				{
					objPrintDataInSpecificFormatDetail	=	PrintDataInSpecificFormatDetail(PopUpManager.createPopUp((DisplayObject)(Application.application),PrintDataInSpecificFormatDetail,true));
					objPrintDataInSpecificFormatDetail.btnOK.addEventListener(MouseEvent.CLICK,btnPrintDataOKClickHandler)
					objPrintDataInSpecificFormatDetail.printFormats		=	__genModel.activeModelLocator.documentObj.printFormatXML;
					printDataXML	=	objPrintDataInSpecificFormatDetail.printDataXML;
				}
				else
				{
					Alert.show('Please Specify Data Type to be print');
				}
				
			}
			else
			{
				Alert.show('Print Formats not available.');
			} 
		}
		private function btnPrintDataOKClickHandler(event:MouseEvent):void
		{
			if(printDataXML.children().length() > 0)
			{
				CursorManager.setBusyCursor();
				Application.application.enabled = false;
				var callbacks:Responder 			= 	new Responder(printDataInSpecificFormatResultHandler, faultHandler);
				var delegate:PrintDelegate			=	new PrintDelegate(callbacks);
				
				delegate.printDataInSpecificFormatURL(printDataXML);
			}
		}
		
		private function printDataInSpecificFormatResultHandler(event:ResultEvent):void
		{
			CursorManager.removeBusyCursor();
			Application.application.enabled = true;
			
			if(String(XML(event.result)["result"].toString()).toUpperCase() == "NO RECORD FOUND")
			{
				Alert.show(XML(event.result)["result"].toString());
			}
			else
			{
				var url:String = __genModel.path.report_print  + XML(event.result)["result"].toString()
				var request:URLRequest = new URLRequest(url);
				
				navigateToURL(request);
				
			}
		}

		private function faultHandler(event:FaultEvent):void
		{
			CursorManager.removeBusyCursor();
			Application.application.enabled = true;
			Alert.show(printDataInSpecificFormatResultHandler + " : " + event.fault.toString());
		}		
		
	}
}
