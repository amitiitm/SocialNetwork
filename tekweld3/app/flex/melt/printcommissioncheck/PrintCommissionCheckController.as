package melt.printcommissioncheck
{
	import business.DataEntryController;
	import business.events.AddEvent;

	public class PrintCommissionCheckController extends DataEntryController
	{
		public function PrintCommissionCheckController()
		{
			super();
			removeCommand(AddEvent.EVENT_ID)
		}
	}
}