package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class QuickDetailUpdatePreSaveEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "quickDetailUpdatePreSaveEvent";
		
		public function QuickDetailUpdatePreSaveEvent()
		{
			super(EVENT_ID);
		}
	}
}
