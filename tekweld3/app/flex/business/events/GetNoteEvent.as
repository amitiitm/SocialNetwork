package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;
	
	public class GetNoteEvent extends CairngormEvent
	{
		static public var EVENT_ID:String="getNoteEvent";
		public var callbacks : IResponder	=	null;
		
		public function GetNoteEvent(callbacks:IResponder=null)
		{
			super(EVENT_ID);
			this.callbacks	=	callbacks;
		}
	}
}
