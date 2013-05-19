package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;
	import mx.controls.Alert;

	public class GetAttachmentEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "getAttachmentEvent";
		public var callbacks : IResponder	=	null;
		
		public function GetAttachmentEvent(callbacks:IResponder=null)
		{
			super(EVENT_ID);
			this.callbacks	=	callbacks;
		}
	}
}
