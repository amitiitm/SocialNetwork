package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;
	
	public class ConfigureColumnEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "configureColumnEvent";
		
		public function ConfigureColumnEvent()
		{
			super(EVENT_ID);
		}
	}
}
