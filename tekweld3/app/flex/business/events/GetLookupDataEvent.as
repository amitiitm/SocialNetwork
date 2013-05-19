package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class GetLookupDataEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "getLookupDataEvent";
		public var callbacks:IResponder;
		public var lookupName:String;

		public function GetLookupDataEvent(aLookupName:String, callbacks:IResponder=null)
		{
			super(EVENT_ID);
			this.lookupName = aLookupName;
			this.callbacks = callbacks;
		}
	}
}
