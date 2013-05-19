package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class LoginPwdChangeEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "loginPwdChangeEvent";
		public var userXML:XML;
		public var callbacks:IResponder;
		
		public function LoginPwdChangeEvent(userXML:XML, callbacks:IResponder=null)
		{
			super(EVENT_ID);
			this.callbacks = callbacks;
			this.userXML = userXML;
		}
	}
}
