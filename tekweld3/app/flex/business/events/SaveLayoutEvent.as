package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class SaveLayoutEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "saveLayoutEvent";
		public var layout:XML;
		
		public function SaveLayoutEvent(layout:XML)
		{
			super(EVENT_ID);
			this.layout = layout;
		}
	}
}

