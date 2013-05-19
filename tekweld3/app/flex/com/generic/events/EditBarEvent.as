package com.generic.events
{
	import flash.events.Event;

	public class EditBarEvent extends Event
	{
		public static const DOWNKEY_EVENT:String = "downKeyEvent";
		public static const UPKEY_EVENT:String = "upKeyEvent";
		public static const TABKEY_EVENT:String = "tabKeyEvent";
		public static const SHIFTTABKEY_EVENT:String = "shiftTabKeyEvent";
		public static const SCROLLONTAB_EVENT:String = "scrollOnTabEvent";
		public static const CREATED_EVENT:String = "createdEvent";
		public static const EDITBARITEMCHANGED_EVENT:String = "editBarItemChangedEvent";
		public static const EDITBARDOUBLECLICK_EVENT:String = "editBarDoubleClickEvent"
		
		public var object:Object;
		
		public function EditBarEvent(type:String , object:Object=null)
		{
			super(type, true);
			this.object	=	object;
		}

		override public function clone():Event
		{
			return new EditBarEvent(type)
        }  
	}
}
