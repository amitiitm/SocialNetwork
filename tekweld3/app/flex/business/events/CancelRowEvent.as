package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class CancelRowEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "cancelRowEvent";
		
		public function CancelRowEvent()
		{
			super(EVENT_ID);
		}
	}
}
