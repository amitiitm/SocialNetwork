package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class ForgotPasswordEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "forgotPasswordEvent";
		public var userXML:XML;
		public var callbacks:IResponder;
		
		public function ForgotPasswordEvent(userXML:XML, callbacks:IResponder=null)
		{
			super(EVENT_ID);
			this.callbacks = callbacks;
			this.userXML = userXML;
		}
	}
}
