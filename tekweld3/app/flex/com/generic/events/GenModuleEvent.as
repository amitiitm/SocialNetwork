package com.generic.events
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;

	public class GenModuleEvent extends Event
	{
		public static const ACTIVE_EVENT:String = "genModuleActive";
		public static const SHORTCUTKEY_EVENT:String = "genModuleShortcutKey";
		
		public var keyBoardEvent:KeyboardEvent;
		
		public function GenModuleEvent(type:String , keyBoardEvent:KeyboardEvent = null)
		{
			super(type, true);
			this.keyBoardEvent	=	keyBoardEvent
		}
		
		override public function clone():Event
		{
			return new GenModuleEvent(type)
        }  
	}
}
