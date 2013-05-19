package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class DetailImportCloseEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "detailImportCloseEvent";
		
		public function DetailImportCloseEvent()
		{
			super(EVENT_ID);
		}
	}
}
