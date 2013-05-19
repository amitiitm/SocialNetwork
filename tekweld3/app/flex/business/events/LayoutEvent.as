package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class LayoutEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "layoutEvent";
		
		public function LayoutEvent()
		{
			super(EVENT_ID);
		}
	}
}
