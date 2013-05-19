package business.commands
{
	import model.GenModelLocator;
	import com.adobe.cairngorm.control.CairngormEvent; 
	import com.adobe.cairngorm.commands.ICommand;
	import mx.core.Application;
	import mx.managers.CursorManager;
	
	public class SortCommand implements ICommand
	{
		private var __genModel:GenModelLocator=GenModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			__genModel.activeModelLocator.sortOrderSelectionObj.isSortOrderSelectionVisible = !(__genModel.activeModelLocator.sortOrderSelectionObj.isSortOrderSelectionVisible)
		}
	}
}
