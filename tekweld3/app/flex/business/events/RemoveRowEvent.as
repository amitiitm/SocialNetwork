package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;
	
	public class RemoveRowEvent extends CairngormEvent
	{
		public static var EVENT_ID:String = "removeRowEvent";
		
		public function RemoveRowEvent()
		{
			super(EVENT_ID);
		}
	}
}
