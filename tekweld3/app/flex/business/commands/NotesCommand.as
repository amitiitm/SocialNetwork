package business.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.components.Notes;
	
	import flash.display.DisplayObject;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	
	import valueObjects.NoteAttachmentVO;
	
	public class NotesCommand implements ICommand
	{
		private var __genModel:GenModelLocator=GenModelLocator.getInstance();
		private var __noteAttachObj:NoteAttachmentVO;
		
		public function execute(event:CairngormEvent):void
		{
			openNoteWindow();
			
		}
		 private function openNoteWindow():void
		{
			if( __genModel.activeModelLocator.hasOwnProperty('noteAttachObj')) 
			{
				__noteAttachObj	=	__genModel.activeModelLocator.noteAttachObj;
			
				if(__noteAttachObj.recordId != 0)
				{
					
						var noteComponent:Notes 	= Notes(PopUpManager.createPopUp(DisplayObject(Application.application), Notes, true));
						
						noteComponent._id 			=  __noteAttachObj.recordId;
						noteComponent._tableName 	= __noteAttachObj.tableName.toString();
						 
						noteComponent._companyId	=	__genModel.user.default_company_id;
						noteComponent._userId		=	__genModel.user.userID;
						noteComponent._login_type	=	__genModel.user.login_type;
						
						noteComponent._email_cc = ''//tiEmail_cc.text;
						noteComponent._email_to = ''//tiEmail_id.text;
						noteComponent._general_email_id = ''//cbGeneral_email_id.selectedLabel;
						noteComponent._subject = ''//_notesSubject; 
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