package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class AddEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "addEvent";
		
		public var changeStackIndex:Boolean = true;
		 
		public function AddEvent(changeStackIndex:Boolean = true)
		{
			super(EVENT_ID);
			this.changeStackIndex	=	changeStackIndex;
		}
	}
}