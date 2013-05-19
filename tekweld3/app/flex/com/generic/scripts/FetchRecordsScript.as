// ActionScript file
import business.events.FetchRecordSelectEvent;
import business.events.InitializeFetchRecordsEvent;

import com.generic.customcomponents.GenTextInput;
import com.generic.events.FetchRecordEvent;

import flash.events.Event;
import flash.events.KeyboardEvent;

import model.GenModelLocator;

import mx.events.DataGridEvent;
import mx.events.ScrollEvent;
import mx.events.ScrollEventDirection;
import mx.formatters.DateFormatter;
import mx.managers.PopUpManager;
import mx.rpc.IResponder;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var initializeFetchRecordsEvent:InitializeFetchRecordsEvent;
private var fetchRecordSelectEvent:FetchRecordSelectEvent;
private var filterdRows:XML
private function creationCompleteHandler():void
{
	this.setFocus();
	__genModel.activeModelLocator.detailEditObj.detailEditContainer = vbMain;

	var callbacks:IResponder = new mx.rpc.Responder(callbackInitializeFetchRecords, null);
	initializeFetchRecordsEvent = new InitializeFetchRecordsEvent(dgFetchDtl,callbacks);
	initializeFetchRecordsEvent.dispatch(); 
}
private function callbackInitializeFetchRecords(str:String):void
{
	switch(str)
	{
		case 'STRUCTURE COMPLETED':
				createSearchInputs()
		break
		case 'DATA COMPLETED':
				filterdRows		=	dgFetchDtl.rows;
		break
	}
	
}
private function createSearchInputs():void
{
	var structure:XML	=	dgFetchDtl.structure
	var tiSearch:GenTextInput;
	for(var i:int = 0 ; i < structure.children().length()	;	i++)
	{
		if( structure.children()[i].@visible.toString()	==	'true')
		{
			tiSearch			=	new GenTextInput();
			tiSearch.name		=	structure.children()[i].@data.toString();
			tiSearch.dataType	=	structure.children()[i].@sortDataType.toString();
			
			/*when we focus out then text autometically set down to integer value because of code in GenTextInputScript 
			to resolve this problem we have done this*/
			if(structure.children()[i].@sortDataType.toString() == 'N')
			{
				var maxValue:String    =	'.' 
				if(structure.children()[i].@columnPrecision.toString()!= '' &&  Number(structure.children()[i].@columnPrecision.toString()) > 0)
				{
					for(var k:int = 0; k < Number(structure.children()[i].@columnPrecision.toString()) ; k++)
					{
						maxValue	=	maxValue + '9'  //we can take any integer value we have taken '9'
					}
					
					tiSearch.maxValue = Number(maxValue); //here maxValue is used just to set precesion value after focus out
				}
				else
				{
					tiSearch.maxValue = 1;
				}
			}
			
			
			tiSearch.width		=	Number(structure.children()[i].@width.toString());
			tiSearch.height		=	20;
			tiSearch.setStyle('textAlign' , structure.children()[i].@textAlign);
			tiSearch.addEventListener(KeyboardEvent.KEY_UP,filterRows);
			hbSearchBox.addChild(tiSearch);
		}
	}
	
	var arr:Array	=	hbSearchBox.getChildren();
	
	var lastChild:GenTextInput	=	GenTextInput( hbSearchBox.getChildAt(arr.length -1));
	lastChild.percentWidth		=	100;	
}
private function filterRows(event:Event):void
{
	var scrollPosition:Number	=	dgFetchDtl.horizontalScrollPosition;
	
	var searchedRows:XML = new XML('<'+ filterdRows.localName().toString()+ '/>')
	
	var tempList:XMLList	=	new XMLList();
	tempList				=	filterdRows.children();

	var arr:Array			=	hbSearchBox.getChildren();
	var filerKey:String ;
	var filterValue:String; 

	for(var i:int=0 ; i< arr.length; i++)
	{
		if(GenTextInput(arr[i]).text != '')
		{
			filerKey		=	arr[i].name;
			filterValue		=	arr[i].text;
			
			if(GenTextInput(arr[i]).dataType == "D")
			{
				tempList 		= 	tempList.(dateFunc(String(child(filerKey))).substr(0,filterValue.length).toUpperCase()	==	filterValue.toUpperCase())	
			}
			else
			{
				tempList 		= 	tempList.(String(child(filerKey)).substr(0,filterValue.length).toUpperCase()	==	filterValue.toUpperCase())
			}
		}
	}
	if(tempList.children().length() > 0)
	{
		searchedRows.appendChild(tempList);
		dgFetchDtl.rows	=	searchedRows;
	}
	else
	{
		dgFetchDtl.rows	=	new XML('<'+ filterdRows.localName().toString()+ '/>')
		//dgFetchDtl.rows	=	filterdRows
	}
	
	dgFetchDtl.horizontalScrollPosition	=	scrollPosition
	scrollDataGrid(dgFetchDtl.horizontalScrollPosition);
	
}
private function changeColumnSizeHandler(event:DataGridEvent):void
{
	GenTextInput(hbSearchBox.getChildByName(dgFetchDtl.columns[event.columnIndex].dataField.toString())).width	=	dgFetchDtl.columns[event.columnIndex].width;
}
private function onScroll(event:ScrollEvent):void 
{
	if(event.direction == ScrollEventDirection.HORIZONTAL)
	{
		var invisibleColumns:int = dgFetchDtl.horizontalScrollPosition
		scrollDataGrid(invisibleColumns)
	}
}
private function handleResize(event:Event):void
{
	scrollDataGrid(dgFetchDtl.horizontalScrollPosition)
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
		
		for(var j:int=invisibleColumns; j < dgFetchDtl.columns.length; j++)
		{
			ary[j].visible = true
			ary[j].width = dgFetchDtl.columns[j].width
		}
		var lastChild:GenTextInput	=	GenTextInput(hbSearchBox.getChildAt(ary.length -1));
		lastChild.percentWidth		=	100;	
	}
}
private function selectButtonClickHandler():void
{
	fetchRecordSelectEvent	=	new FetchRecordSelectEvent(filterdRows);
	fetchRecordSelectEvent.dispatch();
	closeHandler();
}
private function itemFocusOutEventHandler(event:Event):void
{
	if(__genModel.activeModelLocator.detailEditObj.isFetchSingleSelected)
	{ 
		if(String(dgFetchDtl.selectedRow.child('select_yn')).toUpperCase()	==	'Y')
		{
			var currentSelectedRowId:int;
			currentSelectedRowId		=	int(dgFetchDtl.selectedRow.child('id').toString())
			
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
}
private function closeHandler():void
{
	__genModel.activeModelLocator.addEditObj.addEditContainer.dispatchEvent(new FetchRecordEvent(FetchRecordEvent.FETCHWINDOWCANCEL_EVENT));
	PopUpManager.removePopUp(this)
}

private function selectRow():void
{
	if(dgFetchDtl.selectedRow.select_yn == 	 'Y')
	{
		dgFetchDtl.selectedRow.select_yn = 	 'N'
	}
	else
	{
		dgFetchDtl.selectedRow.select_yn = 	 'Y'
	}
	
	dgFetchDtl.dispatchEvent(new DataGridEvent(DataGridEvent.ITEM_FOCUS_OUT));
}
private function dateFunc(item:String):String
{
	var dateFormatter:DateFormatter = new DateFormatter();
	var date_format:String = __genModel.user.date_format.toLocaleUpperCase();
		
	if(date_format == null || date_format == "")
	{
		dateFormatter.formatString = 'MM/DD/YYYY';
	}
	else
	{
		dateFormatter.formatString = date_format;
	}

	return dateFormatter.format(item.toString());
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