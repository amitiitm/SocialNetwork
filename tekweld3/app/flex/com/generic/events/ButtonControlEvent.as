package com.generic.events
{
	import flash.events.Event;
	import mx.controls.Alert;
	
	public class ButtonControlEvent extends Event
	{
		public static const ADD_ROW_EVENT:String = "addRowEvent";
		public static const PRINT_ROW_EVENT:String = "printRowEvent";
		public static const SAVE_ROW_EVENT:String = "saveRowEvent";
		public static const FIRST_ROW_EVENT:String = "firstRowEvent";
		public static const NEXT_ROW_EVENT:String = "nextRowEvent";
		public static const PREVIOUS_ROW_EVENT:String = "previousRowEvent";
		public static const LAST_ROW_EVENT:String = "lastRowEvent";
		public static const REFRESH_ROW_EVENT:String = "refreshRowEvent";
		
		public static const NOTES_EVENT:String = "notesEvent";
		public static const ATTACHMENTS_EVENT:String = "attachmentsEvent";
		
		public function ButtonControlEvent(type:String)
		{
			super(type, true);
		}
		
		override public function clone():Event
		{
			return new ButtonControlEvent(type)
        }  
	}
}