package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.rpc.IResponder;

	public class RecordStatusEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "recordStatusEvent";
		public var callbacks:IResponder;
		public var status:String;
		
		public function RecordStatusEvent(status:String, callbacks:IResponder=null)
		{
			super(EVENT_ID);
			this.status = status;
			this.callbacks = callbacks;
		}
	}
}
