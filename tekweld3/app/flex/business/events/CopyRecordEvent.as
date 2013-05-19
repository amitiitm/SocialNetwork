package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class CopyRecordEvent extends CairngormEvent
	{
		public static var EVENT_ID:String = "copyRecordEvent";
		
		public function CopyRecordEvent()
		{
			super(EVENT_ID);
		}
	}
}
