package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class SaveRowEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "saveRowEvent";

		public function SaveRowEvent()
		{
			super(EVENT_ID);
		}
	}
}
