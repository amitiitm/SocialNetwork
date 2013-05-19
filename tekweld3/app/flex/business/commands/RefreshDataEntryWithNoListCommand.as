package business.commands
{
	import business.events.InitializeDataEntryWithNoListEvent;
	import business.events.RecordStatusEvent;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.core.Application;
	import mx.managers.CursorManager;

	public class RefreshDataEntryWithNoListCommand implements ICommand
	{
		public function execute(event:CairngormEvent):void
		{
			CursorManager.setBusyCursor();
			Application.application.enabled	= false;

			var initializeDataEntryWithNoListEvent:InitializeDataEntryWithNoListEvent = new InitializeDataEntryWithNoListEvent();
			initializeDataEntryWithNoListEvent.dispatch();

			var recordStatusEvent:RecordStatusEvent = new RecordStatusEvent("NEW")
			recordStatusEvent.dispatch()
			
			CursorManager.removeBusyCursor();
			Application.application.enabled	= true;
		}
	}
}
