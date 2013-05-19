package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class RowStatusEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "rowStatusEvent";
		public var callbacks:IResponder;
		public var status:String;
		
		public function RowStatusEvent(status:String, callbacks:IResponder=null)
		{
			super(EVENT_ID);
			this.status = status;
			this.callbacks = callbacks;
		}
	}
}

