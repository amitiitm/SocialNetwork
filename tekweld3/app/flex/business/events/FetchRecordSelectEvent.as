package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.rpc.IResponder;

	public class FetchRecordSelectEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "fetchRecordSelectEvent";
		public var callbacks:IResponder;
		public var allFetchRows:XML;

		
		public function FetchRecordSelectEvent(allFetchRows:XML)
		{
			super(EVENT_ID);
			this.allFetchRows		=	allFetchRows;
		}
	}
}

