package com.generic.events
{
	import flash.events.Event;

	public class AddEditEvent extends Event
	{
		public static const COMPONENT_ACTIVE_EVENT:String = "componentActiveEvent";
		public static const RESET_OBJECT_EVENT:String = "resetObjectEvent";
		public static const RETRIEVE_RECORD_END_EVENT:String = "retrieveRecordEndEvent";
		public static const PRE_SAVE_EVENT:String = "preSaveEvent";
		public static const COPY_RECORD_COMPLETE_EVENT:String = "copyRecordCompleteEvent";
		
		public var recordXml:XML;

		public function AddEditEvent(type:String , aXML:XML=null)
		{
			super(type, true);
			this.recordXml	=	aXML;
			
		}

		override public function clone():Event
		{
			return new AddEditEvent(type)
        }
	}
}
