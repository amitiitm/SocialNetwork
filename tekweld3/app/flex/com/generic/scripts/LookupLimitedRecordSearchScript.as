import business.events.GetGenDataGridFormatEvent;
import business.events.GetInformationEvent;
import business.events.QuickAddEvent;

import com.generic.customcomponents.GenTextInput;
import com.generic.events.GenDataGridEvent;
import com.generic.events.LookupRecordSearchEvent;
import com.generic.genclass.Utility;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.events.DataGridEvent;
import mx.events.ScrollEvent;
import mx.events.ScrollEventDirection;
import mx.managers.CursorManager;
import mx.managers.PopUpManager;
import mx.rpc.IResponder;
import mx.utils.StringUtil;


private var __labelField:String;
private var __lookupName:String;
private var _filterdRows:XML;

private var _filterKeyName:String = "";
private var _filterKeyValue:String = "";

public  var targetObj:Object;
private var isRefreshBtnClicked:Boolean	=	false;
private var getInformationEvent:GetInformationEvent;
public var searchValue:String;
public var lookupFormatUrl:String = "";
public var minimumChar:int	=	0;

[Bindable]
private var width1:int;
private var width2:int;
private var width3:int;

[Bindable]
private var isNewButtonActive:Boolean	=	false;
[Bindable]
private var isEditButtonActive:Boolean	=	false;
[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var quickAddEvent:QuickAddEvent;
private var getGenDataGridFormatEvent:GetGenDataGridFormatEvent;
public var isMultiValueLookup:Boolean	=	false;


private function creationCompleteHandler():void
{
	this.x = (this.screen.width - this.width) / 3
	this.y = (this.screen.height - this.height) / 3
	
	gridLookup.formatServiceID		=	lookupFormatUrl;
	
	var callbacks:IResponder = new mx.rpc.Responder(callbackGridStructure, null);
	getGenDataGridFormatEvent = new GetGenDataGridFormatEvent(gridLookup,callbacks);
	getGenDataGridFormatEvent.dispatch();
	
	/* lbLabel.width = Number(DataGridColumn(gridLookup.columns[0]).width)
	tiCode.width = Number(DataGridColumn(gridLookup.columns[1]).width)
	tiName.percentWidth = 100; */
	if(!isMultiValueLookup)
	{
		tiFind.text	=	searchValue.toString();
		
		if(minimumChar > 0)
		{
			lblMessage.text	=	'Please type atleast '+ minimumChar.toString() + ' Character to find.'	
		}
		
		if(searchValue.length >= int(minimumChar))
		{
			CursorManager.setBusyCursor(); 
			
			var callbacks:IResponder = new mx.rpc.Responder(getItemsResultHandler, null);
			
			getInformationEvent	=	new GetInformationEvent('limitedlookup', callbacks , searchValue,lookupName,filterKeyName,filterKeyValue);
			getInformationEvent.dispatch(); 		
		}
	}
}

private function callbackGridStructure(str:String):void
{
	switch(str)
	{
		case 'STRUCTURE COMPLETED':
			createSearchInputs()
			break
	}
}

private function createSearchInputs():void
{
	var structure:XML	=	gridLookup.structure
	var tiSearch:GenTextInput;
	for(var i:int = 0 ; i < structure.children().length()	;	i++)
	{
		if( structure.children()[i].@visible.toString()	==	'true')
		{
			tiSearch		=	new GenTextInput();
			tiSearch.name	=	structure.children()[i].@data.toString();
			tiSearch.width	=	Number(structure.children()[i].@width.toString());
			tiSearch.height	=	20;
			tiSearch.setStyle('textAlign' , structure.children()[i].@textAlign);
			tiSearch.addEventListener(KeyboardEvent.KEY_UP,filterLookup);
			hbSearchBox.addChild(tiSearch);
		}
	}
}

private function changeColumnSizeHandler(event:DataGridEvent):void
{
	GenTextInput(hbSearchBox.getChildByName(gridLookup.columns[event.columnIndex].dataField.toString())).width	=	gridLookup.columns[event.columnIndex].width;
}

private function onScroll(event:ScrollEvent):void 
{
	if(event.direction == ScrollEventDirection.HORIZONTAL)
	{
		var invisibleColumns:int = gridLookup.horizontalScrollPosition
		scrollDataGrid(invisibleColumns)
	}
}

private function scrollDataGrid(invisibleColumns:int):void 
{
	var ary:Array = hbSearchBox.getChildren()
	
	if(ary.length > 0)
	{
		for(var i:int=0; i<invisibleColumns; i++)
		{
			ary[i].visible = false
			ary[i].width = 0
		}
		
		for(var j:int=invisibleColumns; j < gridLookup.columns.length; j++)
		{
			ary[j].visible = true
			ary[j].width = gridLookup.columns[j].width
		}
	}
}

private function getItemsResultHandler(resultXML:XML):void
{	
	var _resultXML:XML;
	var utilityObj:Utility		=		new Utility();
	_resultXML 					= 		utilityObj.getDecodedXML(resultXML);
	
	CursorManager.removeBusyCursor(); 
	filterdRows	=	_resultXML;
	
	if(filterdRows.children().length() > 0)
	{
		gridLookup.selectedIndex 	= 	0;
		gridLookup.selectedItem		=	gridLookup.dataProvider[0];	
		gridLookup.setFocus();
	}
}
private function keyUPEventHandler(event:KeyboardEvent):void
{
	if(event.keyCode == Keyboard.ENTER)
	{
		btnOKCilckHandler();
	}
	
}
private function selectExistingValues():void
{
	var tempString:String	=	targetObj.dataValue.toString()
	var tempArr:Array	=	tempString.split(',');
	var tempXmlList:XMLList;
	
	var length:int	=	0;
	length			=	filterdRows.children().length();
	
	for(var i:int=0 ; i < tempArr.length ; i++)
	{
		
		tempArr[i]	=	StringUtil.trim(tempArr[i].toString())
		tempXmlList	=	filterdRows.children().(String(child(labelField)).toUpperCase()	==	tempArr[i].toString().toUpperCase())
		if(tempXmlList.children().length()	> 0)
		{
			tempXmlList[0].select_yn	=	'Y';
		}
	}
}

private function closeHandler():void
{
	this.dispatchEvent(new LookupRecordSearchEvent(LookupRecordSearchEvent.LOOKUPCLOSE_EVENT))
	__genModel.objectFromQuickAdd	  = new XML(<rows></rows>);                                    // sarvesh 20apr2012
	
	PopUpManager.removePopUp(this);
}

[Bindable]
private function set filterdRows(aXML:XML):void
{
	_filterdRows	=	aXML;
}

private function get filterdRows():XML
{
	return _filterdRows;
}

public function set labelField(aString:String):void
{
	__labelField	=	aString;
}

public function get labelField():String
{
	return __labelField;
}

public function set filterKeyName(aString:String):void 
{
	_filterKeyName = aString;
}

public function get filterKeyName():String
{
	return _filterKeyName;
}

public function set filterKeyValue(aString:String):void 
{
	_filterKeyValue = aString;
}

public function get filterKeyValue():String
{
	return _filterKeyValue;
}

public function set lookupName(aString:String):void
{
	__lookupName				=	aString;
	this.title					=	aString;
	
	if(isMultiValueLookup)
	{
		return;
	}
	
	var menuXML:XML				=	__genModel.applicationObject.menu
	var createPermission:String	=	"N";
	var tempXMLList:XMLList		=	new XMLList(<root/>);
	var obj:Object				=	__genModel.lookupObj.getMasterInfo(aString);
	
	if(obj.modulePath.toString() ==	"")
	{
		return;
	}
	
	tempXMLList	=	menuXML.children().(component_cd.toString() == obj.modulePath.toString());
	
	if(!__genModel.lookupObj.isQuickAddActive)  // it is a first level Quick Add
	{
		if(tempXMLList.children().length() > 0)  // module exist in menu
		{
			if(tempXMLList[0].create_permission.toString()	==	'Y')  // user is having create permission 
			{
				isNewButtonActive	=	true;
			}
			if(tempXMLList[0].modify_permission.toString()	==	'Y')  // user is having modify permission 
			{
				isEditButtonActive	=	true;
			}
		}
	}
}

public function get lookupName():String
{
	return __lookupName;
}

private function btnOKCilckHandler():void
{
	var rows:XML		=	filterdRows//gridLookup.rows;
	
	var tempLabelValue:String	=	''
	
	if(isMultiValueLookup)//  we need to appned in existing values
	{
		tempLabelValue	=	targetObj.dataValue;
	}
	
	if(rows != null &&  rows != XML(undefined))
	{
		for (var i:int = 0 ; i < rows.children().length() ; i++)
		{
			if(rows.children()[i].select_yn	==	'Y')
			{
				if(tempLabelValue != '')
				{
					tempLabelValue	=	tempLabelValue + ',' + XML(rows.children()[i]).child(labelField).toString()
				}
				else
				{
					tempLabelValue	=	XML(rows.children()[i]).child(labelField).toString();
				}
			}
		}		
	}   	
	
	
	targetObj.dataValue	=	tempLabelValue;
	closeHandler();
}

private function btnCancelCilckHandler():void
{
	closeHandler();
}

private function btnrefreshCilckHandler():void
{
	/* CursorManager.setBusyCursor();
	var callbacks:IResponder = new mx.rpc.Responder(handleLookupUpResult, null);
	var getLookupDataEvent:GetLookupDataEvent = new GetLookupDataEvent(lookupName, callbacks);
	getLookupDataEvent.dispatch(); */
	
	btnFindCilckHandler()
}

private function handleLookupUpResult(result:Object):void
{
	CursorManager.removeBusyCursor();
	
	filterdRows	= 	(XML)(result);;
}

private function filterLookup(event:Event):void
{
	if(filterdRows == XML(undefined) ||  filterdRows == null)
	{
		return;
	}
	var searchedRows:XML = new XML('<'+ filterdRows.localName().toString()+ '/>')
	
	var tempList:XMLList	=	new XMLList();
	tempList				=	filterdRows.children();
	var arr:Array			=	hbSearchBox.getChildren();
	for(var i:int=0 ; i< arr.length; i++)
	{
		if(GenTextInput(arr[i]).text != '')
		{
			tempList = tempList.(String(child(arr[i].name)).substr(0,GenTextInput(arr[i]).text.length).toUpperCase()	==	GenTextInput(arr[i]).text.toUpperCase())	
		}
	}
	if(tempList.children().length() > 0)
	{
		searchedRows.appendChild(tempList);
		gridLookup.rows	=	searchedRows;
	}
	else
	{
		gridLookup.rows	=	new XML('<'+ filterdRows.localName().toString()+ '/>')
		//dgFetchDtl.rows	=	filterdRows
	}
	
}

/* 
private function filterLookup(event:Event):void
{
var textcode:String	=	tiCode.text;
var textname:String	=	tiName.text;
var searchedRows:XML = new XML('<'+ lookupRows.localName().toString()+ '/>')

var tempList:XMLList	=	new XMLList();
tempList				=		filterdRows.children();
if(textcode!='' && textname != '')
{
tempList = tempList.(String(child('code')).substr(0,textcode.length).toUpperCase()	==	textcode.toString().toUpperCase() && String(child('name')).substr(0,textname.length).toUpperCase()	==	textname.toString().toUpperCase())

}
else if(textcode!='')
{
tempList = tempList.(String(child('code')).substr(0,textcode.length).toUpperCase()	==	textcode.toString().toUpperCase())
}
else if(textname != '')
{
tempList = tempList.(String(child('name')).substr(0,textname.length).toUpperCase()	==	textname.toString().toUpperCase())
}


if(tempList.children().length() > 0)
{
searchedRows.appendChild(tempList);
gridLookup.rows	=	searchedRows;
}
else
{
gridLookup.rows	=	new XML('<'+ lookupRows.localName().toString()+ '/>');
//gridLookup.rows	=	filterdRows;
}	
}
*/

private function itemFocusOutEventHandler(event:Event):void
{
	if(isMultiValueLookup) //user can select multi values
	{
		return;
	}
	
	if(String(gridLookup.selectedRow.child('select_yn')).toUpperCase()	==	'Y')
	{
		var currentSelectedRowId:int;
		currentSelectedRowId		=	int(gridLookup.selectedRow.child('id').toString())
		
		var selectedChildList:XMLList	=	null;
		
		selectedChildList	=	filterdRows.children().(child('select_yn').toString().toUpperCase() == 'Y')
		
		//unselect previous selected
		for(var i:int = 0 ; i< selectedChildList.length() ; i++)
		{
			if(int(XML(selectedChildList[i]).child('id').toString()) !=	currentSelectedRowId)
			{
				selectedChildList[i].select_yn		=	'N'
			}
		}
	}		
}
private function selectRow():void
{
	if(gridLookup.selectedRow.select_yn == 	 'Y')
	{
		gridLookup.selectedRow.select_yn = 	 'N'
	}
	else
	{
		gridLookup.selectedRow.select_yn = 	 'Y'
	}
	
	gridLookup.dispatchEvent(new DataGridEvent(DataGridEvent.ITEM_FOCUS_OUT));
}
private function btnAddCilckHandler():void
{
	if(!__genModel.lookupObj.isQuickAddActive)
	{
		__genModel.lookupObj.lookupName		=		lookupName;	
		__genModel.lookupObj.refereshBtn	=		btnRefresh;				
		__genModel.lookupObj.findTextInput	=		tiFind;	
		__genModel.lookupObj.labelField		=		labelField;
		
		
		if(__genModel.activeModelLocator.hasOwnProperty('objectToQuickAdd'))
		{
			__genModel.objectFromQuickAdd	=   __genModel.activeModelLocator.objectToQuickAdd;
		}		
		quickAddEvent= new QuickAddEvent();
		quickAddEvent.dispatch();
	}		
}
private function itemClickHandler(event:GenDataGridEvent):void
{
	
}
private function btnEditCilckHandler():void
{
	if(!__genModel.lookupObj.isQuickAddActive && isEditButtonActive)
	{
		if(gridLookup.selectedRow != null)
		{
			var selectedRow:XML					=		XML(gridLookup.selectedRow).copy();
			
			if(selectedRow.hasOwnProperty('id'))
			{
				__genModel.lookupObj.lookupName		=		lookupName;	
				__genModel.lookupObj.refereshBtn	=		btnRefresh;
				__genModel.lookupObj.findTextInput	=		tiFind;	
				__genModel.lookupObj.labelField		=		labelField;
				
				quickAddEvent= new QuickAddEvent(selectedRow,null);
				quickAddEvent.dispatch();	
				
			}
			else
			{
				Alert.show('cannot edit some field missing.')
			}
			
		}
		else
		{
			Alert.show('please select row to modify.');	
		}
	}	
}

private function btnFindCilckHandler():void
{
	if(tiFind.text.length >= int(minimumChar))	
	{
		CursorManager.setBusyCursor(); 
		var callbacks:IResponder = new mx.rpc.Responder(getItemsResultHandler, null);
		
		getInformationEvent	=	new GetInformationEvent('limitedlookup', callbacks , tiFind.text,lookupName,filterKeyName,filterKeyValue);
		getInformationEvent.dispatch();		
	}
}
private function keyDownEnterHandler(event:KeyboardEvent):void
{
	if(event.keyCode == Keyboard.ENTER)
	{
		btnFindCilckHandler();
	}
}
