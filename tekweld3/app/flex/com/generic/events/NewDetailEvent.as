package com.generic.events
{
	import flash.events.Event;

	public class NewDetailEvent extends Event
	{
		public static const DETAIL_ITEM_CLICK:String = "detailItemClick";
		public static const DETAIL_ITEM_FOCUS_OUT:String = "detailItemFocusOut";
		public static const DETAIL_REMOVE_ROW:String = "detailRemoveRow";
		public static const ROW_FOCUS_CHANGED:String = "detailRowFocusChanged";
		public static const STRUCTURE_COMPLETE_EVENT:String = "structureCompleteEvent";


		public var object:Object = null;

		public function NewDetailEvent(type:String, object:Object=null)
		{
			super(type, true);

			this.object	= object;
		}

		override public function clone():Event
		{
			return new NewDetailEvent(type, object)
        }
	}
}

