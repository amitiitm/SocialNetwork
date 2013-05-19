package com.generic.events
{
	import com.generic.components.*;
	import com.generic.customcomponents.*;
	import flash.events.Event;
	import mx.controls.*;

	public class CustomReportEvent extends Event
	{
		public static const ITEM_CLICK_EVENT:String = "itemClickCustomReportEvent";
		public static const ITEM_DOUBLE_CLICK_EVENT:String = "itemDoubleClickCustomReportEvent";
		public static const STRUCTURE_COMPLETE_EVENT:String = "structureCompleteEvent";
		
		public function CustomReportEvent(type:String)
		{
			super(type,true);
		}
		
		override public function clone():Event
		{
			return new CustomReportEvent(type);
        }  
	} 
 }
