package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class PreSaveRowEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "preSaveRowEvent";
		
		public function PreSaveRowEvent()
		{
			super(EVENT_ID);
		}
	}
}
