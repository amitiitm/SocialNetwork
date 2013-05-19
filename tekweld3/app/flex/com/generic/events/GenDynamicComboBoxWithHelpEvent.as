package com.generic.events
{
	import flash.events.Event;

	public class GenDynamicComboBoxWithHelpEvent extends Event
	{
		public static const ITEMSELECTED_EVENT:String = "itemSelectedEvent";
		public static const REFRESHCOMPLETE_EVENT:String = "refreshCompleteEvent";
		public static const REFRESH_EVENT:String = "refreshEvent";
		
		public function GenDynamicComboBoxWithHelpEvent(type:String)
		{
			super(type, true);
		}

		override public function clone():Event
		{
			return new GenDynamicComboBoxWithHelpEvent(type)
        }
	}
}
