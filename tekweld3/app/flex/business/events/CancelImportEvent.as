package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.controls.Alert;

	public class CancelImportEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "cancelImportEvent";
		 
		public function CancelImportEvent()
		{
			super(EVENT_ID);
		}
	}
}


