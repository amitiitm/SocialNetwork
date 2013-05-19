package com.generic.events
{
	import flash.events.Event;

	public class GenTextInputEvent extends Event
	{
		public static const ITEMCHANGED_EVENT:String = "itemChangedEvent";

		public function GenTextInputEvent(type:String)
		{
			super(type, true);
		}

		override public function clone():Event
		{
			return new GenTextInputEvent(type)
        }  
	}
}
