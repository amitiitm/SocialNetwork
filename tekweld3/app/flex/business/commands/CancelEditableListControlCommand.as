package business.commands
{
	import business.events.RecordStatusEvent;
	import business.events.RefreshEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import model.GenModelLocator;
	
	import mx.core.Application;
	import mx.managers.CursorManager;

	public class CancelEditableListControlCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var refreshEvent:RefreshEvent;
		private var recordStatusEvent:RecordStatusEvent;

		public function execute(event:CairngormEvent):void
		{
			CursorManager.setBusyCursor();
			Application.application.enabled = false;

			__genModel.activeModelLocator.addEditObj.addEditContainer.inbox.rows = __genModel.activeModelLocator.addEditObj.addEditContainer.inbox.oldValues;

			recordStatusEvent = new RecordStatusEvent("NEW");
			recordStatusEvent.dispatch();
			
			CursorManager.removeBusyCursor();
			Application.application.enabled	= true;
		}
	}
}
