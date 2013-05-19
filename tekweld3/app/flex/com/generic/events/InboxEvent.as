package com.generic.events
{
	import flash.events.Event;

	public class InboxEvent extends Event
	{
		public static const INBOX_UPDATE_COMPLETE:String = "inboxUpdateComplete";
		public static const INBOX_ITEM_FOCUS_OUT:String = "inboxItemFocusOut";
		public static const INBOX_ITEM_CLICK:String = "inboxItemClick";
		public static const INBOX_REMOVE_ROW:String = "inboxRemoveRow";
		public static const INBOX_ROW_CHANGED:String = "inboxRowChanged";

		public var object:Object = null;
		public var oldValues:XML = null;
		public var newValues:XML = null;

		public function InboxEvent(type:String, object:Object=null, oldValues:XML=null, newValues:XML=null)
		{
			super(type, true);

			this.object	= object;
			this.oldValues = oldValues;
			this.newValues = newValues;
		}

		override public function clone():Event
		{
			return new InboxEvent(type, object, oldValues, newValues)
        }
	}
}
