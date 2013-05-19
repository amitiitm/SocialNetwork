package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.rpc.IResponder;

	public class QuickAddEvent extends CairngormEvent
	{
		public static var EVENT_ID:String = "quickAddEvent";
		public var callbacks:IResponder;
		public var selectedRow:XML = null;;

		public function QuickAddEvent( selectedRow:XML = null ,callbacks:IResponder=null )
		{
			super(EVENT_ID);
			this.callbacks		=	callbacks;
			this.selectedRow	=	selectedRow;
		}
	}
}



