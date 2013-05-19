package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class ConfigureColumnOKEvent extends CairngormEvent
	{
		public static var EVENT_ID:String = "configureColumnOKEvent";
		public var selectedLayout:XML;
		public var isRunImmediately:Boolean
		
		public function ConfigureColumnOKEvent(selectedLayout:XML, isRunImmediately:Boolean)
		{
			super(EVENT_ID);
			this.selectedLayout		=	selectedLayout;
			this.isRunImmediately	=	isRunImmediately;
		}
	}
}

