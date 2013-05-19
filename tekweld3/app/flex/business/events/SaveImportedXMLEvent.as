package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class SaveImportedXMLEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "saveImportedXMLEvent";
		
		public function SaveImportedXMLEvent()
		{
			super(EVENT_ID);
		}
	}
}

