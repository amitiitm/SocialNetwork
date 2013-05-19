package business.commands
{
	import business.events.GetRecordEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import model.GenModelLocator;
	
	import valueObjects.ListVO;
	import valueObjects.ModeVO;

	public class FirstRecordCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var __listObj:ListVO;
		
		
		public function execute(event:CairngormEvent):void
		{
			if(__genModel.activeModelLocator.addEditObj.recordStatus != "MODIFY")
			{
				var selectedIndex:int;
	
				__listObj = __genModel.activeModelLocator.listObj;
				
				if(__listObj.filteredList != XML(undefined) && __listObj.filteredList != null &&  __listObj.filteredList.children().length() > 0)
				{
					selectedIndex = XML(__listObj.selectedRow).childIndex()
				
					if(selectedIndex !=	0)
					{
						var getRecordEvent:GetRecordEvent;
						var rowIndex:int = 0;
						
						__listObj.listGrid.selectedIndex = rowIndex;
						__listObj.selectedRow = XML(__listObj.listGrid.selectedItem);
						__listObj.listGrid.scrollToIndex(rowIndex);
		
						if(__genModel.activeModelLocator.documentObj.selectedMode	==	ModeVO.LIST_MODE)
						{
							/* getRecordEvent = new GetRecordEvent(int(__listObj.selectedRow.id.toString()));
							getRecordEvent.dispatch();	 */
						}
						else if(__genModel.activeModelLocator.documentObj.selectedMode	==	ModeVO.EDIT_MODE)
						{
							getRecordEvent = new GetRecordEvent(int(__listObj.selectedRow.id.toString()));
							getRecordEvent.dispatch();	
						}
						else if(__genModel.activeModelLocator.documentObj.selectedMode	==	ModeVO.VIEW_ONLY_WITH_TREE_MODE)
						{
							getRecordEvent = new GetRecordEvent(int(__listObj.selectedRow.id.toString()),null,true);
							getRecordEvent.dispatch();
						}
					}
				}
			} 
		}
	}
}
