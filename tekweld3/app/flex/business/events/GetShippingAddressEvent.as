package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class GetShippingAddressEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "getShippingAddress";
		public var callbacks:IResponder;
		public var ship_id:String; 
		
		public function GetShippingAddressEvent(ship_id:String , callbacks:IResponder=null)
		{
			super(EVENT_ID);
			this.callbacks 	= callbacks;
			this.ship_id	=	ship_id;
		}
	}
}
