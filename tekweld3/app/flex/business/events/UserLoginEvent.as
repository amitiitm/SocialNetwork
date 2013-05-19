package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;
	import valueObjects.LoginVO;

	public class UserLoginEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "loginEvent";
		public var loginObj:LoginVO;
		public var callbacks:IResponder;
		
		public function UserLoginEvent(loginObj:LoginVO, callbacks:IResponder=null)
		{
			super(EVENT_ID);
			this.loginObj = loginObj;
			this.callbacks = callbacks;
		}
	}	
}
