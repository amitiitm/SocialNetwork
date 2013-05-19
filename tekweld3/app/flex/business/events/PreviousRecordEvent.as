package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;
		 
	public class PreviousRecordEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "previousRecordEvent";
		 
		public function PreviousRecordEvent()
		{
			super(EVENT_ID);
		}
	}
}