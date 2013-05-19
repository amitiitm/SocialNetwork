package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;
	
	public class SortEvent extends CairngormEvent
	{
		public static var EVENT_ID:String = "sortEvent";
		
		public function SortEvent()
		{
			super(EVENT_ID);
		}
	}
}