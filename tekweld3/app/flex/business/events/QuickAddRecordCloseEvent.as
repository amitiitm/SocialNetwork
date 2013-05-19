package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class QuickAddRecordCloseEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "quickAddRecordCloseEvent";
		
		public function QuickAddRecordCloseEvent()
		{
			super(EVENT_ID);
		}
	}
}