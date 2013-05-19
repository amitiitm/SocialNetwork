package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class ViewOnlyRecordEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "viewOnlyRecordEvent";
	
		public function ViewOnlyRecordEvent()
		{
			super(EVENT_ID);
		}
	}
}
