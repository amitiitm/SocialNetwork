package com.generic.events
{
	import flash.events.Event;

	public class LookupRecordSearchEvent extends Event
	{
		public static const REFRESHCOMPLETE_EVENT:String = "refreshLookCompleteEvent";
		public static const REFRESH_EVENT:String = "refreshLookupEvent";
		public static const LOOKUPCLOSE_EVENT:String = "lookupCloseEvent";
		
		public function LookupRecordSearchEvent(type:String)
		{
			super(type, true);
		}

		override public function clone():Event
		{
			return new LookupRecordSearchEvent(type)
        }
	}
}
