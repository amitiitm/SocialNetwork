package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class InitializeDetailEditEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "initializeDetailEditEvent";
		public var callbacks:IResponder;

		public function InitializeDetailEditEvent(callbacks:IResponder=null)
		{
			super(EVENT_ID);
			this.callbacks = callbacks;
		}
	}
}
