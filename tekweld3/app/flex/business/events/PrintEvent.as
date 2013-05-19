package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class PrintEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "printEvent";
		public var callbacks:IResponder = null;
		public var printInExcel:String = "N";

		public function PrintEvent(printInExcel:String = "N")
		{
			super(EVENT_ID);
			this.printInExcel	=	printInExcel;
		}
	}
}
