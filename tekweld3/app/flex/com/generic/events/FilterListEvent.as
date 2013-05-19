package com.generic.events
{
	import flash.events.Event;
	import mx.controls.Tree;
	import mx.controls.Alert;
	
	public class FilterListEvent extends Event
	{
		public static const FILTER_LIST_EVENT:String = "filterListEvent";

		public function FilterListEvent(type:String)
		{
			super(type, true);
		}

		override public function clone():Event
		{
			return new FilterListEvent(type)  
        }  
	}
}
