package melt.packettransaction
{
	import business.DataEntryController;
	import business.events.AddEvent;
	import business.events.InsertRowEvent;
	import business.events.RefreshEvent;

	public class PacketTransactionController extends DataEntryController
	{
		public function PacketTransactionController()
		{
			super();
			removeCommand(AddEvent.EVENT_ID)
		
			
		}
	}
}