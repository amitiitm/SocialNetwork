package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.rpc.IResponder;

	public class InboxDrillDownEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "inboxdrilldownEvent";
		public var callbacks:IResponder;
		
		public function InboxDrillDownEvent(callbacks:IResponder=null)
		{
			super(EVENT_ID);
			this.callbacks 		= 	callbacks;
		}
	}
}
