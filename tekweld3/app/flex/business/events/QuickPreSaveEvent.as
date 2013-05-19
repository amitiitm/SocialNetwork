package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class QuickPreSaveEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "quickPreSaveEvent";
		
		public function QuickPreSaveEvent()
		{
			super(EVENT_ID);
		}
	}
}
