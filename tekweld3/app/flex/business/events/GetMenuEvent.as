package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class GetMenuEvent extends CairngormEvent
	{
		static public var EVENT_ID:String="menuEvent";
		public var callbacks:IResponder;
		public var module_id:int ;
		
		public function GetMenuEvent(module_id:int, callbacks:IResponder=null)
		{
			super(EVENT_ID);
			this.module_id = module_id;
			this.callbacks = callbacks;
		}
	}
}
