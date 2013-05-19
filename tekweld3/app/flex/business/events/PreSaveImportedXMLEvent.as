package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class PreSaveImportedXMLEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "preSaveImportedXMLEvent";
		
		public function PreSaveImportedXMLEvent()
		{
			super(EVENT_ID);
		}
	}
}


