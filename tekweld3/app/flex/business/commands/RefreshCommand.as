package business.commands
{
	import business.events.PopulateListEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.CursorManager;
		
	public class RefreshCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			CursorManager.setBusyCursor();
			Application.application.enabled	= false;

			__genModel.activeModelLocator.viewObj.selectedView["user_id"] = __genModel.user.userID
			__genModel.activeModelLocator.viewObj.selectedView["company_id"] = __genModel.user.default_company_id.toString();
			
			var populateListEvent:PopulateListEvent = new PopulateListEvent(__genModel.activeModelLocator.viewObj.selectedView);
			populateListEvent.dispatch();
			
			CursorManager.removeBusyCursor();
			Application.application.enabled	= true;
		}
	}
}
