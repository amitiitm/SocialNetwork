package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;
	import valueObjects.DetailEditVO;

	public class DetailImportEvent extends CairngormEvent
	{
		public static var EVENT_ID:String = "detailImportEvent";
		public var callbacks:IResponder;

		public function DetailImportEvent(callbacks:IResponder=null)
		{
			super(EVENT_ID);
		}
	}
}
