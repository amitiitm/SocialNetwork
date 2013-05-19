package business
{
	import business.commands.*;
	import business.events.*;
	
	public class CustomReportController extends CommonController
	{
		public function CustomReportController()
		{
			super()
			addCommand(ExportEvent.EVENT_ID, ExportCommand);
			
			//these three events are having diffrent commands for CustomReport.
			addCommand(PopulateListEvent.EVENT_ID, PopulateReportDataCommand);
		    addCommand(InitializeCustomReportEvent.EVENT_ID, InitializeCustomReportCommand);
			addCommand(RefreshEvent.EVENT_ID, RefreshCommand);
			addCommand(PrintReportEvent.EVENT_ID, PrintReportCommand);	
			addCommand(DrillDownEvent.EVENT_ID, DrillDownCommand);	
			
			addCommand(PrintRecordFromReportEvent.EVENT_ID, PrintRecordFromReportCommand);				
		}
	}
}
