package com.generic.events
{
	import flash.events.Event;

	public class GenDynamicComboBoxEvent extends Event
	{
		public static const ITEMCHANGED_EVENT:String = "itemChangedEvent";

		public function GenDynamicComboBoxEvent(type:String)
		{
			super(type, true);
		}

		override public function clone():Event
		{
			return new GenDynamicComboBoxEvent(type)
        }  
	}
}
