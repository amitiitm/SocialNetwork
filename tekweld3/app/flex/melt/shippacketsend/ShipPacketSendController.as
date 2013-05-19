package melt.shippacketsend
{
	import business.DataEntryController;
	import business.events.AddEvent;

	public class ShipPacketSendController extends DataEntryController
	{
		public function ShipPacketSendController()
		{
			super();
			removeCommand(AddEvent.EVENT_ID)
		}
	}
}