package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class PreviousRowEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "previousRowEvent";
		 
		public function PreviousRowEvent()
		{
			super(EVENT_ID);
		}
	}
}
