package business
{
	import business.commands.*;
	import business.events.*;
	
	public class ReportController extends CommonController
	{
		public function ReportController()
		{
			super()

			//moved from common controoler as these events will have different commands in customReport
			addCommand(PopulateListEvent.EVENT_ID, PopulateListCommand);
		    addCommand(SortOrderSelectionChangingEvent.EVENT_ID, SortOrderSelectionChangingCommand);
		    addCommand(FilterListEvent.EVENT_ID, FilterListCommand);
			addCommand(RefreshEvent.EVENT_ID, RefreshCommand);						
			addCommand(InitializeReportEvent.EVENT_ID, InitializeReportCommand);
			addCommand(DrillDownEvent.EVENT_ID, DrillDownCommand);
		}
	}
}