package business
{
	import business.commands.*;
	import business.events.*;
	
	public class EditableListController extends CommonController
	{
		public function EditableListController()
		{
			super()

			//moved from common controoler as these events will have different commands in customReport
			addCommand(ExportEvent.EVENT_ID, ExportListCommand);
			
			addCommand(PopulateListEvent.EVENT_ID, PopulateListCommand);
		    addCommand(SortOrderSelectionChangingEvent.EVENT_ID, SortOrderSelectionChangingCommand);
		    addCommand(FilterListEvent.EVENT_ID, FilterListCommand);
			
			addCommand(RefreshEvent.EVENT_ID, RefreshCommand);						
			
			addCommand(InitializeEditableListEvent.EVENT_ID, InitializeEditableListCommand);
			addCommand(SaveRecordEvent.EVENT_ID, SaveEditableListCommand) // SaveEditableListCommand;
			addCommand(PreSaveEvent.EVENT_ID, PreSaveCommand);
			addCommand(PreSaveCustomEvent.EVENT_ID, PreSaveCustomCommand);	// New by VD 05 Apr 2010.
			addCommand(RecordStatusEvent.EVENT_ID, RecordStatusCommand)
			addCommand(CancelEvent.EVENT_ID, CancelEditableListControlCommand)
			
		}
	}
}