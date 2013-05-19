package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.rpc.IResponder;

	public class GetRecordEvent extends CairngormEvent
	{
		static public var EVENT_ID:String="getRecordEvent";
		public var callbacks:IResponder;
		public var recordId:int;
		public var isOpenViewOnlyMode:Boolean;
		
		public function GetRecordEvent(recordId:int, callbacks:IResponder=null , isOpenViewOnlyMode:Boolean = false)
		{
			super(EVENT_ID);
			this.recordId = recordId;
			this.callbacks = callbacks;
			this.isOpenViewOnlyMode	=	isOpenViewOnlyMode;
		}
	}
}
