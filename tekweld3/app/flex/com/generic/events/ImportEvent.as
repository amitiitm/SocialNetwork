package com.generic.events
{
	import flash.events.Event;

	public class ImportEvent extends Event
	{
		public static const RESET_OBJECT_EVENT:String 			= "resetObjectEvent";
		public static const RETRIEVE_RECORD_END_EVENT:String 	= "retrieveRecordEndEvent";
		public static const PRE_SAVE_EVENT:String 				= "preSaveEvent";
		public static const DOWNLOAD_COMPLETE_EVENT:String 		= "downloadCompleteEvent";
		
		public var recordXml:XML;

		public function ImportEvent(type:String , aXML:XML=null)
		{
			super(type, true);
			this.recordXml	=	aXML;
			
		}

		override public function clone():Event
		{
			return new ImportEvent(type)
        }
	}
}
