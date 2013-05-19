package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class QueryOKEvent extends CairngormEvent
	{
		public static var EVENT_ID:String = "queryOKEvent";
		public var selectedView:XML;
		public var isRunImmediately:Boolean
		
		public function QueryOKEvent(selectedView:XML, isRunImmediately:Boolean)
		{
			super(EVENT_ID);
			this.selectedView		=	selectedView;
			this.isRunImmediately	=	isRunImmediately;
		}
	}
}