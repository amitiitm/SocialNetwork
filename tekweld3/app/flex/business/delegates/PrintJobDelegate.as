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
	
	public class PrintJobDelegate extends Delegate	
	{
		private var __locator:ServiceLocator = GenModelLocator.getInstance().services;
		private var __getPrintJobURLService:HTTPService;
		private var __responder:IResponder;
		private var __genModel:GenModelLocator	=	GenModelLocator.getInstance();
		
		public function PrintJobDelegate(responder:IResponder)
		{
			__getPrintJobURLService = __locator.getHTTPService("printJob");
			__responder = responder;
		}

		
		public function printJob(aXML:XML):void
		{
			if(StringUtil.trim(__getPrintJobURLService.url.toString())	==	'')
			{
				Alert.show('print format not available');
				CursorManager.removeBusyCursor();
				Application.application.enabled	=	true;
				return;
			}

			dataService(__getPrintJobURLService);

			var token:AsyncToken = __getPrintJobURLService.send(aXML);
			token.addResponder(__responder);
		}		
	}
}
