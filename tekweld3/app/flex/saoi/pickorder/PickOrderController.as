package saoi.pickorder
{
	import business.EditableListController;
	import business.events.RecordStatusEvent;

	public class PickOrderController extends EditableListController
	{
		public function PickOrderController()
		{
			super();
			removeCommand(RecordStatusEvent.EVENT_ID);
		}
	}
}
