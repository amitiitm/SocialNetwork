package business.commands
{
	import business.delegates.UploadAttachmentDelegate;
	import business.events.UploadAttachmentEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.customcomponents.GenDateField;
	
	import flash.net.FileReference;
	
	import model.GenModelLocator;
	
	import mx.rpc.IResponder;
	
	import valueObjects.NoteAttachmentVO;
		
	public class UploadAttachmentCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var __noteAttachObj:NoteAttachmentVO;
		private var viewHandler:IResponder;
		
		public function execute(event:CairngormEvent):void
		{
			__noteAttachObj		=	__genModel.activeModelLocator.noteAttachObj;
			
			var fileReference:FileReference	=	(event as UploadAttachmentEvent).fileReference;
			var fileName:String				=	(event as UploadAttachmentEvent).fileName;
			var subject:String				=	(event as UploadAttachmentEvent).subject;
			var emailTO:String				=	(event as UploadAttachmentEvent).emailTO;
			var emailCC:String				=	(event as UploadAttachmentEvent).emailCC;
			viewHandler						=	(event as UploadAttachmentEvent).callbacks;
				
			
			var delegate:UploadAttachmentDelegate	=	new UploadAttachmentDelegate(viewHandler);
			
		     
		    var uploadFileParams:XML	=	new XML(
		
													<attachments>
														<attachment>
															<id/>
															<company_id>{__genModel.user.default_company_id.toString()}</company_id>
															<user_id>{__genModel.user.userID.toString()}</user_id>
															<date_added>{new GenDateField().currentDate()}</date_added>
															<subject>{subject}</subject>
															<email_to>{emailTO}</email_to>
															<email_cc>{emailCC}</email_cc>
															<file_name>{fileName}</file_name>
															<table_name>{__noteAttachObj.tableName}</table_name>
															<trans_id>{__noteAttachObj.recordId}</trans_id>
														</attachment>
													</attachments>
												  )	
												  
			delegate.uploadFile(fileReference ,uploadFileParams);										  
																								
													
														
		}
	}
}
