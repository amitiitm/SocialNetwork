package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.components.DataEntry;
	import mx.controls.Alert;
	import mx.core.Container;
	import mx.rpc.IResponder;

	public class InitializeCustomReportEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "initializeCustomReportEvent";
		public var callbacks:IResponder;
		
		public function InitializeCustomReportEvent(callbacks:IResponder=null)
		{
			super(EVENT_ID);
			this.callbacks = callbacks;
		}
	}
}

