package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class PrintRecordFromReportEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "printRecordFromReportEvent";
		public var callbacks:IResponder = null;
		public var printInExcel:String = "N";

		public function PrintRecordFromReportEvent(printInExcel:String = "N")
		{
			super(EVENT_ID);
			this.printInExcel	=	printInExcel;
		}
	}
}