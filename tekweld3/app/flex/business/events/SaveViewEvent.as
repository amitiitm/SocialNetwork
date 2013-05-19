package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class SaveViewEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "saveViewEvent";
		public var view:XML;
		
		public function SaveViewEvent(view:XML)
		{
			super(EVENT_ID);
			this.view = view;
		}
	}
}
