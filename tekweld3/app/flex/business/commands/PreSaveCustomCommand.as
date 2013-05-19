package business.commands
{
	import business.events.PreSaveCustomEvent;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.events.AddEditEvent;
	import model.GenModelLocator;
	import mx.core.Container;
	
	public class PreSaveCustomCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			if(__genModel.activeModelLocator.addEditObj.recordStatus == "MODIFY")
			{
				__genModel.activeModelLocator.buttonName = (event as PreSaveCustomEvent).buttonName;

				var addEditContainer:Container = __genModel.activeModelLocator.addEditObj.addEditContainer
				addEditContainer.dispatchEvent(new AddEditEvent(AddEditEvent.PRE_SAVE_EVENT));
			}
		}
	}
}
