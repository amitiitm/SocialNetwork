package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class NextRowEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "nextRowEvent";
		 
		public function NextRowEvent()
		{
			super(EVENT_ID);
		}
	}
}
