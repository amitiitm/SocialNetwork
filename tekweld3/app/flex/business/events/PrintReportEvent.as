package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class PrintReportEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "printReportEvent";
		public var callbacks:IResponder = null;

		public function PrintReportEvent()
		{
			super(EVENT_ID);
		}
	}
}

