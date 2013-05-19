package business.commands
{
	import business.delegates.PopulateListDelegate;
	import business.events.GetRecordEvent;
	import business.events.PopulateListEvent;
	import business.events.RecordStatusEvent;
	import business.events.SortOrderSelectionChangingEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.genclass.Utility;
	
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedSuperclassName;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.CursorManager;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.Base64Decoder;
	
	import valueObjects.ModeVO;
	
	public class PopulateListCommand implements ICommand
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
			
			__genModel.activeModelLocator.listObj.rows = new XML(resultXML);
		   	__genModel.activeModelLocator.listObj.filteredList = new XML(resultXML);
		   	
		   	if(__genModel.triggerSource	==	'DRILLDOWN' 
		   		&& getQualifiedSuperclassName(__genModel.controller) == "business::DataEntryController" 
		   		&&(XML)(resultXML).children().length() > 0)//for dataentry only
		   	{
		   		/*since getRecordEvent and viewOnlyRecordEvent is not registered for EditableListController they are not called 
		   		when populateListCommand is called for EditableList as we needed */
		   		__genModel.activeModelLocator.listObj.selectedRow	=	XML(__genModel.activeModelLocator.listObj.filteredList).children()[0];
		   
		   		var getRecordEvent:GetRecordEvent = new GetRecordEvent(int(__genModel.activeModelLocator.listObj.selectedRow.id.toString()));
				getRecordEvent.dispatch();
	
				__genModel.activeModelLocator.documentObj.selectedMode	=	ModeVO.EDIT_MODE;
				/* 16 march 2011 since we are calling this from getRecordCommand
				 var viewOnlyRecordEvent:ViewOnlyRecordEvent	=	new ViewOnlyRecordEvent();
				viewOnlyRecordEvent.dispatch(); */
		   	}
		   	
		   	__genModel.triggerSource	=	'MENU';
		   	
		   	// Vivek Dubey 30 March 2010
			var recordStatusEvent:RecordStatusEvent = new RecordStatusEvent("NEW")
			recordStatusEvent.dispatch()

			/* var sortOrderSelectionChangingEvent:SortOrderSelectionChangingEvent;
			
			sortOrderSelectionChangingEvent	= new SortOrderSelectionChangingEvent();
			sortOrderSelectionChangingEvent.dispatch(); */
		}

		private function faultHandler(event:FaultEvent):void
		{
			CursorManager.removeBusyCursor();
			Application.application.enabled	=	true;
			
			Alert.show('populate list command'+event.fault.toString());
		}
	}
}