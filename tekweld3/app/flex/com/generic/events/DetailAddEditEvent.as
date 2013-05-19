package com.generic.events
{
	import flash.events.Event;

	public class DetailAddEditEvent extends Event
	{
	
		public static const RESET_OBJECT_EVENT:String 			= "resetObjectEvent";
		public static const RETRIEVE_ROW_END_EVENT:String 		= "retrieveRowEndEvent";
		public static const PRE_SAVE_ROW_EVENT:String 			= "preSaveRowEvent";
		public static const DOWNLOAD_COMPLETE_EVENT:String 		= "downloadCompleteEvent";
		public static const PRE_SAVE_IMPORTED_XML_EVENT:String 	= "preSaveImportedXMLEvent";
		public static const PARENT_NOTIFICATION_EVENT:String 	= "parentNotificationEvent";
		public static const COPY_ROW_COMPLETE_EVENT:String 		= "copyRowCompleteEvent";
		
		public var rowXml:XML;

		public function DetailAddEditEvent(type:String , aXML:XML=null)
		{
			super(type, true);
			this.rowXml	=	aXML;
			
		}

		override public function clone():Event
		{
			return new DetailAddEditEvent(type)
        }
	}
}
