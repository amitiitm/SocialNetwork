package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class QuickDetailUpdateCloseEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "quickDetailUpdateCloseEvent";
		
		public function QuickDetailUpdateCloseEvent()
		{
			super(EVENT_ID);
		}
	}
}