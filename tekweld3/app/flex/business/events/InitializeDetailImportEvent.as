package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class InitializeDetailImportEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "initializeDetailImportEvent";
		public var callbacks:IResponder;

		public function InitializeDetailImportEvent(callbacks:IResponder=null)
		{
			super(EVENT_ID);
			this.callbacks = callbacks;
		}
	}
}

