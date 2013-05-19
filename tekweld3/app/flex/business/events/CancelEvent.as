package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.controls.Alert;

	public class CancelEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "cancelEvent";
		 
		public function CancelEvent()
		{
			super(EVENT_ID);
		}
	}
}
