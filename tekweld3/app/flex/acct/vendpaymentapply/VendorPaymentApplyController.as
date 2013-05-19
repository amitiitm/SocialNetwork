package acct.vendpaymentapply
{
	import business.DataEntryController;
	import business.events.AddEvent;
	import business.events.InsertRowEvent;
	import business.events.RefreshEvent;

	public class VendorPaymentApplyController extends DataEntryController
	{
		public function VendorPaymentApplyController()
		{
			super();
			removeCommand(AddEvent.EVENT_ID)
			removeCommand(InsertRowEvent.EVENT_ID)
			removeCommand(RefreshEvent.EVENT_ID)	
					
		}
	}
}
