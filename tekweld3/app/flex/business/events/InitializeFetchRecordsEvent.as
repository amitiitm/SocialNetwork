package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.customcomponents.GenDataGrid;
	import mx.rpc.IResponder;
	
	public class InitializeFetchRecordsEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "initializeFetchRecordsEvent";
		public var genDataGrid:GenDataGrid;
		public var callbacks:IResponder;
		
		public function InitializeFetchRecordsEvent(genDataGrid:GenDataGrid , callbacks:IResponder=null)
		{
			super(EVENT_ID);
			this.genDataGrid		=	genDataGrid;
			this.callbacks = callbacks;
		}
	}
}

