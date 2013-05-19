package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class FetchRecordsWithDetailEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "fetchRecordsWithDetailEvent";
	
		public function FetchRecordsWithDetailEvent()
		{
			super(EVENT_ID);
		}
	}
}
