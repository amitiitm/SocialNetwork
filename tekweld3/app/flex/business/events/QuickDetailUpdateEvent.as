package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class QuickDetailUpdateEvent extends CairngormEvent
	{
		public static var EVENT_ID:String = "quickDetailUpdateEvent";
		public var callbacks:IResponder;
		public var masterName:String;

		public function QuickDetailUpdateEvent(masterName:String, callbacks:IResponder=null)
		{
			super(EVENT_ID);
			this.masterName = masterName;
		}
	}
}
