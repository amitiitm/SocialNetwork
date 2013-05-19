package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class PrintDataInSpecificFormatEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "printDataInSpecificFormatEvent";
		public var dataType:String;
		
		public function PrintDataInSpecificFormatEvent(dataType:String = "")
		{
			super(EVENT_ID);
			this.dataType	=	dataType;
		}
	}
}
