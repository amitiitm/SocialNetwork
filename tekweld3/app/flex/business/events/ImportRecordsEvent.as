package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class ImportRecordsEvent extends CairngormEvent
	{
		public static var EVENT_ID:String = "importRecordsEvent";

		public function ImportRecordsEvent() 
		{
			super(EVENT_ID);
		}
	}
}

