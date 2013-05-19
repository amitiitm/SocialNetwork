package saoi.muduleclasses.event
{
	import flash.events.Event;

	public class MissingInfoEvent extends Event
	{
		public var xml:XML = new XML();
		public static const MissingInfoEvent_Type:String = "MissingInfoEventType";
		public function MissingInfoEvent(type:String,value:XML=null )
		{
			super(type);
			this.xml	=	value;
		}
		override public function clone():Event
		{
			return new MissingInfoEvent(type);
        }
	}
}