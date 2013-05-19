package com.generic.events
{
	import flash.events.Event;

	public class GenComboBoxEvent extends Event
	{
		public static const ITEMCHANGED_EVENT:String = "itemChangedEvent";

		public function GenComboBoxEvent(type:String)
		{
			super(type, true);
		}

		override public function clone():Event
		{
			return new GenComboBoxEvent(type)
        }  
	}
}
