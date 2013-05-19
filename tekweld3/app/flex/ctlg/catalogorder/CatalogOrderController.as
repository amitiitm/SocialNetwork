package ctlg.catalogorder
{
	import business.DataEntryController;
	import business.events.AddEvent;
	import business.events.InsertRowEvent;
	import business.events.RefreshEvent;

	public class CatalogOrderController extends DataEntryController
	{
		public function CatalogOrderController()
		{
			super();
			
			removeCommand(AddEvent.EVENT_ID)
			removeCommand(InsertRowEvent.EVENT_ID)
		}
	}
}

