package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class PreSaveImportEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "preSaveImportEvent";
		
		public function PreSaveImportEvent()
		{
			super(EVENT_ID);
		}
	}
}

