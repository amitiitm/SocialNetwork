package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class CloseAddEditViewEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "closeAddEditViewEvent";
	
		public function CloseAddEditViewEvent()
		{
			super(EVENT_ID);
		}
	}
}
