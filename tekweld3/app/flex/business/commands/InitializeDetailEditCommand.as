package business.commands
{
	import business.events.GetGenDataGridFormatEvent;
	import business.events.GetGenListDataEvent;
	import business.events.InsertRowEvent;
	import business.events.RowStatusEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.components.DetailEdit;
	import com.generic.events.DetailAddEditEvent;
	import com.generic.genclass.GenObject;
	import com.generic.genclass.GenValidator;
	
	import flash.utils.getQualifiedClassName;
	
	import model.GenModelLocator;
	
	import mx.core.Container;
	
	import valueObjects.DetailEditVO;
	import valueObjects.ModeVO;
	
	public class InitializeDetailEditCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var __detailEditObj:DetailEditVO;
		private var rowStatusEvent:RowStatusEvent;
		
		public function execute(event:CairngormEvent):void
		{
			var genObj:GenObject = new GenObject();
			var genValidator:GenValidator = new GenValidator();
			var insertRowEvent:InsertRowEvent;
			var getGenDataGridFormatEvent:GetGenDataGridFormatEvent;
			var getGenListDataEvent:GetGenListDataEvent;

			__detailEditObj = __genModel.activeModelLocator.detailEditObj;
			__detailEditObj.genObjects = genObj.getGenObjects(__detailEditObj.detailEditContainer);
			__detailEditObj.validators = genValidator.applyValidation(__detailEditObj.genObjects) // VD 4 Nov, 2009
		
			__detailEditObj.isActive = true

			// Vivek Dubey	03 Oct, 2011
			for(var i:int = 0; i < __detailEditObj.genObjects.length; i++)
			{
				if( getQualifiedClassName(__detailEditObj.genObjects[i]) == "com.generic.customcomponents::GenDataGrid"
					||	getQualifiedClassName(__detailEditObj.genObjects[i]) == "com.generic.components::Detail"
					|| 	getQualifiedClassName(__detailEditObj.genObjects[i]) == "com.generic.components::EditableDetail"
					|| 	getQualifiedClassName(__detailEditObj.genObjects[i]) == "com.generic.components::NewDetail"
				  )
				{
					getGenDataGridFormatEvent = new GetGenDataGridFormatEvent(__detailEditObj.genObjects[i]);
					getGenDataGridFormatEvent.dispatch();
				}
				else if(getQualifiedClassName(__detailEditObj.genObjects[i]) == "com.generic.customcomponents::GenList")
				{
					getGenListDataEvent = new GetGenListDataEvent(__detailEditObj.genObjects[i]);
					getGenListDataEvent.dispatch();
				}
			}
			// Vivek Dubey
			
			if(!__detailEditObj.isDobleClickOnGrid)
			{
				__detailEditObj.selectedRow = null;
			}
			
			if(__detailEditObj.selectedRow == null)
			{
				// to insert balnk row dispatch insertRowCommand
				insertRowEvent = new InsertRowEvent();
				insertRowEvent.dispatch()
			}
			else
			{
				// set values
				var tempXml:XML = new XML('<' + __detailEditObj.genDataGrid.rootNode + '/>');
				var selectedRow:XML	= new XML(__detailEditObj.selectedRow)
				tempXml.appendChild(selectedRow);
				genObj.setRecord(__detailEditObj.genObjects,tempXml)
				
				rowStatusEvent = new	RowStatusEvent("QUERY")
				rowStatusEvent.dispatch()
				
				var detailAddEditContainer:Container = __genModel.activeModelLocator.detailEditObj.detailEditContainer
				detailAddEditContainer.dispatchEvent(new DetailAddEditEvent(DetailAddEditEvent.RETRIEVE_ROW_END_EVENT,selectedRow));
			}
			if(__genModel.activeModelLocator.documentObj.selectedMode	==	ModeVO.VIEW_ONLY_WITH_TREE_MODE || __genModel.activeModelLocator.addEditObj.isRecordViewOnly)
			{
				genObj.setRecordViewOnly(__detailEditObj.genObjects);
				DetailEdit(__detailEditObj.detailEditContainer.parentDocument).bcp.btnAdd.enabled	=	false;
			}
		}
	}
}
