package business.commands
{
	import business.events.RecordStatusEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.events.ImportEvent;
	import com.generic.genclass.GenObject;
	
	import model.GenModelLocator;

	public class CancelImportCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var recordStatusEvent:RecordStatusEvent;
		
		public function execute(event:CairngormEvent):void
		{
			__genModel.activeModelLocator.importObj.records		=	null;
			
			recordStatusEvent = new RecordStatusEvent("NEW");
			recordStatusEvent.dispatch();
			
			new GenObject().resetObjects(__genModel.activeModelLocator.importObj.genObjects);
			
			__genModel.activeModelLocator.importObj.container.dispatchEvent(new ImportEvent(ImportEvent.RESET_OBJECT_EVENT));

			__genModel.activeModelLocator.addEditObj.isRecordViewOnly = false
		}
	}
}


