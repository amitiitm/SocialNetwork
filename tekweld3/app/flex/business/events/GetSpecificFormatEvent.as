package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.rpc.IResponder;

	public class GetSpecificFormatEvent extends CairngormEvent
	{
		static public var EVENT_ID:String="getSpecificFormatEvent";
		
		public function GetSpecificFormatEvent()
		{
			super(EVENT_ID);
		}
	}
}
