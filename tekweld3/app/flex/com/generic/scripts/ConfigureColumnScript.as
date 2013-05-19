import business.events.ConfigureColumnOKEvent;
import business.events.GetColumnListEvent;

import com.generic.genclass.Utility;

import flash.events.KeyboardEvent;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.events.ListEvent;
import mx.managers.PopUpManager;
import mx.rpc.IResponder;

[Bindable]
private var columnListXml:XML=new XML(<columns></columns>);

[Bindable]
private var selectedColumnListXml:XML=new XML(<columns></columns>);

[Bindable]
private var groupColumnListXml:XML=new XML(<columns></columns>);

[Bindable]
private var selectedGroupListXml:XML=new XML(<columns></columns>);

private var dataXML:XML;
private var oldLayoutName:String;	
private var newLayoutName:String;
private var	selectedLayoutListStru:XML 
private var selectedLayout:XML;
private var isRunImmediately:Boolean = true; //because bydefault it is selected.
private var utility:Utility = new Utility();

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

private function closeHandler():void
{
	PopUpManager.removePopUp(this);
}

private function selectedColumnsRollOverHandler(event:ListEvent):void
{
	var i:int	=	0;
	if(XML(dgList2.rows).children()[event.rowIndex].child('column_datatype').toString() != 'N')
	{
		for(i=0; i < dgList2.columns.length; i++)
		{
			if(DataGridColumn(dgList2.columns[i]).headerText == 'Total')
			{
				DataGridColumn(dgList2.columns[i]).editable	= false;
			}
		}
	}
	else
	{
		for(i=0; i < dgList2.columns.length; i++)
		{
			if(DataGridColumn(dgList2.columns[i]).headerText == 'Total')
			{
				DataGridColumn(dgList2.columns[i]).editable	= true;
			}
		}
	}	  
}

private function creationCompleteHandler():void
{
	this.setFocus();
	this.x = (this.screen.width - this.width) / 3;
	this.y = (this.screen.height - this.height) / 3;
	
 	var callbacks:IResponder = new mx.rpc.Responder(getColumnListResultHandler, null);
	var getColumnListEvent:GetColumnListEvent =	new GetColumnListEvent(callbacks);

	getColumnListEvent.dispatch();
		
	selectedLayout		   = new XML(__genModel.activeModelLocator.layoutObj.selectedLayout)	
	//Alert.show("creation"+selectedLayout.toString())
	selectedLayoutListStru = new XML(__genModel.activeModelLocator.layoutObj.listFormat)
	
	oldLayoutName = selectedLayout.name.toString();
	newLayoutName = selectedLayout.name.toString();
	tiLayoutName.text	=	selectedLayout.name.toString();
	cbPrintOrientation.dataValue	=	selectedLayout.print_orientation.toString();
	nsLockedColumnCount.value		=	selectedLayout.lockedcolumncount;
}

private function getColumnListResultHandler(resultXml:XML):void
{
	dataXML	=	resultXml;
	
	if(dataXML != null && dataXML.children().length() > 0)
	{
		var groupableColumns:XMLList	=	XML(dataXML).children().(String(isgroupable.toString()).toUpperCase()	==	'Y')
		
		//for setting only groupable coluns in group tab left side grid , and filter those should be in right side grid. and move them
		if(groupableColumns.children().length() > 0)
		{
			var groupColumnList:XML	=	new XML(<columns/>)
			groupColumnList.appendChild(groupableColumns);
			groupColumnListXml = (groupColumnList).copy();
			
			filterForSelectedGroup();
		}
		
		//for setting lrft grid of columns tab and filter those should be in right grid and move them to right
		columnListXml 	= XML(dataXML).copy();	
		filterForSelectedColumns();
	}	
}

private function filterForSelectedGroup():void
{
	var tempSelectedGroupList:XMLList	=	XML(selectedLayoutListStru).children().(isgroup.toString().toUpperCase()	==	'Y')
	
	tempSelectedGroupList				=	utility.getSortedXmlList(tempSelectedGroupList ,'group_level', 'N')
	
	if(tempSelectedGroupList.length() > 0)
	{
		for(var k:int=0	; k< tempSelectedGroupList.length() ; k++)
		{
			for(var j:int=0 ; j < groupColumnListXml.children().length() ;j++)
			{
				if(groupColumnListXml.children()[j].id.toString()	==	tempSelectedGroupList[k].report_column_id.toString())
				{
					groupColumnListXml.children()[j].select_yn	=	'Y'
					
					btnAddGrpClickHandler();
					break;
				}
			}
		}
	}
}

private function filterForSelectedColumns():void
{
	for(var j:int	=	0	;	j < selectedLayoutListStru.children().length();	j++	)
	{
		for(var i:int	=	0	;	i < columnListXml.children().length();	i++	)
		{
			if(
				(columnListXml.children()[i].id.toString()	==	selectedLayoutListStru.children()[j].report_column_id.toString())
				 &&
				(selectedLayoutListStru.children()[j].isvisible	==	'Y'))
			{
				if(selectedLayoutListStru.children()[j].istotal.toString()	==	'Y')
				{
					columnListXml.children()[i].istotal	=	'Y'
				}
				columnListXml.children()[i].select_yn	=	'Y';
				columnListXml.children()[i].print_width	=	selectedLayoutListStru.children()[j].print_width.toString();
				btnAddClickHandler();
				break;
			}
		}	
	}
}

public function btnAddClickHandler():void
{
	var aXML1:XML = <columns></columns>;
	var aXML2:XML = selectedColumnListXml;
	var aXML3:XML = columnListXml;
	updateGrid(aXML1,aXML2,aXML3,"ADD");
}

public function btnRemoveClickHandler():void
{
	var aXML1:XML = <columns></columns>;
	var aXML2:XML = columnListXml;
	var aXML3:XML = selectedColumnListXml;
	updateGrid(aXML1,aXML2,aXML3,"REMOVE");
}

private function updateGrid(aXML1:XML,aXML2:XML,aXML3:XML,str:String):void
{
	var tempXML1:XML = aXML1;
	var tempXML2:XML = aXML2;
	var tempXML3:XML = aXML3;	
	
	for(var i:int = 0; i < aXML3.children().length();i++)
	{ 
		if(aXML3.children()[i].select_yn.toString() == "Y")
		{
			aXML3.children()[i].select_yn ="N"
			aXML3.children()[i].group_select_yn ="N"
			aXML3.children()[i].summary_select_yn ="N"
			tempXML2.appendChild(aXML3.children()[i]);			
		} 
		else
		{
			tempXML1.appendChild(aXML3.children()[i]);
		}
	}
	
	if(str == "ADD")
	{
		columnListXml = tempXML1;
		selectedColumnListXml = tempXML2;
	}
	else
	{
		columnListXml = tempXML2;
		selectedColumnListXml = tempXML1;
	}	
	dgList1.rows=columnListXml;
	dgList2.rows=selectedColumnListXml;	
}

public function btnTopClickHandler():void
{
	updateRowsTopBottom("TOP");	
}

public function btnBottomClickHandler():void
{
	updateRowsTopBottom("BOTTOM");	
}

private function updateRowsTopBottom(str:String):void
{
	var tempXML1:XML = <columns></columns>;
	var tempXML2:XML = <columns></columns>;
	for(var i:int = 0; i < selectedColumnListXml.children().length();i++)
	{ 
		if(selectedColumnListXml.children()[i].select_yn.toString() == "Y")
		{
			selectedColumnListXml.children()[i].select_yn ="N"
			tempXML1.appendChild(selectedColumnListXml.children()[i]);
		} 
		else
		{
			tempXML2.appendChild(selectedColumnListXml.children()[i]);
		}
	}
	if(str == "TOP")
	{
		tempXML1.appendChild(tempXML2.children());
		selectedColumnListXml = tempXML1;		
	}
	else
	{
		tempXML2.appendChild(tempXML1.children());
		selectedColumnListXml = tempXML2;		
	}
	dgList2.rows=selectedColumnListXml;
}

public function btnUpClickHandler():void
{
	var tempXML:XML = <columns></columns>;
	
	for(var i:int = 0; i < selectedColumnListXml.children().length();i++)
	{
		 if(selectedColumnListXml.children()[i].select_yn.toString() == "Y" && i == 0)
		 {
		 	while(i < selectedColumnListXml.children().length() && selectedColumnListXml.children()[i].select_yn.toString() == "Y")
		 	{
		 		//selectedColumnListXml.children()[i].select_yn ="N"
		 		tempXML.appendChild(selectedColumnListXml.children()[i]);
		 		i++;
		 	}
		 	if(i < selectedColumnListXml.children().length())
		 	{
		 		i--;
		 	}
		 }
		 else if(selectedColumnListXml.children()[i].select_yn.toString() == "Y")
		 {
		 		//selectedColumnListXml.children()[i].select_yn ="N"
		 	 	tempXML.insertChildBefore(	tempXML.children()[i-1],selectedColumnListXml.children()[i]);	
		 }
		 else
		 {
		 	tempXML.appendChild(selectedColumnListXml.children()[i]);
		 }
	}

	selectedColumnListXml = tempXML;
	dgList2.rows=selectedColumnListXml;
}

public function btnDownClickHandler():void
{
	var tempXML:XML = <columns></columns>;
	var j:int;

	for(var i:int = 0;i<selectedColumnListXml.children().length();i++)
	{
		j = i;
		if(selectedColumnListXml.children()[i].select_yn.toString() == "Y")
		{
			while(i<selectedColumnListXml.children().length() && selectedColumnListXml.children()[i].select_yn.toString() == "Y" )
			{
				//selectedColumnListXml.children()[i].select_yn ="N"
				tempXML.appendChild(selectedColumnListXml.children()[i]);
				i++;
			}
			if(i<selectedColumnListXml.children().length())
			{
				//selectedColumnListXml.children()[i].select_yn ="N"
				tempXML.insertChildBefore(tempXML.children()[j],selectedColumnListXml.children()[i]);
			}
		}
		else if(selectedColumnListXml.children()[i].select_yn.toString() == "N")
		{
			//selectedColumnListXml.children()[i].select_yn ="N"
			tempXML.appendChild(selectedColumnListXml.children()[i]);
		}
	} 
	selectedColumnListXml = tempXML;
	dgList2.rows=selectedColumnListXml; 	
}

public function btnOkClickHandler():void
{
	if(tiLayoutName.text	==	'')
	{
		Alert.show('please give name to this layout');	
		return;
	}
	else if(oldLayoutName.toUpperCase() == newLayoutName.toUpperCase() &&  String(selectedLayout.layout_type).toUpperCase() == 'S')
	{
		Alert.show('This is a system generated layout. Please change name to create user layout...!');
		return;
	}
	
	else
	{
		var j:int	=	0;
		if(oldLayoutName.toUpperCase() != newLayoutName.toUpperCase())
		{
			if(isSameNameLayoutAlreadyExist(__genModel.activeModelLocator.layoutObj.layout,newLayoutName) >= 0)
			{
			 		Alert.show('same name layout already exist.');
			 		return;
			}
			else
			{
				selectedLayout.name = newLayoutName;
				selectedLayout.id	= ''//0;
			}
		}
		
		var saveXml:XML				=	selectedColumnListXml.copy()	//savexML is taken as selectedColumnsXml
		var selectedGroupXml:XML	=	selectedGroupListXml.copy()
		
		
		var tempXmlList:XMLList	=	new XMLList();
		var group_level:int		=	0;
		var column_sequence:int	=	0;
		
		//firstly we are setting this to all selected columns list
		for(j= 0; j < saveXml.children().length()	;	j++)
		{
			saveXml.children()[j].isgroup	=	'N'
			saveXml.children()[j].isvisible	=	'Y'
			saveXml.children()[j].column_sequence	=	++column_sequence
		}
		
		//we are searching in saveXml for common columns in selectedGroupXml
		for(j = 0; j < selectedGroupXml.children().length()	;	j++)
		{
			tempXmlList	=		saveXml.children().(id.toString()	==	selectedGroupXml.children()[j].id.toString())	

			if(tempXmlList.children().length() > 0)//means both side present
			{
				tempXmlList.isgroup	=	'Y'
				tempXmlList.group_level	=	++group_level;
				tempXmlList.isvisible	=	'Y'
				
			}
			else//present in group but not in selected columns
			{
				selectedGroupXml.children()[j].isgroup	=	'Y'
				selectedGroupXml.children()[j].group_level	=	++group_level;
				selectedGroupXml.children()[j].isvisible	=	'N'
				
				selectedGroupXml.children()[j].column_sequence	=	++column_sequence
				
				saveXml.appendChild(selectedGroupXml.children()[j])
			}
		} 
		
		//we have to send report_column_id	for id . and 0 as its id. and have to change tagname
		for(var k:int = 0 ; k < saveXml.children().length() ; k++)
		{
			 saveXml.children()[k].report_column_id	=	 saveXml.children()[k].id.toString()
			 saveXml.children()[k].id				=	''// 0
			 XML(saveXml.children()[k]).setName('report_layout_column');
		}
		saveXml.setName('report_layout_columns');
		
		selectedLayout.report_layout_columns	=	saveXml
	
		selectedLayout.print_orientation		=	cbPrintOrientation.dataValue;
		selectedLayout.lockedcolumncount		=	nsLockedColumnCount.value ;	
		//	selectedLayout.report_layout_columns	=	utility.convertElementXmlToAttributeXml(saveXml)
		//	Alert.show("selected"+selectedLayout.toString())
		var configureColumnOKEvent:ConfigureColumnOKEvent = new ConfigureColumnOKEvent(selectedLayout, isRunImmediately);
		configureColumnOKEvent.dispatch();
		
		closeHandler();
	}
}

private function layoutNameChangeEventHandler():void
{
	newLayoutName = tiLayoutName.text;
}

// functions of Group tab 
public function btnAddGrpClickHandler():void
{
	var aXML1:XML = <columns></columns>;
	var aXML2:XML = selectedGroupListXml;
	var aXML3:XML = groupColumnListXml;
	updateGridGrp(aXML1,aXML2,aXML3,"ADD");
}

public function btnRemoveGrpClickHandler():void
{
	var aXML1:XML = <columns></columns>;
	var aXML2:XML = groupColumnListXml;
	var aXML3:XML = selectedGroupListXml;
	updateGridGrp(aXML1,aXML2,aXML3,"REMOVE");
}

private function updateGridGrp(aXML1:XML,aXML2:XML,aXML3:XML,str:String):void
{
	var tempXML1:XML = aXML1;
	var tempXML2:XML = aXML2;
	var tempXML3:XML = aXML3;	
	
	for(var i:int = 0; i < aXML3.children().length();i++)
	{ 
		if(aXML3.children()[i].select_yn.toString() == "Y")
		{
			aXML3.children()[i].select_yn ="N"
			aXML3.children()[i].group_select_yn ="N"
			aXML3.children()[i].summary_select_yn ="N"
			tempXML2.appendChild(aXML3.children()[i]);			
		} 
		else
		{
			tempXML1.appendChild(aXML3.children()[i]);
		}
	}
	
	if(str == "ADD")
	{
		groupColumnListXml = tempXML1;
		selectedGroupListXml = tempXML2;
	}
	else
	{
		groupColumnListXml = tempXML2;
		selectedGroupListXml = tempXML1;
	}	
	dgListGrp1.rows=groupColumnListXml;
	dgListGrp2.rows=selectedGroupListXml;	
}

public function btnTopGrpClickHandler():void
{
	updateRowsTopBottomGrp("TOP");
}

public function btnBottomGrpClickHandler():void
{
	updateRowsTopBottomGrp("BOTTOM");
}

private function updateRowsTopBottomGrp(str:String):void
{
	var tempXML1:XML = <columns></columns>;
	var tempXML2:XML = <columns></columns>;
	for(var i:int = 0; i < selectedGroupListXml.children().length();i++)
	{ 
		if(selectedGroupListXml.children()[i].select_yn.toString() == "Y")
		{
			selectedGroupListXml.children()[i].select_yn ="N"
			tempXML1.appendChild(selectedGroupListXml.children()[i]);
		} 
		else
		{
			tempXML2.appendChild(selectedGroupListXml.children()[i]);
		}
	}
	if(str == "TOP")
	{
		tempXML1.appendChild(tempXML2.children());
		selectedGroupListXml = tempXML1;		
	}
	else
	{
		tempXML2.appendChild(tempXML1.children());
		selectedGroupListXml = tempXML2;		
	}
	dgList2.rows=selectedGroupListXml;
}

public function btnUpGrpClickHandler():void
{
	var tempXML:XML = <columns></columns>;;
	
	for(var i:int = 0; i < selectedGroupListXml.children().length();i++)
	{
		 if(selectedGroupListXml.children()[i].select_yn.toString() == "Y" && i == 0)
		 {
		 	while(i < selectedGroupListXml.children().length() && selectedGroupListXml.children()[i].select_yn.toString() == "Y")
		 	{
		 		//selectedGroupListXml.children()[i].select_yn ="N"
		 		tempXML.appendChild(selectedGroupListXml.children()[i]);
		 		i++;
		 	}
		 	if(i < selectedGroupListXml.children().length())
		 	{
		 		i--;
		 	}
		 }
		 else if(selectedGroupListXml.children()[i].select_yn.toString() == "Y")
		 {
		 		//selectedGroupListXml.children()[i].select_yn ="N"
		 	 	tempXML.insertChildBefore(	tempXML.children()[i-1],selectedGroupListXml.children()[i]);	
		 }
		 else
		 {
		 	tempXML.appendChild(selectedGroupListXml.children()[i]);
		 }
	}
	
	selectedGroupListXml = tempXML;
	dgListGrp2.rows=selectedGroupListXml;
}

public function btnDownGrpClickHandler():void
{
	var tempXML:XML = <columns></columns>;
	var j:int;
	
	for(var i:int = 0;i<selectedGroupListXml.children().length();i++)
	{
		j = i;
		if(selectedGroupListXml.children()[i].select_yn.toString() == "Y")
		{
			while(i<selectedGroupListXml.children().length() && selectedGroupListXml.children()[i].select_yn.toString() == "Y" )
			{
				//selectedGroupListXml.children()[i].select_yn ="N"
				tempXML.appendChild(selectedGroupListXml.children()[i]);
				i++;
			}
			if(i<selectedGroupListXml.children().length())
			{
				//selectedGroupListXml.children()[i].select_yn ="N"
				tempXML.insertChildBefore(tempXML.children()[j],selectedGroupListXml.children()[i]);
			}
		}
		else if(selectedGroupListXml.children()[i].select_yn.toString() == "N")
		{
			//selectedGroupListXml.children()[i].select_yn ="N"
			tempXML.appendChild(selectedGroupListXml.children()[i]);
		}
	} 
	selectedGroupListXml = tempXML;
	dgListGrp2.rows=selectedGroupListXml; 
}

private function isSameNameLayoutAlreadyExist(layouts:XML ,newLayoutName:String):int
{
	var existAtPosition:int	=	-1;
	
	for(var i:int= 0 ; i < layouts.children().length() ; i++)
	{
		if(String(layouts.children()[i].name).toUpperCase() == newLayoutName.toUpperCase())
		{
				existAtPosition	=	i;
				break;	
		}
	}
	return existAtPosition;
}
private function detailKeyDownHandler(event:KeyboardEvent):void
{
	//it is needed otherwise keydown at application level will also work.

	var char:String 		= 	String.fromCharCode(event.charCode).toUpperCase();	
	
	if(event.ctrlKey &&  char != 'V')// we donot want to stop event when user press  ctrl + V(paste),so we cannot take ctrl + V as shortcust now 
	{
		event.stopImmediatePropagation();
		event.stopPropagation();
	}	

}