package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class InitializeViewEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "initializeViewEvent";
		
		public var changeStackIndex:Boolean = true;
		 
		public function InitializeViewEvent()
		{
			super(EVENT_ID);
		}
	}
}
