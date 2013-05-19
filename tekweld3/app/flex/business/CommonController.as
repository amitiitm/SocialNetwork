package business
{
	import business.commands.*;
	import business.events.*;
	
	public class CommonController extends ApplicationController
	{
		public function CommonController()
		{
			super();


		    
			addCommand(NotesEvent.EVENT_ID, NotesCommand);
			addCommand(GetNoteEvent.EVENT_ID, GetNoteCommand);
			addCommand(SaveNoteEvent.EVENT_ID, SaveNoteCommand);
			
			addCommand(AttachmentsEvent.EVENT_ID, AttachmentsCommand);	
			addCommand(GetAttachmentEvent.EVENT_ID, GetAttachmentCommand);
			addCommand(UploadAttachmentEvent.EVENT_ID, UploadAttachmentCommand);
						
			addCommand(QueryEvent.EVENT_ID, QueryCommand);
			addCommand(QueryOKEvent.EVENT_ID, QueryOKCommand);
			
			addCommand(ConfigureColumnEvent.EVENT_ID, ConfigureColumnCommand);
			addCommand(ConfigureColumnOKEvent.EVENT_ID, ConfigureColumnOKCommand);
			
			addCommand(SortEvent.EVENT_ID, SortCommand);
			addCommand(ListEvent.EVENT_ID, ListCommand);
			
			/*it is used to print inbox as well as dataentry screen*/
			addCommand(PrintEvent.EVENT_ID, PrintCommand);
			//addCommand(PrintRecordsEvent.EVENT_ID, PrintRecordsCommand)
			
			addCommand(LayoutEvent.EVENT_ID, LayoutCommand);
			
			addCommand(InitializeViewEvent.EVENT_ID, InitializeViewCommand);
			
			addCommand(InitializeLayoutEvent.EVENT_ID, InitializeLayoutCommand);
			addCommand(GetColumnListEvent.EVENT_ID, GetColumnListCommand);
			
			//it is row level drilldown initiated from inbox or any screen level grid.
			addCommand(InboxDrillDownEvent.EVENT_ID, InboxDrillDownCommand);
			addCommand(PrintGridEvent.EVENT_ID, PrintGridCommand);
			addCommand(ExportGridEvent.EVENT_ID,ExportGridCommand);
			
			//it willbe used to print report/list in specified print format 
			addCommand(PrintDataInSpecificFormatEvent.EVENT_ID,PrintDataInSpecificFormatCommnad);
			addCommand(GetSpecificFormatEvent.EVENT_ID,GetSpecificFormatCommand);
			
		}
	}
}