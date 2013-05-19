package business.commands
{
	import business.delegates.GetFetchSelectedDetailDelegate;
	import business.events.FetchRecordSelectEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.events.FetchRecordEvent;
	import com.generic.genclass.Utility;
	
	import model.GenModelLocator;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.CursorManager;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import valueObjects.DetailEditVO;
	
	public class FetchRecordSelectCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var __detailEditObj:DetailEditVO;
		private var  detailRows:XML	;
		private var mappingArrCol:ArrayCollection; //it will have array of mapping fields
		private var primaryKeys:Array; //it will have primay key fields object
		private var allFetchRows:XML
		private var countExecutedServices:int	=	0;//when we have to all multipal services this is required 
		private var countResultOfExecutedServices:int	=	0;//to know how many services has been executed
		
		public function execute(event:CairngormEvent):void
		{
			CursorManager.setBusyCursor();
			Application.application.enabled	=	false;
			
			__detailEditObj 				= 	__genModel.activeModelLocator.detailEditObj;
			detailRows 						= 	(__detailEditObj.genDataGrid.rows).copy();
			mappingArrCol 					= 	__detailEditObj.fetchMapingArrCol;
			
			countExecutedServices			=	0;
			countResultOfExecutedServices	=	0;
			
			updatePrimaryKeyArray() // VD 05 May 2010
			
			allFetchRows 		= 	(event as FetchRecordSelectEvent).allFetchRows;
			
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
				if(__detailEditObj.isDetailRequired)
				{
					
					if(__detailEditObj.isOverrideDetail)
					{
						// need to call service only once and just assign to grid 
						var callbackGetSelectedDetail1:Responder 		= new Responder(getSelectedDetailResultHandler, faultHandler);
						var delegate1:GetFetchSelectedDetailDelegate 	= new GetFetchSelectedDetailDelegate(callbackGetSelectedDetail1);
						delegate1.getSelectedDetail(selectedChildList[0].id.toString(), __detailEditObj.fetchGetSelectedDetailServiceID, __genModel.user.default_company_id);
						
					}
					else
					{
						if(String(selectedChildList.isAlreadyExist).toUpperCase() == 'Y')//means already exist in detail grid
						{
							CursorManager.removeBusyCursor();
							Application.application.enabled	=	true;
							
								return;
						}
						else
						{
							//if new is selected then call service and just assign it to grid
							var callbackGetSelectedDetail2:Responder 		= new Responder(getSelectedDetailResultHandler, faultHandler);
							var delegate2:GetFetchSelectedDetailDelegate 	= new GetFetchSelectedDetailDelegate(callbackGetSelectedDetail2);
							delegate2.getSelectedDetail(selectedChildList[0].id.toString(), __detailEditObj.fetchGetSelectedDetailServiceID, __genModel.user.default_company_id);
						}
					}
				}
				else// detail is not required no need to call service 
				{
					var existAtPosition:int	=	getExistPosition(XML(selectedChildList))
					if(existAtPosition >= 0)  //means already exist in detail grid
					{
						// if already selected is again select then modify it if updatables are true.
						modifyUpdatableTags(existAtPosition,XML(selectedChildList))
					}
					else
					{
						// if new one is selected then just assign it to rows	
						detailRows	=	new XML('<'+ detailRows.localName().toString()+ '/>')
					
						
						addNewRow(XML(selectedChildList))
					}
					__detailEditObj.genDataGrid.rows = detailRows;	
					__genModel.activeModelLocator.addEditObj.addEditContainer.dispatchEvent(new FetchRecordEvent(FetchRecordEvent.SELECTCOMPLETE_EVENT));
				
					CursorManager.removeBusyCursor();
					Application.application.enabled	=	true;
				}
				
			}
			else
			{
				CursorManager.removeBusyCursor();
				Application.application.enabled	=	true;
			}			
			
		}

		private function getSelectedDetailResultHandler(event:ResultEvent):void
		{
			detailRows				=	new XML('<'+ detailRows.localName().toString()+ '/>')
			
			var xmlResult:XML;
			var utilityObj:Utility	=		new Utility();
			xmlResult 				= 		utilityObj.getDecodedXML((XML)(event.result));
			
			//var xmlResult:XML 		= XML(event.result);
			var childXml:XML;
			
			for(var i:int=0; i < xmlResult.children().length(); i++)
			{
				childXml = xmlResult.children()[i];
				addNewRow(childXml)
			}

			__detailEditObj.genDataGrid.rows = detailRows;
			__genModel.activeModelLocator.addEditObj.addEditContainer.dispatchEvent(new FetchRecordEvent(FetchRecordEvent.SELECTCOMPLETE_EVENT));
		
			CursorManager.removeBusyCursor();
			Application.application.enabled	=	true;
		}
		private function getMultipalSelectedDetailResultHandler(event:ResultEvent):void
		{
			++countResultOfExecutedServices;
			
			var xmlResult:XML;
			var utilityObj:Utility	=		new Utility();
			xmlResult 				= 		utilityObj.getDecodedXML((XML)(event.result));
			
			//var xmlResult:XML = XML(event.result);
			var childXml:XML;
			
			for(var i:int=0; i < xmlResult.children().length(); i++)
			{
				childXml = xmlResult.children()[i];
				addNewRow(childXml)
			}
			
			if(countResultOfExecutedServices == countExecutedServices)//means we have all services result
			{
				assignNewRows();
			}
		}
		private function assignNewRows():void
		{
			__detailEditObj.genDataGrid.rows = detailRows;
			__genModel.activeModelLocator.addEditObj.addEditContainer.dispatchEvent(new FetchRecordEvent(FetchRecordEvent.SELECTCOMPLETE_EVENT));
			CursorManager.removeBusyCursor();
			Application.application.enabled	=	true;
			
		}		
		
		private function executeMultiSelectFunctionalities():void
		{
			var childXml:XML;
			var atleastOneIsSelected:Boolean	=	false;
			var i:int	=	0; 
			if(__detailEditObj.isDetailRequired)
			{
				
				if(__detailEditObj.isOverrideDetail)//then call service in for loop and just assign new rows to grid
				{
					
					detailRows	=	new XML('<'+ detailRows.localName().toString()+ '/>')
					
					for(i=0; i < allFetchRows.children().length(); i++)
					{
						childXml = allFetchRows.children()[i];
		
						if(String(childXml.select_yn).toUpperCase() == 'Y')
						{
							++countExecutedServices;
							atleastOneIsSelected	=	true;
							var callbackGetSelectedDetail:Responder 		= new Responder(getMultipalSelectedDetailResultHandler, faultHandler);
							var delegate:GetFetchSelectedDetailDelegate 	= new GetFetchSelectedDetailDelegate(callbackGetSelectedDetail );
							delegate.getSelectedDetail(childXml[0].id.toString(), __detailEditObj.fetchGetSelectedDetailServiceID, __genModel.user.default_company_id);
							
						}
					}
					
					if(countExecutedServices == 0)
					{
						CursorManager.removeBusyCursor();
						Application.application.enabled	=	true;
					}	
				}
				else
				{
					// donot call service for already selected call only for new selected if nothing new is selected then do nothing
					//else apppend all resulted in grid
					for(i=0; i < allFetchRows.children().length(); i++)
					{
						childXml = allFetchRows.children()[i];
		
						if(String(childXml.select_yn).toUpperCase() == 'Y')
						{
							
							if(String(childXml.isAlreadyExist).toUpperCase() == 'Y')
							{
								
							}
							else
							{
								++countExecutedServices;
								atleastOneIsSelected							=	true;
								var callbackGetSelectedDetails:Responder 		= 	new Responder(getMultipalSelectedDetailResultHandler, faultHandler);
								var delegates:GetFetchSelectedDetailDelegate 	= 	new GetFetchSelectedDetailDelegate(callbackGetSelectedDetails );
								delegates.getSelectedDetail(childXml[0].id.toString(), __detailEditObj.fetchGetSelectedDetailServiceID, __genModel.user.default_company_id);
							}
						}
					}
					if(countExecutedServices == 0)
					{
						CursorManager.removeBusyCursor();
						Application.application.enabled	=	true;
					}		
				}
			}
			else// detail is not required no need to call service 
			{
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
								modifyUpdatableTags(existAtPosition,childXml)
							}
						}
						else
						{
							addNewRow(childXml)
						}	
					}
				}
				
				__detailEditObj.genDataGrid.rows = detailRows;
				__genModel.activeModelLocator.addEditObj.addEditContainer.dispatchEvent(new FetchRecordEvent(FetchRecordEvent.SELECTCOMPLETE_EVENT)); 
				CursorManager.removeBusyCursor();
				Application.application.enabled	=	true;
					
			}
		}

		/*to add new row in detail according to the mapping*/
		private function addNewRow(childXml:XML):void
		{
			var rootNode:String = (__detailEditObj.genDataGrid.rootNode);	
			var localName:String = rootNode.slice(0, rootNode.length - 1)
			var newRow:XML = new XML('<' + localName + '/>')
			var lsValue:String;
			
			for(var j:int=0; j < mappingArrCol.length; j++)
			{
				if(mappingArrCol.getItemAt(j).source == 'B')
				{
					//means we have to add blank field for this
					lsValue = '';
				}
				else
				{
					lsValue = childXml.child(mappingArrCol.getItemAt(j).source).toString();
				}

				var str:String = "<" + mappingArrCol.getItemAt(j).target + ">" + lsValue + "</" + mappingArrCol.getItemAt(j).target + ">"
				var tempChild:XML = new XML(str)
				
				newRow.appendChild(tempChild)
			}

			newRow.trans_flag = "A"
			newRow.id = "";//newRow.id = 0.00;
			newRow.serial_no = ""; 

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
					if(childXml.child(primaryKeys[k].source) == detailRows.children()[j].child(primaryKeys[k].target))
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
		private function modifyUpdatableTags(childPos:int , sourceXml:XML):void
		{
			for(var k:int = 0; k < mappingArrCol.length; k++)
			{
				if(String(mappingArrCol.getItemAt(k).updatable).toUpperCase() == 'Y')// we have to modified only which has updatable=Y
				{
					detailRows.children()[childPos].replace(mappingArrCol.getItemAt(k).target,sourceXml.child(mappingArrCol.getItemAt(k).source))
				}
			}
			
		}
		private function faultHandler(event:FaultEvent):void
		{
			Alert.show('FetchRecordSelectCommand' + event.fault.toString());	
		}
	}
}	
