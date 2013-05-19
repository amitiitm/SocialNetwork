package com.generic.events
{
	import com.generic.components.*;
	import com.generic.customcomponents.*;
	import flash.events.Event;
	import mx.controls.*;

	public class GenDataGridEvent extends Event
	{
		public static const ITEM_CLICK_EVENT:String = "itemClickGenGridEvent";
		public static const ITEM_DOUBLE_CLICK_EVENT:String = "itemDoubleClickGenGridEvent";
		public static const STRUCTURE_COMPLETE_EVENT:String = "structureCompleteEvent";
		
		public function GenDataGridEvent(type:String)
		{
			super(type,true);
		}
		
		override public function clone():Event
		{
			return new GenDataGridEvent(type);
        }  
	} 
 }
