package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.components.DataEntry;
	import mx.controls.Alert;
	import mx.core.Container;
	import mx.rpc.IResponder;

	public class InitializeQuickDetailUpdateEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "initializeQuickDetailUpdateEvent";
		public var callbacks:IResponder;
		
		public function InitializeQuickDetailUpdateEvent(callbacks:IResponder=null)
		{
			super(EVENT_ID);
			this.callbacks = callbacks;
		}
	}
}
