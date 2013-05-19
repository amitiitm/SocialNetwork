package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class PreSaveCustomEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "preSaveCustomEvent";
		public var buttonName:String;

		public function PreSaveCustomEvent(buttonName:String)
		{
			super(EVENT_ID);
			this.buttonName = buttonName;
		}
	}
}
