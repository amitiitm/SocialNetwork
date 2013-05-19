package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class ExportEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "exportEvent";
	
		public function ExportEvent()
		{
			super(EVENT_ID);
		}
	}
}
