package com.generic.events
{
	import flash.events.Event;
	
	import mx.events.DataGridEvent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;

	public class DetailEvent extends Event
	{
		public static const DETAIL_ADDEDIT_COMPLETE:String = "detailAddEditComplete";
		public static const DETAIL_SAVE_IMPORTED_XML_COMPLETE:String = "detailSaveImportedXMLComplete";
		public static const DETAIL_ITEM_CLICK:String = "detailItemClick";
		public static const DETAIL_ITEM_FOCUS_OUT:String = "detailItemFocusOut";
		public static const DETAIL_REMOVE_ROW:String = "detailRemoveRow";
		
		
		public var flexEvent:FlexEvent			=	null;
		public var listEvent:ListEvent			=	null;
		public var dataGridEvent:DataGridEvent	=	null;

		public function DetailEvent(type:String, dataGridEvent:DataGridEvent=null , listEvent:ListEvent=null , flexEvent:FlexEvent=null)
		{
			super(type, true);
			this.dataGridEvent	=	dataGridEvent;
			this.listEvent		=	listEvent;
			this.flexEvent		=	flexEvent;
		}

		override public function clone():Event
		{
			return new DetailEvent(type, dataGridEvent,listEvent,flexEvent)
        }
	}
}
