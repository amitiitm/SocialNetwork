package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.rpc.IResponder;

	public class DrillDownEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "drilldownEvent";
		public var callbacks:IResponder;
		
		public function DrillDownEvent(callbacks:IResponder=null)
		{
			super(EVENT_ID);
			this.callbacks 		= 	callbacks;
		}
	}
}
