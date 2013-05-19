package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class SortOrderSelectionChangingEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "sortOrderChangingEvent";
		public var callbacks:IResponder;
		
		public function SortOrderSelectionChangingEvent(callbacks:IResponder=null)
		{
			super(EVENT_ID);
			this.callbacks = callbacks;
		}
	}	
}
