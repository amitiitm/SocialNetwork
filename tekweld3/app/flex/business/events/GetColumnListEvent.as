package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;
	
	public class GetColumnListEvent extends CairngormEvent
	{
		static public var EVENT_ID:String="getColumnListEvent";
		public var callbacks : IResponder	=	null;
		
		public function GetColumnListEvent(callbacks:IResponder=null)
		{
			super(EVENT_ID);
			this.callbacks	=	callbacks;
		}
	}
}

