package business
{
	import business.commands.*;
	import business.events.*;

	public class DataEntryWithNoListController extends CommonController
	{
		public function DataEntryWithNoListController()
		{
			super();

			addCommand(InitializeDataEntryWithNoListEvent.EVENT_ID, InitializeDataEntryWithNoListCommand);
			addCommand(SaveRecordEvent.EVENT_ID, SaveRecordDataEntryWithNoListCommand);
			addCommand(PreSaveEvent.EVENT_ID, PreSaveCommand);
		    addCommand(GetRecordEvent.EVENT_ID, GetRecordCommand);
		  //  addCommand(GetGenDataGridFormatEvent.EVENT_ID, GetGenDataGridFormatCommand);
		    addCommand(GetGenListDataEvent.EVENT_ID, GetGenListDataCommand);
			addCommand(RecordStatusEvent.EVENT_ID, RecordStatusCommand)
			addCommand(RefreshEvent.EVENT_ID, RefreshDataEntryWithNoListCommand);
			
			addCommand(PreSaveRowEvent.EVENT_ID, PreSaveRowCommand);
			addCommand(FirstRowEvent.EVENT_ID, FirstRowCommand);
			addCommand(PreviousRowEvent.EVENT_ID, PreviousRowCommand);
			addCommand(NextRowEvent.EVENT_ID, NextRowCommand);
			addCommand(LastRowEvent.EVENT_ID, LastRowCommand);
			addCommand(InsertRowEvent.EVENT_ID, InsertRowCommand);
			addCommand(SaveRowEvent.EVENT_ID, SaveRowCommand);
			addCommand(RemoveRowEvent.EVENT_ID, RemoveRowCommand);
			addCommand(CancelRowEvent.EVENT_ID, CancelRowCommand)
			addCommand(DetailEditCloseEvent.EVENT_ID, DetailEditCloseCommand)
			addCommand(RowStatusEvent.EVENT_ID, RowStatusCommand)
			
			addCommand(DetailEditEvent.EVENT_ID, DetailEditCommand);
			addCommand(InitializeDetailEditEvent.EVENT_ID, InitializeDetailEditCommand);

			addCommand(InitializeFetchRecordsEvent.EVENT_ID, InitializeFetchRecordsCommand);
			addCommand(FetchRecordsEvent.EVENT_ID, FetchRecordsCommand);
			addCommand(FetchRecordSelectEvent.EVENT_ID, FetchRecordSelectCommand);
			
			addCommand(CopyRowEvent.EVENT_ID, CopyRowCommand);
		}
	}
}
