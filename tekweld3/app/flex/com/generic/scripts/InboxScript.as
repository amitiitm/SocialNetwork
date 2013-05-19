import business.events.InboxDrillDownEvent;
import business.events.RecordStatusEvent;
import com.generic.customcomponents.GenTextInput;
import com.generic.events.EditBarEvent;
import com.generic.events.InboxEvent;
import model.GenModelLocator;
import mx.collections.ListCollectionView;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.Application;
import mx.events.DataGridEvent;
import mx.events.FlexEvent;
import mx.events.ListEvent;
import mx.events.ScrollEvent;
import mx.events.ScrollEventDirection;
import mx.formatters.DateFormatter;
import mx.managers.CursorManager;
import mx.rpc.IResponder;

private var _rows:XML;
private var _selectedRows:XML; // VD 24 March, 2010 only select_yn in grid will come here, we will send this to save
private var _focusedRow:XML;
private var _structure:XML;
private var recordStatusEvent:RecordStatusEvent;

public var oldValues:XML;
public var recordStatusEnabled:Boolean = true;
public var editBarRowPosition:int;
public var tableName:String;
private var __genModel:GenModelLocator	=	GenModelLocator.getInstance();
private var filterdRows:XML //for search text inputs functionality.
public var isSortable:Boolean = true;

public function set rowColorFunction(func:Function):void
{
	dgDtl.rowColorFunction = func
}

public function reset():void
{
	editBar.visible = false; // VD 0207
	editBarRowPosition = -1
	editBar.reset()
	scrollDataGrid(dgDtl.horizontalScrollPosition);
	scrollSearchInputs(dgDtl.horizontalScrollPosition);//for search inputs
}

public function set rows(aXML:XML):void
{
	reset();
	resetSearchValues();
 	_rows = aXML;
 	oldValues = aXML.copy();
	dgDtl.rows = aXML;
	
	filterdRows	=	dgDtl.rows; // for search text input
}

public function get rows():XML
{
   	return _rows;
}

public function set focusedRow(aXML:XML):void
{
	_focusedRow = aXML;
	dgDtl.selectedRow = aXML;
	editBar.record = aXML;
	
	dispatchEvent(new InboxEvent(InboxEvent.INBOX_ROW_CHANGED, null, null, aXML));
}

public function get focusedRow():XML
{
   	return _focusedRow;
}

public function get selectedRows():XML
{
	var rootNode:String = rows.localName().toString();
	var xml:XML = new XML("<" + rootNode + " />")

	for(var i:int=0; i < dgDtl.dataProvider.length; i++)
	{
		if(dgDtl.dataProvider[i].select_yn == 'Y')
		{
			xml.appendChild(dgDtl.dataProvider[i]);
		}
	}
	
	_selectedRows = xml
	
   	return _selectedRows;
}

public function set structure(aXML:XML):void
{
	_structure = aXML;
	dgDtl.structure = aXML;
	editBar.structure = aXML;
	
	createSearchInputs();
}

public function get structure():XML
{
	return _structure;
}

private function handleUpdateComplete(event:FlexEvent):void
{
	dispatchEvent(new InboxEvent(InboxEvent.INBOX_UPDATE_COMPLETE));
}

private function creationCompleteHandler():void
{
	dgDtl.rows = new XML('<rows />');
	dgDtl.selectedRow = null;
	
	editBar.height = dgDtl.rowHeight;
	editBar.visible = false;
}

private function moveEditbar():void
{
	focusedRow = dgDtl.dataProvider[editBarRowPosition]

	if((editBarRowPosition % 2) == 0)
	{
		editBar.setStyle("backgroundColor", '#F1F4F9')
	}
	else
	{
		editBar.setStyle("backgroundColor", '#FFFFFF')
	}

	editBar.height = dgDtl.rowHeight;
	editBar.lastColumnWidth();
	editBar.visible = true;
	editBar.move(2, ((editBarRowPosition - dgDtl.verticalScrollPosition) * dgDtl.rowHeight + 41)) //it was 19 when search input was not there.
	
	resetSortColumns();
	
	var invisibleColumns:int = dgDtl.horizontalScrollPosition
	scrollDataGrid(invisibleColumns);
	scrollSearchInputs(invisibleColumns); //for search inputs
}

private function scrollDataGrid(invisibleColumns:int):void 
{
	var ary:Array = editBar.getChildren()
	
	if(ary.length > 0)
	{
		for(var i:int=0; i<invisibleColumns; i++)
		{
			ary[i].visible = false
			ary[i].width = 0
		}
		
		for(var j:int=invisibleColumns; j < dgDtl.columns.length; j++)
		{
			ary[j].visible = true
			ary[j].width = dgDtl.columns[j].width
		}
	}
}

private function moveToPreviousRow():Boolean
{
	var flag:Boolean=false;
	
	if(editBarRowPosition > 0)
	{
		editBarRowPosition = editBarRowPosition - 1
		dgDtl.scrollToIndex(editBarRowPosition);
		moveEditbar()
		flag = true
	}

	return flag
}

private function moveToNextRow():Boolean
{
	var flag:Boolean=false;

	if(editBarRowPosition < dgDtl.dataProvider.length - 1)
	{
		editBarRowPosition = editBarRowPosition + 1;
		dgDtl.scrollToIndex(editBarRowPosition);
		moveEditbar()
		flag = true
	}
	
	return flag;
}

private function handleUpKeyEvent(event:EditBarEvent):void
{
	moveToPreviousRow()
}

private function handleShiftTabKeyEvent(event:EditBarEvent):void 
{
	if(moveToPreviousRow())
	{
		editBar.getColumn(editBar.lastEditableCompID).setFocus()
	}
}

private function handleDownKeyEvent(event:EditBarEvent):void
{
	moveToNextRow()
}

private function handleTabKeyEvent(event:EditBarEvent):void 
{
	if(moveToNextRow())
	{
		editBar.getColumn(editBar.firstEditableCompID).setFocus()
	}
}

private function handleScrollOnTabEvent(event:EditBarEvent):void
{
	if(event.object.x > dtl.width - 25)
	{
		dgDtl.horizontalScrollPosition = dgDtl.maxHorizontalScrollPosition + 1;
	}

	if(event.object.x < dtl.x + 25)
	{
		dgDtl.horizontalScrollPosition = 0;
	}

	scrollDataGrid(dgDtl.horizontalScrollPosition);
	scrollSearchInputs(dgDtl.horizontalScrollPosition)//for search inputs
}

private function handleResize(event:Event):void
{
	reset()
}

private function onScroll(event:ScrollEvent):void 
{
	if(event.direction == ScrollEventDirection.HORIZONTAL)
	{
		var invisibleColumns:int = dgDtl.horizontalScrollPosition
		scrollDataGrid(invisibleColumns);
		scrollSearchInputs(invisibleColumns);
	}
	else
	{
		reset()	
	}
}

private function handleItemClick(event:ListEvent):void
{
	editBarRowPosition = event.rowIndex
	moveEditbar();
	resetSortColumns();	
}

private function handleEditBarDoubleCilckEvent(event:EditBarEvent):void
{
	if(__genModel.activeModelLocator.listObj.isdrilldownrow == "Y")
	{
		__genModel.drillObj.drillrow		=	XML(dgDtl.dataProvider[editBarRowPosition])
		__genModel.drillObj.drillcolumn		=	dgDtl.colname.toString()
	
		var callback:IResponder	=	new mx.rpc.Responder(callbackDrillEventHandler,null);
	
		var drillDownEvent:InboxDrillDownEvent	=	new InboxDrillDownEvent(callback);
		drillDownEvent.dispatch();	
	}  
}

private function callbackDrillEventHandler(obj:Object):void
{
	
}

public function handleColumnStretch(event:DataGridEvent):void
{
	var ary:Array = (event.target).columns;
	var dgc:DataGridColumn = ary[event.columnIndex]

	editBar.getColumn(event.dataField.toString()).width = dgc.width;
	GenTextInput(hbSearchBox.getChildByName(dgc.dataField.toString())).width = dgc.width;
	
	reset();
}

private function handleEditBarItemChangedEvent(event:EditBarEvent):void
{
	dispatchEvent(new InboxEvent(InboxEvent.INBOX_ITEM_FOCUS_OUT, event.object, oldValues.children()[editBarRowPosition], focusedRow));
	focusedRow = dgDtl.dataProvider[editBarRowPosition]
	resetSortColumns();
}

private function createSearchInputs():void
{	
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
			
			tiSearch.width 	= Number(structure.children()[i].@width.toString());
			tiSearch.height = 20;
			tiSearch.setStyle('textAlign', structure.children()[i].@textAlign);
			tiSearch.addEventListener(KeyboardEvent.KEY_UP,enterHandler2);
			tiSearch.addEventListener(KeyboardEvent.KEY_DOWN,enterHandler);
			
			hbSearchBox.addChild(tiSearch);
		}
	}
	
	var arr:Array = hbSearchBox.getChildren();
	
	var lastChild:GenTextInput = GenTextInput( hbSearchBox.getChildAt(arr.length -1));
	lastChild.percentWidth = 100;	 
}

private function enterHandler(event:KeyboardEvent):void
{
	if(event.keyCode == Keyboard.ENTER)
	{
		setTimeout(filterRows, 1000);
	} 
}

private function enterHandler2(event:KeyboardEvent):void
{
	if(event.keyCode == Keyboard.ENTER)
	{
		Application.application.enabled = false;
		CursorManager.setBusyCursor();
	} 
}

private function filterRows():void
{
	if(filterdRows == XML(undefined) || filterdRows == null || filterdRows.children().length()<=0)
	{
		Application.application.enabled = true;
		CursorManager.removeBusyCursor();
		return;
	}
	
	var searchedRows:XML = new XML('<'+ filterdRows.localName().toString()+ '/>')
	
	var tempList:XMLList = new XMLList();
	tempList = filterdRows.children();
	
	var arr:Array = hbSearchBox.getChildren();
	var filerKey:String ;
	var filterValue:String; 
	
	for(var i:int=0 ; i < arr.length; i++)
	{
		if(GenTextInput(arr[i]).text != '')
		{
			filerKey = arr[i].name;
			filterValue = arr[i].text;
			
			if(GenTextInput(arr[i]).dataType == "D")
			{
				tempList = tempList.(dateFunc(String(child(filerKey))).substr(0,filterValue.length).toUpperCase() == filterValue.toUpperCase())	
			}
			else
			{
				tempList = tempList.(String(child(filerKey)).substr(0,filterValue.length).toUpperCase() == filterValue.toUpperCase())
			}
		}
	}

	if(tempList.children().length() > 0)
	{
		searchedRows.appendChild(tempList);
		
		dgDtl.rows = searchedRows;
		//__genModel.activeModelLocator.listObj.filteredList	=	searchedRows;
	}
	else
	{
		dgDtl.rows = new XML('<'+ filterdRows.localName().toString()+ '/>')
		//__genModel.activeModelLocator.listObj.filteredList	=	new XML('<'+ filterdRows.localName().toString()+ '/>')
	}	 
	
	Application.application.enabled	= true;
	CursorManager.removeBusyCursor();
	
	reset();
		
	//dgDtl.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL,false,false,null,null,ScrollEventDirection.HORIZONTAL,null));	
}

private function scrollSearchInputs(invisibleColumns:int):void 
{
 	var ary:Array = hbSearchBox.getChildren()
	
	if(ary.length > 0)
	{
		for(var i:int=0; i<invisibleColumns; i++)
		{
			ary[i].visible = false
			ary[i].width = 0
		}
		
		for(var j:int=invisibleColumns; j < dgDtl.columns.length; j++)
		{
			ary[j].visible = true
			ary[j].width = dgDtl.columns[j].width
		}
		var lastChild:GenTextInput	=	GenTextInput( hbSearchBox.getChildAt(ary.length -1));
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

private function headerReleaseHandler(event:DataGridEvent):void
{
	reset();
}

private function resetSortColumns():void
{
	ListCollectionView(dgDtl.dataProvider).sort = null;
	//	ListCollectionView(dgDtl.dataProvider).refresh();
}
