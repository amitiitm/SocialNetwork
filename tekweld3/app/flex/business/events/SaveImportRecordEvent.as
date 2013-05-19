package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class SaveImportRecordEvent extends CairngormEvent
	{
		public static var EVENT_ID:String = "saveImportRecordEvent";
		
		public function SaveImportRecordEvent()
		{
			super(EVENT_ID);
		}
	}
}

