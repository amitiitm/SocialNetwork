package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class InitializeLookupEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "initializeLookupEvent";
		public var callbacks:IResponder;

		public function InitializeLookupEvent(callbacks:IResponder=null) 
		{
			super(EVENT_ID);
			this.callbacks = callbacks;
		}
	}
}
