package com.generic.events
{
	import flash.events.Event;

	public class GenCheckBoxEvent extends Event
	{
		public static const ITEMCHANGED_EVENT:String = "itemChangedEvent";

		public function GenCheckBoxEvent(type:String)
		{
			super(type, true);
		}

		override public function clone():Event
		{
			return new GenCheckBoxEvent(type)
        }  
	}
}
