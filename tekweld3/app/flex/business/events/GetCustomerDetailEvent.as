package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.rpc.IResponder;

	public class GetCustomerDetailEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "customerDetailEvent";
		public var callbacks:IResponder;
		public var cust_id:String;
		public var trans_type:String;
		
		public function GetCustomerDetailEvent(cust_id:String ,trans_type:String,  callbacks:IResponder=null)
		{
			super(EVENT_ID);
			this.callbacks 		= 	callbacks;
			this.cust_id		=	cust_id
			this.trans_type		=	trans_type
		}
	}
}

