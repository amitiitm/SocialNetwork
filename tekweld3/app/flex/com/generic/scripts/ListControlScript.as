import com.generic.customcomponents.GenTextInput;
import com.generic.events.GenDataGridEvent;
import com.generic.events.ListControlEvent;

import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.utils.setTimeout;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.core.Application;
import mx.events.DataGridEvent;
import mx.events.ScrollEvent;
import mx.events.ScrollEventDirection;
import mx.formatters.DateFormatter;
import mx.managers.CursorManager;

[Bindable]
public var _filteredList:XML; 

[Bindable]
public var _listFormat:XML;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var localFilterListChange:Boolean = false; // for search text input.

private function itemClickHandler(event:GenDataGridEvent):void
{
	__genModel.activeModelLocator.listObj.selectedRow = dgList.selectedRow;
	dispatchEvent(new ListControlEvent('itemClickEvent')); 
}	

private function itemDoubleClickHandler(event:GenDataGridEvent):void
{
	__genModel.activeModelLocator.listObj.selectedRow	=	dgList.selectedRow;
	dispatchEvent(new ListControlEvent('itemDoubleClickEvent')); 
}
[Bindable]	
public function get filteredList():XML
{
	return _filteredList
}
public function set filteredList(aXML:XML):void
{
	_filteredList	=	aXML;
	
	if(localFilterListChange)
	{
		localFilterListChange	=	false;
	}
	else
	{
		resetSearchValues();
	}
	
	scrollDataGrid(dgList.horizontalScrollPosition);
}
[Bindable]
public function get listFormat():XML
{
	return _listFormat;
}
public function set listFormat(aXML:XML):void
{
	_listFormat	=	aXML;
	createSearchInputs();
}

private function createSearchInputs():void
{	
	var structure:XML	=	listFormat.copy();
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
			tiSearch.addEventListener(KeyboardEvent.KEY_UP,enterHandler2);
			tiSearch.addEventListener(KeyboardEvent.KEY_DOWN,enterHandler);
			
			hbSearchBox.addChild(tiSearch);
		}
	}	
	var arr:Array	=	hbSearchBox.getChildren();
	
	var lastChild:GenTextInput	=	GenTextInput( hbSearchBox.getChildAt(arr.length -1));
	lastChild.percentWidth		=	100;	 
}
private function enterHandler(event:KeyboardEvent):void
{
	if(event.keyCode	==	Keyboard.ENTER)
	{
		setTimeout(filterRows,1000);
	} 
}
private function enterHandler2(event:KeyboardEvent):void
{
	if(event.keyCode	==	Keyboard.ENTER)
	{
		Application.application.enabled	=	false;
		CursorManager.setBusyCursor();
	} 
}
private function filterRows():void
{
 	var filterdRows:XML		=	XML(__genModel.activeModelLocator.listObj.rows).copy()
	
	if(filterdRows == XML(undefined) || filterdRows == null || filterdRows.children().length()<=0)
	{
		Application.application.enabled	=	true;
		CursorManager.removeBusyCursor();
		return;
	}
	
	var searchedRows:XML 	= 	new XML('<'+ filterdRows.localName().toString()+ '/>')
	
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
		localFilterListChange								=	true;
		__genModel.activeModelLocator.listObj.filteredList	=	searchedRows;
		
	}
	else
	{
		localFilterListChange								=	true;
		__genModel.activeModelLocator.listObj.filteredList	=	new XML('<'+ filterdRows.localName().toString()+ '/>')
		
	}	 
	
	Application.application.enabled	=	true;
	CursorManager.removeBusyCursor();	
}
private function changeColumnSizeHandler(event:DataGridEvent):void
{
	GenTextInput(hbSearchBox.getChildByName(dgList.columns[event.columnIndex].dataField.toString())).width	=	dgList.columns[event.columnIndex].width;
}
private function onScroll(event:ScrollEvent):void 
{
	 if(event.direction == ScrollEventDirection.HORIZONTAL)
	{
		var invisibleColumns:int = dgList.horizontalScrollPosition
		scrollDataGrid(invisibleColumns)
	} 
}
private function scrollDataGrid(invisibleColumns:int):void 
{
 	var ary:Array = hbSearchBox.getChildren()
	var ismorecolumns:Boolean = false;
	
	if(ary.length > 0)
	{
		for(var i:int=0; i<invisibleColumns; i++)
		{
			ary[i].visible = false
			ary[i].width = 0
		}
		
		for(var j:int=invisibleColumns; j < dgList.columns.length; j++)
		{
			ary[j].visible = true
			ary[j].width = dgList.columns[j].width
		}
		var lastChild:GenTextInput	=	GenTextInput(hbSearchBox.getChildAt(ary.length -1));
		lastChild.percentWidth		=	100;	
	} 				
} 

private function resetSearchValues():void
{
	var ary:Array = hbSearchBox.getChildren();
	if(ary.length > 0)
	{
		for(var i:int=0; i<ary.length; i++)
		{
			ary[i].dataValue = '';
		}
	} 
}
public function resetFilter():void
{
	var ary:Array = hbSearchBox.getChildren();
	
	if(ary.length > 0)
	{
		resetSearchValues();
		Application.application.enabled	=	false;
		CursorManager.setBusyCursor();
		setTimeout(filterRows,100)
					
	}			
}

public function filter():void
{
	var ary:Array = hbSearchBox.getChildren();
	
	if(ary.length > 0)
	{
		Application.application.enabled	=	false;
		CursorManager.setBusyCursor();
		setTimeout(filterRows,100)			
	}				
}
private function handleResize(event:Event):void
{
	scrollDataGrid(dgList.horizontalScrollPosition)
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