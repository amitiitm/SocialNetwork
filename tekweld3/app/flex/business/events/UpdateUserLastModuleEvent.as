package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.controls.Alert;

	public class UpdateUserLastModuleEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "updateUserLastModule";
		public var module_id:int;
		
		public function UpdateUserLastModuleEvent(aModule_id:int)
		{
			super(EVENT_ID);
			this.module_id = aModule_id;
		}
	}
}
