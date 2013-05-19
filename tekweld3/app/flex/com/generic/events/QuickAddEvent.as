package com.generic.events
{
	import flash.events.Event;

	public class QuickAddEvent extends AddEditEvent
	{
		public static const QUICK_PRE_SAVE_EVENT:String = "quickPreSaveEvent";
		
		public function QuickAddEvent(type:String)
		{
			super(type, new XML());
		}

		override public function clone():Event
		{
			return new QuickAddEvent(type)
        }
	}
}


