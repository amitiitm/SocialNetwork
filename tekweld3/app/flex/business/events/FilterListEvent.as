package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class FilterListEvent extends CairngormEvent
	{
		static public var EVENT_ID:String="filterListEvent";
		public var ary:Array;
		public var callbacks:IResponder;
		
		public function FilterListEvent(ary:Array, callbacks:IResponder=null)
		{
			super(EVENT_ID);
			this.ary = ary;
			this.callbacks = callbacks;
		}
	}	
}
