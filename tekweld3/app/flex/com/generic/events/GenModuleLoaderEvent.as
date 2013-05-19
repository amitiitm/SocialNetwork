package com.generic.events
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;

	public class GenModuleLoaderEvent extends Event
	{
		public static const ACTIVE_EVENT:String = "genModuleLoaderActive";
		public static const SHORTCUTKEY_EVENT:String = "genModuleLoaderShortcutKey";
		public var keyBoardEvent:KeyboardEvent;
		
		public function GenModuleLoaderEvent(type:String , keyBoardEvent:KeyboardEvent = null)
		{
			super(type, true);
			this.keyBoardEvent	=	keyBoardEvent
		}
		
		override public function clone():Event
		{
			return new GenModuleLoaderEvent(type)
        }  
	}
}