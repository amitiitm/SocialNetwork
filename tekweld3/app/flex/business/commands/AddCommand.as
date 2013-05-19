package business.commands
{
	import business.events.AddEvent;
	import business.events.RecordStatusEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.events.AddEditEvent;
	import com.generic.genclass.GenObject;
	
	import model.GenModelLocator;
	
	import mx.core.Application;
	import mx.managers.CursorManager;
	
	import valueObjects.ModeVO;
	
	public class AddCommand implements ICommand
	{
		private var __genModel:GenModelLocator=GenModelLocator.getInstance();
		private var recordStatusEvent:RecordStatusEvent;		
		
		public function execute(event:CairngormEvent):void
		{
			var changeStackIndex:Boolean	=	(event as AddEvent).changeStackIndex
			
			CursorManager.setBusyCursor();
			Application.application.enabled	=	false;

			__genModel.activeModelLocator.addEditObj.record		=	null;
			
			if(__genModel.activeModelLocator.hasOwnProperty('noteAttachObj'))
			{
				__genModel.activeModelLocator.noteAttachObj.recordId		=	0;
			}
			
			recordStatusEvent = new RecordStatusEvent("NEW");
			recordStatusEvent.dispatch();	

			new GenObject().resetObjects(__genModel.activeModelLocator.addEditObj.genObjects);

			if(__genModel.activeModelLocator.listObj.rows != null)
			{
				__genModel.activeModelLocator.listObj.listGrid.selectedIndex = -1
			}
			__genModel.activeModelLocator.listObj.selectedRow = null // VD 07 Dec 2009 
			
			if(changeStackIndex)
			{
				__genModel.activeModelLocator.documentObj.selectedMode	=	ModeVO.EDIT_MODE
			}
			
			__genModel.activeModelLocator.addEditObj.addEditContainer.dispatchEvent(new AddEditEvent(AddEditEvent.RESET_OBJECT_EVENT));
			__genModel.activeModelLocator.addEditObj.isRecordViewOnly = false
			
			CursorManager.removeBusyCursor();
			Application.application.enabled	=	true;
			
			//for copy record functionality
			if(__genModel.activeModelLocator.addEditObj.isCopy)
			{
				var genObj:GenObject = new GenObject();
				
				genObj.setRecordEditable(__genModel.activeModelLocator.addEditObj.genObjects);
				genObj.setRecord(__genModel.activeModelLocator.addEditObj.genObjects, __genModel.activeModelLocator.addEditObj.copiedRecord);
				recordStatusEvent = new RecordStatusEvent("MODIFY");
				recordStatusEvent.dispatch();
				__genModel.activeModelLocator.addEditObj.isCopy	=	false;
				__genModel.activeModelLocator.addEditObj.copiedRecord	=	null;
				__genModel.activeModelLocator.addEditObj.addEditContainer.dispatchEvent(new AddEditEvent(AddEditEvent.COPY_RECORD_COMPLETE_EVENT));
				
			}
		}
	}
}