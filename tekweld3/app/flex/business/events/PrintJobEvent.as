package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class PrintJobEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "printJobEvent";
		public var callbacks:IResponder = null;

		public function PrintJobEvent()
		{
			super(EVENT_ID);
		}
	}
}
