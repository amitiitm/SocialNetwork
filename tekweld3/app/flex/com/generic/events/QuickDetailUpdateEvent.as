package com.generic.events
{
	import flash.events.Event;

	public class QuickDetailUpdateEvent extends AddEditEvent
	{
		public static const QUICK_DETAIL_UPDATE_PRE_SAVE_EVENT:String = "quickDetailUpdatePreSaveEvent";
		
		public function QuickDetailUpdateEvent(type:String)
		{
			super(type, new XML());
		}

		override public function clone():Event
		{
			return new QuickDetailUpdateEvent(type)
        }
	}
}


