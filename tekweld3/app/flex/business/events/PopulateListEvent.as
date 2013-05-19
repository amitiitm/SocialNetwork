package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class PopulateListEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "populateListEvent";
		public var selectedView:XML	;
		public var callbacks:IResponder;
		
		public function PopulateListEvent(selectedView:XML=null, callbacks:IResponder=null)
		{
			super(EVENT_ID);
			
			this.callbacks = callbacks;
			this.selectedView = selectedView;
		}
	}
}
