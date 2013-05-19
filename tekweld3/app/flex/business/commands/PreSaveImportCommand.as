package business.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.events.ImportEvent;
	
	import model.GenModelLocator;
	
	import mx.core.Container;
	
	public class PreSaveImportCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		
		
		public function execute(event:CairngormEvent):void
		{
			if(__genModel.activeModelLocator.addEditObj.recordStatus == "MODIFY")
			{
				var importContainer:Container = __genModel.activeModelLocator.importObj.container
				importContainer.dispatchEvent(new ImportEvent(ImportEvent.PRE_SAVE_EVENT));
			}
		}
	}
}
