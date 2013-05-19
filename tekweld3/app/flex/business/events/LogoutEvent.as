package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class LogoutEvent  extends CairngormEvent
	{
		public static var EVENT_ID:String = "logoutEvent";

		public function LogoutEvent()
		{
			super(EVENT_ID);
		}
	}
}
