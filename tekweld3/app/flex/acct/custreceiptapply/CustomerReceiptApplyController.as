package acct.custreceiptapply
{
	import business.DataEntryController;
	import business.events.AddEvent;
	import business.events.InsertRowEvent;
	import business.events.RefreshEvent;

	public class CustomerReceiptApplyController extends DataEntryController
	{
		public function CustomerReceiptApplyController()
		{
			super();
			
			removeCommand(AddEvent.EVENT_ID)
			removeCommand(InsertRowEvent.EVENT_ID)
			removeCommand(RefreshEvent.EVENT_ID)
			
			
		}
	}
}
