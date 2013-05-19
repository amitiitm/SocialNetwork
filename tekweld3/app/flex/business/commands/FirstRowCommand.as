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
	
	public class FirstRowCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var __detailEditObj:DetailEditVO;
		private var rowStatusEvent:RowStatusEvent;
		
		public function execute(event:CairngormEvent):void
		{
			
			var selectedIndex:int;
			

			__detailEditObj = __genModel.activeModelLocator.detailEditObj;
			
			if(__detailEditObj.genDataGrid.rows.children().length()	>	0)
			{
				if(__detailEditObj.selectedRow	!= null)
				{
					selectedIndex = XML(__detailEditObj.selectedRow).childIndex()

					if(selectedIndex !=	0)
					{
						setToFirstRow();
					} 
					
				}
				else
				{
					setToFirstRow();	
				}	
			}
			
			
		}
		private function setToFirstRow():void
		{
			var rowIndex:int = 0;
			var genObj:GenObject = new GenObject();
			
			__detailEditObj.genDataGrid.selectedIndex = rowIndex;
			__detailEditObj.selectedRow = XML(__detailEditObj.genDataGrid.selectedItem);
			__detailEditObj.genDataGrid.scrollToIndex(rowIndex); 
			
			var tempXml:XML = new XML('<' + __detailEditObj.genDataGrid.rootNode + '/>');
			var selectedRow:XML	= new XML(__detailEditObj.selectedRow)
			
			tempXml.appendChild(selectedRow);
			genObj.setRecord(__detailEditObj.genObjects, tempXml);
			
			rowStatusEvent = new	RowStatusEvent("QUERY")
			rowStatusEvent.dispatch()
			
			var detailAddEditContainer:Container = __genModel.activeModelLocator.detailEditObj.detailEditContainer
			detailAddEditContainer.dispatchEvent(new DetailAddEditEvent(DetailAddEditEvent.RETRIEVE_ROW_END_EVENT,selectedRow));

		}
	}
}
