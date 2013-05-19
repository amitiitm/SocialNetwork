package business.delegates
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.genclass.Delegate;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.CursorManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;
	import mx.utils.StringUtil;
	
	public class PrintDelegate extends Delegate	
	{
		private var __locator:ServiceLocator = GenModelLocator.getInstance().services;
		private var __getPrintRecordURLService:HTTPService;
		private var __getPrintReportURLService:HTTPService;
		private var __getPrintRecordFromReportURLService:HTTPService;
		private var __getPrintDataInSpecificFormatURLService:HTTPService;
		private var __responder:IResponder;
		private var __genModel:GenModelLocator	=	GenModelLocator.getInstance();
		
		public function PrintDelegate(responder:IResponder)
		{
			__getPrintRecordURLService 					= __locator.getHTTPService("printRecord");
			__getPrintReportURLService 					= __locator.getHTTPService("printReport");
		
			__responder = responder;
		}

		public function getPrintURL(recordId:String , printInExcel:String = "N"):void
		{
		
			if(StringUtil.trim(__getPrintRecordURLService.url.toString())	==	'')
			{
				Alert.show('print format not available');
				CursorManager.removeBusyCursor();
				Application.application.enabled	=	true;
				return;
			}
			dataService(__getPrintRecordURLService);

			var _xml:XML = new XML(	<params>
										<id>{recordId}</id>
										<date_format>{__genModel.user.date_format}</date_format>
										<print_in_excel>{printInExcel}</print_in_excel>
									</params>);

			var token:AsyncToken = __getPrintRecordURLService.send(_xml);
			token.addResponder(__responder);
		}
		public function printRecords(aXML:XML):void
		{
			if(StringUtil.trim(__getPrintRecordURLService.url.toString())	==	'')
			{
				Alert.show('print format not available');
				CursorManager.removeBusyCursor();
				Application.application.enabled	=	true;
				return;
			}

			dataService(__getPrintRecordURLService);

			var token:AsyncToken = __getPrintRecordURLService.send(aXML);
			token.addResponder(__responder);
		}		
		
		public function getPrintReportURL(aXML:XML):void
		{
			if(StringUtil.trim(__getPrintReportURLService.url.toString())	==	'')
			{
				Alert.show('print format not available');
				CursorManager.removeBusyCursor();
				Application.application.enabled	=	true;
				return;
			}

			dataService(__getPrintReportURLService);

			var token:AsyncToken = __getPrintReportURLService.send(aXML);
			token.addResponder(__responder);
		}
		public function printDataInSpecificFormatURL(aXML:XML):void
		{
			__getPrintDataInSpecificFormatURLService	= __locator.getHTTPService("printDataInSpecificFormat");
			if(StringUtil.trim(__getPrintDataInSpecificFormatURLService.url.toString())	==	'')
			{
				Alert.show('print format not available');
				CursorManager.removeBusyCursor();
				Application.application.enabled	=	true;
				return;
			}

			dataService(__getPrintDataInSpecificFormatURLService);

			var token:AsyncToken = __getPrintDataInSpecificFormatURLService.send(aXML);
			token.addResponder(__responder);
		}	
		
		/*to print a record from report , selected item will be printed*/	
		public function printRecordFromReport(aXML:XML):void
		{
			__getPrintRecordFromReportURLService	= __locator.getHTTPService("printRecord");
			
			if(StringUtil.trim(__getPrintRecordFromReportURLService.url.toString())	==	'')
			{
				Alert.show('print not available');
				CursorManager.removeBusyCursor();
				Application.application.enabled	=	true;
				return;
			}

			dataService(__getPrintRecordFromReportURLService);

			var token:AsyncToken = __getPrintRecordFromReportURLService.send(aXML);
			token.addResponder(__responder);
		}		
	}
}
