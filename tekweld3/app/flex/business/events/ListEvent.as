package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class ListEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "listEvent";
	
		public function ListEvent()
		{
			super(EVENT_ID);
		}
	}
}
