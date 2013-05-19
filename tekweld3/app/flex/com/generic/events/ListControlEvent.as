package com.generic.events
{
	import flash.events.Event;
	
	public class ListControlEvent extends Event
	{
 	 	
 		public static const ITEM_CLICK_EVENT:String = "itemClickEvent";
 		public static const ITEM_DOUBLE_CLICK_EVENT:String = "itemDoubleClickEvent";
		
		public function ListControlEvent(type:String)
		{
			super(type,true);
		}

		override public function clone():Event
		{
			return new ListControlEvent(type)  
        }

		
	}
}


//   ??????????????????????????? required
 