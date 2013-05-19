package com.generic.events
{
	import flash.events.Event;
	import mx.controls.Alert;
	
	public class ButtonControlDetailEvent extends Event
	{
		public static const EDIT_ROW_EVENT:String 		= "editRowEvent";
		public static const REMOVE_ROW_EVENT:String 	= "removeRowEvent";
		public static const FETCH_RECORDS_EVENT:String 	= "fetchRecordsEvent";
		public static const IMPORT_EVENT:String 		= "importEvent";
		public static const FETCH_RECORDS_WITH_DETAIL_EVENT:String 	= "fetchRecordsWithDetailEvent";
		
		public function ButtonControlDetailEvent(type:String)
		{
			super(type, true);
		}
		
		override public function clone():Event
		{
			return new ButtonControlDetailEvent(type)
        }  
	}
}