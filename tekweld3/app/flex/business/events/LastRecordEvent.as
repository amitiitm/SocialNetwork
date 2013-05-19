package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;
	
	public class LastRecordEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "lastRecordEvent";
		
		public function LastRecordEvent()
		{
			super(EVENT_ID);
		}
	}
}