package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;

	public class GetInformationEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "getInformation";
		public var callbacks:IResponder;

		public var value1:Object;
		public var value2:Object;
		public var value3:Object;
		public var value4:Object;
		public var value5:Object;
		public var value6:Object;
		public var value7:Object;
		public var value8:Object;
		public var value9:Object;
		public var value10:Object;
		public var action:String
		
		public function GetInformationEvent(action:String, callbacks:IResponder, value1:Object=null, value2:Object=null, value3:Object=null, value4:Object=null, value5:Object=null, value6:Object=null,value7:Object=null, value8:Object=null, value9:Object=null, value10:Object=null)
		{
			super(EVENT_ID);
			
			this.callbacks 	=	callbacks;
			this.action		=	action;
				
			this.value1		=	value1;
			this.value2		=	value2;
			this.value3		=	value3;
			this.value4		=	value4;
			this.value5		=	value5;
			this.value6		=	value6;
			this.value7		=	value7;
			this.value8		=	value8;
			this.value9		=	value9;
			this.value10	=	value10;
		}
	}
}

