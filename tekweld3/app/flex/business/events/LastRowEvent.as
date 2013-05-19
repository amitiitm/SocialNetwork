package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class LastRowEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "lastRowEvent";
		 
		public function LastRowEvent()
		{
			super(EVENT_ID);
		}
	}
}
