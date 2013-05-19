package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class DetailEditCloseEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "detailEditCloseEvent";
		
		public function DetailEditCloseEvent()
		{
			super(EVENT_ID);
		}
	}
}
