package business.commands
{
	import business.events.RowStatusEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.events.DetailAddEditEvent;
	import com.generic.genclass.GenObject;
	
	import model.GenModelLocator;
	
	import mx.core.Container;
	
	public class InsertRowCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var  genObj:GenObject =	new GenObject()
		private var rowStatusEvent:RowStatusEvent;
		
		public function execute(event:CairngormEvent):void
		{
			addBlankRow();
		}

		private function addBlankRow():void
		{
			rowStatusEvent = new RowStatusEvent("NEW");
			rowStatusEvent.dispatch();	
			
			__genModel.activeModelLocator.detailEditObj.genDataGrid.selectedIndex	=	-1;
			__genModel.activeModelLocator.detailEditObj.selectedRow					=	null;
			
			genObj.resetObjects(__genModel.activeModelLocator.detailEditObj.genObjects);
			
				var detailAddEditContainer:Container = __genModel.activeModelLocator.detailEditObj.detailEditContainer
				detailAddEditContainer.dispatchEvent(new DetailAddEditEvent(DetailAddEditEvent.RESET_OBJECT_EVENT));
				
				
			//for copy record functionality
			if(__genModel.activeModelLocator.detailEditObj.isCopy)
			{
				copyRowFunctionality();
 			}				
		}
		private function copyRowFunctionality():void
		{
			// set values
			var tempXml:XML 	= new XML('<' + __genModel.activeModelLocator.detailEditObj.genDataGrid.rootNode + '/>');
			var row:XML			= new XML(__genModel.activeModelLocator.detailEditObj.copiedRow)
			tempXml.appendChild(row);
			genObj.setRecord(__genModel.activeModelLocator.detailEditObj.genObjects,tempXml)
			
			rowStatusEvent 		= new	RowStatusEvent("MODIFY")
			rowStatusEvent.dispatch()
			
			__genModel.activeModelLocator.detailEditObj.isCopy		=	false;
			__genModel.activeModelLocator.detailEditObj.copiedRow	=	null;
			__genModel.activeModelLocator.detailEditObj.detailEditContainer.dispatchEvent(new DetailAddEditEvent(DetailAddEditEvent.COPY_ROW_COMPLETE_EVENT));
		}
	}
}
