package com.generic.events
{
	import flash.events.Event;
	
	import mx.events.DataGridEvent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;

	public class EditableDetailEvent extends Event
	{
		public static const DETAIL_ITEM_CLICK:String = "detailItemClick";
		public static const DETAIL_ITEM_FOCUS_OUT:String = "detailItemFocusOut";
		public static const DETAIL_REMOVE_ROW:String = "detailRemoveRow";
		public static const FETCH_CRITERIA_OK_COMPLETE:String = "fetchCriteriaOKComplete";
		
		
		public var flexEvent:FlexEvent			=	null;
		public var listEvent:ListEvent			=	null;
		public var dataGridEvent:DataGridEvent	=	null;
		public var fetchCriteriaXML:XML			=	null;

		public function EditableDetailEvent(type:String, dataGridEvent:DataGridEvent=null , listEvent:ListEvent=null , flexEvent:FlexEvent=null,fetchCriteriaXML=null)
		{
			super(type, true);
			this.dataGridEvent		=	dataGridEvent;
			this.listEvent			=	listEvent;
			this.flexEvent			=	flexEvent;
			this.fetchCriteriaXML	=	fetchCriteriaXML;
		}

		override public function clone():Event
		{
			return new EditableDetailEvent(type, dataGridEvent,listEvent,flexEvent,fetchCriteriaXML)
        }
	}
}
