package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class InitializeApplicationEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "initializeAppEvent";
		public var callbacks:IResponder;

		public function InitializeApplicationEvent(callbacks:IResponder=null)
		{
			super(EVENT_ID);
			this.callbacks = callbacks;
		}
	}
}