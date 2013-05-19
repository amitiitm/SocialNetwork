package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.net.FileReference;
	
	import mx.rpc.IResponder;

	public class UploadAttachmentEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "uploadAttachmentEvent";
		public var fileName:String;
		public var subject:String;
		public var emailTO:String
		public var emailCC:String;
		public var callbacks:IResponder;
		public var fileReference:FileReference
		
		public function UploadAttachmentEvent(fileReference:FileReference ,fileName:String , subject:String ,emailTO:String,emailCC:String, callbacks:IResponder = null)
		{
			super(EVENT_ID);
			this.fileName		=	fileName;
			this.subject		=	subject;
			this.emailTO		=	emailTO;
			this.emailCC		=	emailCC;
			this.callbacks		=	callbacks;
			this.fileReference	=	fileReference;
			
		}
	}
}

