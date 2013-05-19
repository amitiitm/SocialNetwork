package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class NotesEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "notesEvent";
		
		public function NotesEvent()
		{
			super(EVENT_ID);
		}
	}
}