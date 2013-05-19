package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class FetchRecordsEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "fetchRecordsEvent";
	
		public function FetchRecordsEvent()
		{
			super(EVENT_ID);
		}
	}
}
