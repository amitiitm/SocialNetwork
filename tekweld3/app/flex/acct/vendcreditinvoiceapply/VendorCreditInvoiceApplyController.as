package acct.vendcreditinvoiceapply
{
	
	import business.DataEntryController;
	import business.events.AddEvent;
	import business.events.InsertRowEvent;
	import business.events.RefreshEvent;

	public class VendorCreditInvoiceApplyController extends DataEntryController
	{
		public function VendorCreditInvoiceApplyController()
		{
			super();

			removeCommand(AddEvent.EVENT_ID)
			removeCommand(InsertRowEvent.EVENT_ID)
			removeCommand(RefreshEvent.EVENT_ID)
		}
	}
}
