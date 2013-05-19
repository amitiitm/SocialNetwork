package com.generic.events
{
	import flash.events.Event;

	public class FetchRecordEvent extends Event
	{
		public static const SELECTCOMPLETE_EVENT:String = "selectcompleteevent";
		public static const FETCHWINDOWCANCEL_EVENT:String = "fetchwindowcloseevent";

		public function FetchRecordEvent(type:String)
		{
			super(type, true);
		}

		override public function clone():Event
		{
			return new FetchRecordEvent(type)
        }  
	}
}
