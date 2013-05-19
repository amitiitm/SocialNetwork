package com.generic.events
{
	import flash.events.Event;

	public class GenDateFieldEvent extends Event
	{
		public static const ITEMCHANGED_EVENT:String = "itemChangedEvent";

		public function GenDateFieldEvent(type:String)
		{
			super(type, true);
		}

		override public function clone():Event
		{
			return new GenDateFieldEvent(type)
        }  
	}
}
