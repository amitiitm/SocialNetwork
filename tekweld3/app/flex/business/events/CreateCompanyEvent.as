package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class CreateCompanyEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "createCompanyEvent";
		public var companyXML:XML;
		public var callbacks:IResponder;
		
		public function CreateCompanyEvent(companyXML:XML, callbacks:IResponder=null)
		{
			super(EVENT_ID);
			this.callbacks = callbacks;
			this.companyXML = companyXML;
		}
	}
}
