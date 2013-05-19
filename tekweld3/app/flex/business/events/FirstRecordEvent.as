package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class FirstRecordEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "firstRecordEvent";
		 
		public function FirstRecordEvent()
		{
			super(EVENT_ID);
		}
	}
}