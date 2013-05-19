package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.rpc.IResponder;

	public class PrintRecordsEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "printRecordsEvent";
		public var callbacks:IResponder 	= null;
		public var printParameterXML:XML	=	null
		public function PrintRecordsEvent(printParameterXML:XML)
		{
			super(EVENT_ID);
			this.printParameterXML	=	printParameterXML;
		}
	}
}


