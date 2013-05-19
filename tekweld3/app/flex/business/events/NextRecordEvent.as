package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class NextRecordEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "nextRecordEvent";
		
		public function NextRecordEvent()
		{
			super(EVENT_ID);
		}
	}
}
