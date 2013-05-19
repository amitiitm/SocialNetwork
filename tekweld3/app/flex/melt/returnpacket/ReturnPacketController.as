package melt.returnpacket
{
	import business.DataEntryController;
	import business.events.AddEvent;

	public class ReturnPacketController extends DataEntryController
	{
		public function ReturnPacketController()
		{
			super();
			removeCommand(AddEvent.EVENT_ID)
		}
	}
}