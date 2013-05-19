package business.commands
{
	import business.events.FetchRecordWithDetailSelectEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.events.FetchRecordEvent;
	
	import model.GenModelLocator;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.CursorManager;
	import mx.rpc.events.FaultEvent;
	
	import valueObjects.DetailEditVO;
	
	public class FetchRecordWithDetailSelectCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var __detailEditObj:DetailEditVO;
		private var  detailRows:XML	;
		private var mappingArrCol:ArrayCollection; //it will have array of mapping fields
		private var primaryKeys:Array; //it will have primay key fields object
		private var allFetchRows:XML
		 
		public function execute(event:CairngormEvent):void
		{
			CursorManager.setBusyCursor();
			Application.application.enabled	=	false;
			
			__detailEditObj 				= 	__genModel.activeModelLocator.detailEditObj;
			detailRows 						= 	(__detailEditObj.genDataGrid.rows).copy();
			mappingArrCol 					= 	__detailEditObj.fetchMapingArrCol;
			
			updatePrimaryKeyArray()
			
			allFetchRows 					= 	(event as FetchRecordWithDetailSelectEvent).allFetchRows;
			
			if(__detailEditObj.isFetchSingleSelected)
			{
				executeSingleSelectedFunctionalities()
			}
			else
			{
				executeMultiSelectFunctionalities()
			}
		}

		private function executeSingleSelectedFunctionalities():void
		{
			var selectedChildList:XMLList 	= 	null;
			selectedChildList 				= 	allFetchRows.children().(child('select_yn').toString().toUpperCase() == 'Y')
			
			// if nothing is get selected then do nothing just return. 
			if(selectedChildList != XMLList(undefined))
			{
				var existAtPosition:int	=	getExistPosition(XML(selectedChildList))
				if(existAtPosition >= 0)  //means already exist in detail grid
				{
					// if already selected is again select then modify it if updatables are true.
					modifyUpdatableTags(existAtPosition)
				}
				else
				{
					// if new one is selected then just assign it to rows	
					detailRows	=	new XML('<'+ detailRows.localName().toString()+ '/>')
				
					addNewRow(int(selectedChildList.isAppendAtPostion))
				}
				__detailEditObj.genDataGrid.rows = detailRows;	
				__genModel.activeModelLocator.addEditObj.addEditContainer.dispatchEvent(new FetchRecordEvent(FetchRecordEvent.SELECTCOMPLETE_EVENT));
			
				CursorManager.removeBusyCursor();
				Application.application.enabled	=	true;
			}
			else
			{
				CursorManager.removeBusyCursor();
				Application.application.enabled	=	true;
			}			
			
		}
		private function executeMultiSelectFunctionalities():void
		{
			var childXml:XML;
			var atleastOneIsSelected:Boolean	=	false;
			var i:int	=	0; 

			
			//already selected is again select then modify it if updatables are true and append new selected.
			for(i=0; i < allFetchRows.children().length(); i++)
			{
				childXml = allFetchRows.children()[i];

				if(String(childXml.select_yn).toUpperCase() == 'Y')
				{
					if(String(childXml.isAlreadyExist).toUpperCase() == 'Y')
					{
						var existAtPosition:int = getExistPosition(XML(childXml));
						if(existAtPosition >= 0)
						{
							modifyUpdatableTags(existAtPosition)
						}
					}
					else
					{
						addNewRow(int(childXml.isAppendAtPostion))
					}	
				}
			}
			
			__detailEditObj.genDataGrid.rows = detailRows;
			__genModel.activeModelLocator.addEditObj.addEditContainer.dispatchEvent(new FetchRecordEvent(FetchRecordEvent.SELECTCOMPLETE_EVENT)); 
			CursorManager.removeBusyCursor();
			Application.application.enabled	=	true;
		}

		/*to add new row in detail according to the mapping*/
		private function addNewRow(childPos:int):void
		{
			var newRow:XML	=	XML(__detailEditObj.rows.children()[childPos])		
			
			detailRows.appendChild(newRow);
		}

	/*get the primary keys from mapping*/
		private function updatePrimaryKeyArray():void
		{
			primaryKeys = new Array();

		    for(var i:int=0; i < mappingArrCol.length; i++)
			{
				if((mappingArrCol.getItemAt(i).isPrimaryKey).toString().toUpperCase() == 'Y')
				{
					primaryKeys.push(mappingArrCol.getItemAt(i));
				}
			}
		}
		
		/*it will find where the child exist in detailRows and return position of that if not exist then returns -1*/
		private function getExistPosition(childXml:XML):int
		{
			var j:int;
			var k:int;
			var length:int = __detailEditObj.genDataGrid.rows.children().length();
			var isAlreadyExist:Boolean = false;
			var existAtPosition:int	=	-1;
			
			for(j=0; j < length; j++)
			{
				isAlreadyExist = false;
				
				for(k=0; k < primaryKeys.length ; k++)
				{
					if(childXml.child(primaryKeys[k].source).toString() == detailRows.children()[j].child(primaryKeys[k].target).toString())
					{
						isAlreadyExist = true;
					}
					else
					{
						isAlreadyExist = false;
						break;
					}
				}

				if(isAlreadyExist)
				{
					existAtPosition	=	j;
					break;
				}
			}
			
			return existAtPosition;
		}
		
		/*it will modify only that tag of existing child in detailRows with sourceXml which are updatable in mapping*/
		private function modifyUpdatableTags(childPos:int):void
		{
			var tempXML:XML	=	XML(__detailEditObj.rows.children()[childPos])
			var rowXML:XML	=	 XML(detailRows.children()[childPos])
			
			rowXML.setChildren(tempXML.children());
		}
		private function faultHandler(event:FaultEvent):void
		{
			Alert.show('FetchRecordSelectCommand' + event.fault.toString());	
		}
	}
}	
