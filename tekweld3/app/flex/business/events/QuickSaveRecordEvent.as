package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class QuickSaveRecordEvent extends CairngormEvent
	{
		public static var EVENT_ID:String = "quickSaveRecordEvent";
		
		public function QuickSaveRecordEvent()
		{
			super(EVENT_ID);
		}
	}
}
