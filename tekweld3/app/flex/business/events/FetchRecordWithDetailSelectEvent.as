package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.rpc.IResponder;

	public class FetchRecordWithDetailSelectEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "fetchRecordWithDetailSelectEvent";
		public var callbacks:IResponder;
		public var allFetchRows:XML;

		
		public function FetchRecordWithDetailSelectEvent(allFetchRows:XML)
		{
			super(EVENT_ID);
			this.allFetchRows		=	allFetchRows;
		}
	}
}
