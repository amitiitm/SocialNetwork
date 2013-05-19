package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class QueryEvent extends CairngormEvent
	{
		public static var EVENT_ID:String = "queryEvent";
		
		public function QueryEvent()
		{
			super(EVENT_ID);
		}
	}
}
