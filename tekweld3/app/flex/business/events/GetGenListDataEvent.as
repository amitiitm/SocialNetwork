package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.customcomponents.GenList;
	import mx.rpc.IResponder;

	public class GetGenListDataEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "getGenListData";
		public var callbacks:IResponder;
		public var genList:GenList;
	
		public function GetGenListDataEvent(genList:GenList, callbacks:IResponder=null)
		{
			super(EVENT_ID);
			this.genList = genList;
			this.callbacks = callbacks;
		}
	}
}
