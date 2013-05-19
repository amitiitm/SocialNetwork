package com.generic.events
{
	import flash.events.Event;
	
	public class GenUploadButtonEvent extends Event
	{
		public static const UPLOAD_FILE_NAME_SET:String = "genUploadFileNameSetEvent"; 
		public static const DOWNLOAD_COMPLETE:String = "downloadCompleteEvent";
		public static const COMPLETE:String = "completeEvent";
		 
		public var fileName:String;
		public var downloadedObj:Object = null;

		public function GenUploadButtonEvent(type:String, fileName:String, downloadedObj:Object = null , bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.downloadedObj	=		downloadedObj; // for downloaded object 			
			this.fileName 		= 		fileName; //for image uploading	
			super(type)//, bubbles, cancelable);
		}
		
	}
}
