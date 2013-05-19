package business.commands
{
	import business.delegates.PopulateListDelegate;
	import business.events.PopulateListEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.genclass.Utility;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.CursorManager;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	public class PopulateReportDataCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			CursorManager.setBusyCursor();
			Application.application.enabled	= false; 
			
			var callbacks:Responder = new Responder(populateListResultHandler, faultHandler);
			var delegate:PopulateListDelegate = new PopulateListDelegate(callbacks)
			
			delegate.populateList((event as PopulateListEvent).selectedView);
		}
		
		private function populateListResultHandler(event:ResultEvent):void
		{
			
			CursorManager.removeBusyCursor();
			Application.application.enabled	= true;

			var resultXML:XML;
			var utilityObj:Utility	=	new Utility();
			resultXML 				= 		utilityObj.getDecodedXML((XML)(event.result));
			
			__genModel.activeModelLocator.reportObj.rows = new XML(resultXML);
		   	__genModel.activeModelLocator.reportObj.filteredReport = new XML(resultXML);
		   	__genModel.triggerSource	=	'MENU';
		   	
		}		
		private function faultHandler(event:FaultEvent):void
		{
			CursorManager.removeBusyCursor();
			Application.application.enabled	=	true;
			
			Alert.show('PopulateReportDataCommand'+event.fault.toString());
		}
	}
}
