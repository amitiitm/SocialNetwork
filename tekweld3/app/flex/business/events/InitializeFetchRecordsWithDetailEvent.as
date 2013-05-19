package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.customcomponents.GenDataGrid;
	import mx.rpc.IResponder;
	
	public class InitializeFetchRecordsWithDetailEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "initializeFetchRecordsWithDetailEvent";
		public var genDataGrid:GenDataGrid;
		public var callbacks:IResponder;
		
		public function InitializeFetchRecordsWithDetailEvent(genDataGrid:GenDataGrid , callbacks:IResponder=null)
		{
			super(EVENT_ID);
			this.genDataGrid		=	genDataGrid;
			this.callbacks = callbacks;
		}
	}
}