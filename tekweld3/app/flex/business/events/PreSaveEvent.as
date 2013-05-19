package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class PreSaveEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "preSaveEvent";
		
		public function PreSaveEvent()
		{
			super(EVENT_ID);
		}
	}
}