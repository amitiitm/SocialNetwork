package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class QuickDetailUpdateSaveRecordEvent extends CairngormEvent
	{
		public static var EVENT_ID:String = "quickDetailUpdateSaveRecordEvent";
		
		public function QuickDetailUpdateSaveRecordEvent()
		{
			super(EVENT_ID);
		}
	}
}
