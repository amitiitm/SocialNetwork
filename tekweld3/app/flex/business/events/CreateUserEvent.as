package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.rpc.IResponder;

	public class CreateUserEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "createUserEvent";
		public var userXML:XML;
		public var callbacks:IResponder;
		
		public function CreateUserEvent(userXML:XML, callbacks:IResponder=null)
		{
			super(EVENT_ID);
			this.callbacks = callbacks;
			this.userXML = userXML;
		}
	}
}
