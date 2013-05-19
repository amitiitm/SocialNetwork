package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.rpc.IResponder;
	
	public class SaveNoteEvent extends CairngormEvent
	{
		static public var EVENT_ID:String="saveNoteEvent";
		public var callbacks : IResponder	=	null;
		public var notesXml : XML	=	null;
		
		public function SaveNoteEvent(notesXml:XML ,callbacks:IResponder=null)
		{
			super(EVENT_ID);
			this.notesXml	=	notesXml;
			this.callbacks	=	callbacks;
		}
	}
}

