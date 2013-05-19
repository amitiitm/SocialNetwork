package com.generic.events
{
	import com.generic.components.*;
	import com.generic.customcomponents.*;
	import flash.events.Event;
	import mx.controls.*;

	public class NewGenDataGridEvent extends Event
	{
		public static const ITEM_CLICK_EVENT:String = "itemClickGenGridEvent";
		public static const ITEM_DOUBLE_CLICK_EVENT:String = "itemDoubleClickGenGridEvent";
		
		public function NewGenDataGridEvent(type:String)
		{
			super(type,true);
		}
		
		override public function clone():Event
		{
			return new NewGenDataGridEvent(type);
  		}
	}
}
