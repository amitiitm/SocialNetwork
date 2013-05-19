package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class AddEditEvent extends CairngormEvent
	{
		public static var EVENT_ID:String = "addEditEvent";

		public function AddEditEvent() 
		{
			super(EVENT_ID);
		}
	}
}
