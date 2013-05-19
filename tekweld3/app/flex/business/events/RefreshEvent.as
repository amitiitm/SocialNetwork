package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class RefreshEvent extends CairngormEvent
	{
		public static var EVENT_ID:String = "refreshEvent";

		public function RefreshEvent()
		{
			super(EVENT_ID);
		}
	}
}