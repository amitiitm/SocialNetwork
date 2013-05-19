package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class InitializeLayoutEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "initializeLayoutEvent";
		
		public var changeStackIndex:Boolean = true;
		 
		public function InitializeLayoutEvent()
		{
			super(EVENT_ID);
		}
	}
}
