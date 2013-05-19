package acct.custcreditinvoiceapply
{
	import business.DataEntryController;
	import business.events.AddEvent;
	import business.events.InsertRowEvent;
	import business.events.RefreshEvent;

	public class CustomerCreditInvoiceApplyController extends DataEntryController
	{
		public function CustomerCreditInvoiceApplyController()
		{
			super();

			removeCommand(AddEvent.EVENT_ID)
			removeCommand(InsertRowEvent.EVENT_ID)
			removeCommand(RefreshEvent.EVENT_ID)
		}
	}
}