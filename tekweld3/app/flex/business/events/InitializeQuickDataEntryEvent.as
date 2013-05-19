package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.components.DataEntry;
	import mx.controls.Alert;
	import mx.core.Container;
	import mx.rpc.IResponder;

	public class InitializeQuickDataEntryEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "initializeQuickDataEntryEvent";
		public var callbacks:IResponder;
		
		public function InitializeQuickDataEntryEvent(callbacks:IResponder=null)
		{
			super(EVENT_ID);
			this.callbacks = callbacks;
		}
	}
}
