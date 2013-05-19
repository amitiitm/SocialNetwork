package business.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.genclass.SortFieldFunction;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.CursorManager;
	
	public class SortOrderSelectionChangingCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var firstSortOrder:XML;
		private var secondSortOrder:XML;
		private var thirdSortOrder:XML; 
		private var tempTreeXML:XML;
				
		public function execute(event:CairngormEvent):void
		{
			CursorManager.setBusyCursor();
			Application.application.enabled	=	false;
			
			firstSortOrder = __genModel.activeModelLocator.sortOrderSelectionObj.selectedLevel1
			secondSortOrder	= __genModel.activeModelLocator.sortOrderSelectionObj.selectedLevel2
			thirdSortOrder = __genModel.activeModelLocator.sortOrderSelectionObj.selectedLevel3
			
			// Vivek Dubey 16 April 2010.
			if(!(firstSortOrder == null || secondSortOrder == null || thirdSortOrder == null))
			{
				changeLevel();
			}
			else
			{
				CursorManager.removeBusyCursor();
				Application.application.enabled	= true;
			}
		}

		private function changeLevel():void
		{
			var viewName:String = "";
			
			if(__genModel.activeModelLocator.viewObj.selectedView != null)
			{
				viewName = __genModel.activeModelLocator.viewObj.selectedView.name.toString()
			}
			
			var rootStr:String = "<rows name='treeRoot' value='" + viewName + "'></rows>"

			tempTreeXML = new XML(rootStr)

			if (__genModel.activeModelLocator.listObj.rows != null)
			{
				if (__genModel.activeModelLocator.listObj.rows.children().length() > 0)
				{
					if(validateSortField())
					{
						__genModel.activeModelLocator.listObj.filteredList = new SortFieldFunction().sortXML(firstSortOrder, secondSortOrder, thirdSortOrder, XML(__genModel.activeModelLocator.listObj.rows).copy())
						tempTreeXML.appendChild(addLevel1(__genModel.activeModelLocator.listObj.filteredList.children()).children());
					}
				}
				
				__genModel.activeModelLocator.treeObj.treeXml = tempTreeXML; // VD 4 Dec 2009 -- Moved from above if condition
			}
			
			CursorManager.removeBusyCursor();
			Application.application.enabled	= true;
		}
		
		private function validateSortField():Boolean
		{
			var flag:Boolean = true;
			var str:String = "";
			var sortXMLList:XMLList = __genModel.activeModelLocator.sortOrderSelectionObj.sortField;
			var dataXML:XML = __genModel.activeModelLocator.listObj.rows.children()[0];
			
			for(var i:int=0; i < sortXMLList.length(); i++)
			{
				str = sortXMLList[i]["data"].toString()
				if(!dataXML.hasOwnProperty(str))
				{
					Alert.show("Invalid column " + str.toLocaleUpperCase() + " exists in List XML, Tree will not generate.")
					flag = false
					break;
				}
			}
			
			return flag;
		}
		
		private function addLevel1(aXMLList:XMLList):XML
		{
			var xmlMain:XML = new XML(<row/>);
			var filterList:XMLList;
			var tempList:XMLList = aXMLList;
			var xml:XML;
			var i:int = 0;
			var strName:String;
			var strValue:String;

			if (tempList.length() > 0)
			{
				strName = firstSortOrder.data.toString();
		
				while(true)
				{
					strValue = tempList.elements(strName)[0].toString() 
					
					filterList = tempList.(elements(strName) == strValue)
		
					if(filterList.length() > 0)
					{
						xml = new XML(<row/>)
						
						xml.@['name'] = strName;
						xml.@['value'] = strValue;
						
						xmlMain.appendChild(addLevel2(xml, filterList))
						
						tempList = tempList.(elements(strName) != strValue)
					}
					
					if(tempList.length() == 0)
					{
						break;
					}
				}
			}

			return xmlMain;	
		}
		
		private function addLevel2(aXML:XML, aXMLList:XMLList):XML
		{
			var filterList:XMLList;
			var tempList:XMLList = aXMLList;
			var xml:XML;
			var i:int = 0;
			var strName:String
			var strValue:String
		
			if (tempList.length() > 0)
			{
				strName = secondSortOrder.data.toString();
		
				while(true)
				{
					strValue = tempList.elements(strName)[0].toString() 
					filterList = tempList.(elements(strName) == strValue)
		
					if(filterList.length() > 0)
					{
						xml = new XML(<row/>)
						
						xml.@['name'] = strName;
						xml.@['value'] = strValue;
						
						aXML.appendChild(addLevel3(xml, filterList))
						
						tempList = tempList.(elements(strName) != strValue)
					}
					
					if(tempList.length() == 0)
					{
						break;
					}
				}
			}

			return aXML;	
		}
		
		private function addLevel3(aXML:XML, aXMLList:XMLList):XML
		{
			var filterList:XMLList;
			var tempList:XMLList = aXMLList;
			var xml:XML;
			var i:int = 0;
			var strName:String
			var strValue:String
		
			if (tempList.length() > 0)
			{
				strName = thirdSortOrder.data.toString();
		
				while(true)
				{
					strValue = tempList.elements(strName)[0].toString() 
					filterList = tempList.(elements(strName) == strValue)
		
					if(filterList.length() > 0)
					{
						xml = new XML(<row/>)
						
						xml.@['name'] = strName;
						xml.@['value'] = strValue;
						
						aXML.appendChild(xml)
						
						tempList = tempList.(elements(strName) != strValue)
					}
					
					if(tempList.length() == 0)
					{
						break;
					}
				}
			}

			return aXML;	
		}
	}
}