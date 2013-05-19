package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class InitializeImportEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "initializeImportEvent";
		
		public var changeStackIndex:Boolean = true;
		 
		public function InitializeImportEvent()
		{
			super(EVENT_ID);
		}
	}
}

