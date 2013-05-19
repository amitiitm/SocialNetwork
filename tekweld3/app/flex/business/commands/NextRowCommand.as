package business.commands
{
	import business.events.RowStatusEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.events.DetailAddEditEvent;
	import com.generic.genclass.GenObject;
	
	import model.GenModelLocator;
	
	import mx.core.Container;
	
	import valueObjects.DetailEditVO;
	
	public class NextRowCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var __detailEditObj:DetailEditVO;
		private var rowStatusEvent:RowStatusEvent;
				
		public function execute(event:CairngormEvent):void
		{
			__detailEditObj = __genModel.activeModelLocator.detailEditObj;
			
			if(__detailEditObj.selectedRow != null)
			{
				var selectedIndex:int = XML(__detailEditObj.selectedRow).childIndex()
				var genObj:GenObject = new GenObject();
				var limit:int = XML(__detailEditObj.genDataGrid.rows).children().length() - 1
			
				if(selectedIndex != limit)
					{
					var rowIndex:int = selectedIndex + 1;
					
					__detailEditObj.genDataGrid.selectedIndex = rowIndex;
					__detailEditObj.selectedRow = XML(__detailEditObj.genDataGrid.selectedItem);
					__detailEditObj.genDataGrid.scrollToIndex(rowIndex);
					
					var tempXml:XML = new XML('<' + __detailEditObj.genDataGrid.rootNode + '/>');
					var selectedRow:XML	= new XML(__detailEditObj.selectedRow)
	
					tempXml.appendChild(selectedRow);
					genObj.setRecord(__detailEditObj.genObjects,tempXml)
					
					rowStatusEvent = new	RowStatusEvent("QUERY")
					rowStatusEvent.dispatch()
					
					var detailAddEditContainer:Container = __genModel.activeModelLocator.detailEditObj.detailEditContainer
					detailAddEditContainer.dispatchEvent(new DetailAddEditEvent(DetailAddEditEvent.RETRIEVE_ROW_END_EVENT,selectedRow));

				} 
			}
		}
	}
}
