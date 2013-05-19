package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.components.DataEntry;
	import mx.controls.Alert;
	import mx.core.Container;
	import mx.rpc.IResponder;

	public class InitializeDataEntryEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "initializeDataEntryEvent";
		public var callbacks:IResponder;
		
		public function InitializeDataEntryEvent(callbacks:IResponder=null)
		{
			super(EVENT_ID);
			this.callbacks = callbacks;
		}
	}
}
