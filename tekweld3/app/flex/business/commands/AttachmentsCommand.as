package business.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.components.Attachments;
	import com.generic.components.Notes;
	
	import flash.display.DisplayObject;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	
	import valueObjects.NoteAttachmentVO;
	
	public class AttachmentsCommand implements ICommand
	{
		private var __genModel:GenModelLocator=GenModelLocator.getInstance();
		private var __noteAttachObj:NoteAttachmentVO;
		
		public function execute(event:CairngormEvent):void
		{
			openAttachmentWindow();
			
		}
		 private function openAttachmentWindow():void
		{
			if( __genModel.activeModelLocator.hasOwnProperty('noteAttachObj')) 
			{
				__noteAttachObj	=	__genModel.activeModelLocator.noteAttachObj;
				
				if(__noteAttachObj.recordId != 0)
				{
					
						var attachmentComponent:Attachments 	= Attachments(PopUpManager.createPopUp(DisplayObject(Application.application),Attachments, true));
						
						attachmentComponent._id 			=  __noteAttachObj.recordId;
						attachmentComponent._tableName 		=  __noteAttachObj.tableName
						attachmentComponent._companyId		=	__genModel.user.default_company_id;
						attachmentComponent._userId			=	__genModel.user.userID;
				}
				else
				{
					Alert.show('please select a record');
				}
			}
			else
			{
				Alert.show('noteAttachObj is not defined for this screen');
			}
		}		 
	}
}
