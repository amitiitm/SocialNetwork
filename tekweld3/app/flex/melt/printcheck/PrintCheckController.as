package melt.printcheck
{
	import business.DataEntryController;
	import business.events.AddEvent;

	public class PrintCheckController extends DataEntryController
	{
		public function PrintCheckController()
		{
			super();
			removeCommand(AddEvent.EVENT_ID)
		}
	}
}