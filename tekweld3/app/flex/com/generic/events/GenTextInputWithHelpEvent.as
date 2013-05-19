package com.generic.events
{
	import flash.events.Event;
	
	public class GenTextInputWithHelpEvent extends Event
	{
		public static const ITEMCHANGED_EVENT:String = "itemChangedEvent";
		
		public function GenTextInputWithHelpEvent(type:String)
		{
			super(type, true);
		}
		override public function clone():Event
		{
			return new GenTextInputWithHelpEvent(type)
        } 

	}
}