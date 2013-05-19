package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class InsertRowEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "insertRowEvent";

		public function InsertRowEvent()
		{
			super(EVENT_ID);
		}
	}
}
