package melt.attachvideo
{
	import business.DataEntryController;
	import business.events.AddEvent;

	public class AttachVideoController extends DataEntryController
	{
		public function AttachVideoController()
		{
			super();
			removeCommand(AddEvent.EVENT_ID)
		}
	}
}