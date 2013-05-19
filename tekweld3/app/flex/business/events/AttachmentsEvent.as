package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class AttachmentsEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "attachmentsEvent";

		public function AttachmentsEvent(callbacks:IResponder=null)
		{
			super(EVENT_ID);
		}
	}
}
