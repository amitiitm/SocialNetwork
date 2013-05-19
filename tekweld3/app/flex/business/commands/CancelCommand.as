package business.commands
{
	import business.events.AddEvent;
	import business.events.GetRecordEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.genclass.GenObject;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.CursorManager;

	public class CancelCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var genObj:GenObject = new GenObject();
		private var addEvent:AddEvent;
		private var getRecordEvent:GetRecordEvent;

		public function execute(event:CairngormEvent):void
		{
			CursorManager.setBusyCursor();
			Application.application.enabled = false;

			if(__genModel.activeModelLocator.listObj.selectedRow != null)
			{
				getRecordEvent = new GetRecordEvent(int(__genModel.activeModelLocator.listObj.selectedRow.id.toString()));
				getRecordEvent.dispatch();
			}
			else
			{
				addEvent = new AddEvent();
				addEvent.dispatch();
			}
			
			CursorManager.removeBusyCursor();
			Application.application.enabled	= true;
		}
	}
}
