package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class FirstRowEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "firstRowEvent";
		 
		public function FirstRowEvent()
		{
			super(EVENT_ID);
		}
	}
}