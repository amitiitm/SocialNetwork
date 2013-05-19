package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class SaveRecordEvent extends CairngormEvent
	{
		public static var EVENT_ID:String = "saveRecordEvent";
		
		public function SaveRecordEvent()
		{
			super(EVENT_ID);
		}
	}
}
