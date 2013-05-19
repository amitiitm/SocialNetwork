package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;
	import valueObjects.DetailEditVO;

	public class DetailEditEvent extends CairngormEvent
	{
		public static var EVENT_ID:String = "detailRowEvent";
		public var callbacks:IResponder;

		public function DetailEditEvent(callbacks:IResponder=null)
		{
			super(EVENT_ID);
		}
	}
}

