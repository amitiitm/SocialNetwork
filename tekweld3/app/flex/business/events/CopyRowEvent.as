package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class CopyRowEvent extends CairngormEvent
	{
		public static var EVENT_ID:String = "copyRowEvent";
		
		public function CopyRowEvent()
		{
			super(EVENT_ID);
		}
	}
}
