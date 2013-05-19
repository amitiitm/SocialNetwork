package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.customcomponents.GenDataGrid;
	import mx.rpc.IResponder;

	public class GetGenDataGridFormatEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "getGenDataGridFormat";
		public var callbacks:IResponder;
		public var object:Object;
	
		public function GetGenDataGridFormatEvent(object:Object, callbacks:IResponder=null)
		{
			super(EVENT_ID);
			this.object = object;
			this.callbacks = callbacks;
		}
	}
}

