package business
{
	import business.commands.*;
	import business.events.*;

	public class DataEntryController extends CommonController
	{
		public function DataEntryController()
		{
			super();
			
			addCommand(ExportEvent.EVENT_ID, ExportListCommand);
			addCommand(PopulateListEvent.EVENT_ID, PopulateListCommand);
		    addCommand(SortOrderSelectionChangingEvent.EVENT_ID, SortOrderSelectionChangingCommand);
		    addCommand(FilterListEvent.EVENT_ID, FilterListCommand);
			addCommand(RefreshEvent.EVENT_ID, RefreshCommand);						
			addCommand(InitializeDataEntryEvent.EVENT_ID, InitializeDataEntryCommand);
			addCommand(SaveRecordEvent.EVENT_ID, SaveRecordCommand);
			addCommand(CancelEvent.EVENT_ID, CancelCommand);
			addCommand(CloseAddEditViewEvent.EVENT_ID, CloseAddEditViewCommand);
		    addCommand(ViewOnlyRecordEvent.EVENT_ID, ViewOnlyRecordCommand);
		    addCommand(GetRecordEvent.EVENT_ID, GetRecordCommand);
			addCommand(PreSaveEvent.EVENT_ID, PreSaveCommand);
			addCommand(AddEditEvent.EVENT_ID, AddEditCommand);
			addCommand(AddEvent.EVENT_ID, AddCommand);

			addCommand(FirstRecordEvent.EVENT_ID, FirstRecordCommand);
			addCommand(PreviousRecordEvent.EVENT_ID, PreviousRecordCommand);	
			addCommand(NextRecordEvent.EVENT_ID, NextRecordCommand);
			addCommand(LastRecordEvent.EVENT_ID, LastRecordCommand);

		 //  addCommand(GetGenDataGridFormatEvent.EVENT_ID, GetGenDataGridFormatCommand);		// commented because added in Application Controller
		    addCommand(GetGenListDataEvent.EVENT_ID, GetGenListDataCommand);

			/*..............detail commands..............................*/
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
			
			/*....................detail import functionality..............................*/
			addCommand(DetailImportEvent.EVENT_ID, DetailImportCommand);
			addCommand(InitializeDetailImportEvent.EVENT_ID, InitializeDetailImportCommand);
			addCommand(DetailImportCloseEvent.EVENT_ID, DetailImportCloseCommand);
			addCommand(PreSaveImportedXMLEvent.EVENT_ID, PreSaveImportedXMLCommand);
			addCommand(SaveImportedXMLEvent.EVENT_ID, SaveImportedXMLCommand);
			
			
			/*...............................fetch commands...........................................*/
			addCommand(InitializeFetchRecordsEvent.EVENT_ID, InitializeFetchRecordsCommand);
			addCommand(FetchRecordsEvent.EVENT_ID, FetchRecordsCommand);
			addCommand(FetchRecordSelectEvent.EVENT_ID, FetchRecordSelectCommand);
			addCommand(RecordStatusEvent.EVENT_ID, RecordStatusCommand);
			
			/*...............................fetch with detail commands...........................................*/
			addCommand(InitializeFetchRecordsWithDetailEvent.EVENT_ID, InitializeFetchRecordsWithDetailCommand);
			addCommand(FetchRecordsWithDetailEvent.EVENT_ID, FetchRecordsWithDetailCommand);
			addCommand(FetchRecordWithDetailSelectEvent.EVENT_ID, FetchRecordWithDetailSelectCommand);
			
			/*.....................import functionality at dataentry level...................*/
			addCommand(InitializeImportEvent.EVENT_ID, InitializeImportCommand);
			addCommand(CancelImportEvent.EVENT_ID, CancelImportCommand); 
			addCommand(SaveImportRecordEvent.EVENT_ID, SaveImportRecordCommand);
			addCommand(PreSaveImportEvent.EVENT_ID, PreSaveImportCommand);		
			addCommand(ImportRecordsEvent.EVENT_ID, ImportRecordsCommand);		
			/*..........................................................................*/		
		
			/*.....................QuickAdd functionality from lookup...................*/
			addCommand(InitializeQuickDataEntryEvent.EVENT_ID, InitializeQuickDataEntryCommand);
			addCommand(QuickAddEvent.EVENT_ID, QuickAddCommand);
			addCommand(QuickAddRecordCloseEvent.EVENT_ID, QuickAddRecordCloseCommand);		
			addCommand(QuickPreSaveEvent.EVENT_ID, QuickPreSaveCommand);	
			addCommand(QuickSaveRecordEvent.EVENT_ID, QuickSaveRecordCommand);	
			/*..........................................................................*/		

			/*..................... Quick Update Record ...................*/
			addCommand(InitializeQuickDetailUpdateEvent.EVENT_ID, InitializeQuickDetailUpdateCommand);
			addCommand(QuickDetailUpdateEvent.EVENT_ID, QuickDetailUpdateCommand);
			addCommand(QuickDetailUpdateCloseEvent.EVENT_ID, QuickDetailUpdateCloseCommand);		
			addCommand(QuickDetailUpdatePreSaveEvent.EVENT_ID, QuickDetailUpdatePreSaveCommand);	
			addCommand(QuickDetailUpdateSaveRecordEvent.EVENT_ID, QuickDetailUpdateSaveRecordCommand);	
			/*..........................................................................*/		

			addCommand(CopyRecordEvent.EVENT_ID, CopyRecordCommand);
			addCommand(CopyRowEvent.EVENT_ID, CopyRowCommand);
		}
	}
}
