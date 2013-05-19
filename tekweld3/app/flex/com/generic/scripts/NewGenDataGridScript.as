import com.generic.events.NewGenDataGridEvent;
import com.generic.genclass.GenNumberFormatter;
import com.generic.genclass.SortFieldFunction;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.ClassFactory;
import mx.events.ListEvent;
import mx.formatters.DateFormatter;

import saoi.muduleclasses.CellRenderer;
public var colname:String;
private var cols:Array;
private var dgc:DataGridColumn;

// Property set/get from other components.
private var _updatableFlag:String = "false";
private var _checkBlankRowColumn:String = "";
private var _rootNode:String = "";

private var _rows:XML;
private var _selectedRow:XML;
private var _structure:XML;

private var _formatServiceID:String = "";
private var _deletedRows:XML;
private var _mergedRows:XML;
public var rowColorFunction:Function;
public var colColorFunction:Function;

public var handleDoubleClick:Boolean = false;	// VD 09 Dec 2009

// Need it to handle itemclick & itemdoubleclick both
private var localListEvent:ListEvent;
private var interval:Number=0;
// End

private var _viewOnlyFlag:Boolean = false
private var _keyColumn:Boolean = false
public var initialEditableFlag:Boolean = true

private var columnPrecision:Number;

private var numFormatter0:GenNumberFormatter = new GenNumberFormatter();
private var numFormatter1:GenNumberFormatter = new GenNumberFormatter();
private var numFormatter2:GenNumberFormatter = new GenNumberFormatter();
private var numFormatter3:GenNumberFormatter = new GenNumberFormatter();
private var numFormatter4:GenNumberFormatter = new GenNumberFormatter();
private var numFormatter5:GenNumberFormatter = new GenNumberFormatter();
private var numFormatter6:GenNumberFormatter = new GenNumberFormatter();


// *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
public function set viewOnlyFlag(aBoolean:Boolean):void
{
 	_viewOnlyFlag = aBoolean

 	if(initialEditableFlag)
 	{
 		dropEnabled = !aBoolean;
 		dragEnabled = !aBoolean;
 		dragMoveEnabled = !aBoolean;
 	}
}

public function get viewOnlyFlag():Boolean
{
 	return _viewOnlyFlag
}

public function set keyColumn(aBoolean:Boolean):void
{
 	_keyColumn = aBoolean
}

public function get keyColumn():Boolean
{
	return _keyColumn
}
// *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

public function set deletedRows(aXML:XML):void // Deleterow XML 
{
	_deletedRows = aXML;
}

public function get deletedRows():XML
{
   	return _deletedRows;
}

public function get mergedRows():XML
{
   	var _rows:XML			=	new XML(rows);
	var _deletedRows:XML	=	new XML(deletedRows) 
	var _merge:XML			=	_rows.appendChild(_deletedRows.children());
	
	_mergedRows = _merge;
   	return _mergedRows;
}

public function set selectedRow(aXML:XML):void // ? for drill down 
{
	_selectedRow = aXML;
}

public function get selectedRow():XML
{
   	return getSelectedRow();
} 

public function set structure(aXML:XML):void 
{
	_structure = aXML;
	createStructure()
}

public function get structure():XML
{
   	return _structure;
}

public function set rows(aXML:XML):void 
{
 	_rows = aXML;
	dataProvider = aXML.children();
}

public function get rows():XML
{
   	return _rows;
}

public function set formatServiceID(aString:String):void 
{
 	_formatServiceID = aString;
}

public function get formatServiceID():String
{
   	return _formatServiceID;
}

public function set updatableFlag(aString:String):void 
{
 	_updatableFlag = aString
}

public function get updatableFlag():String
{
 	return _updatableFlag
}

public function set checkBlankRowColumn(aString:String):void 
{
 	_checkBlankRowColumn = aString
}

public function get checkBlankRowColumn():String
{
 	return _checkBlankRowColumn
}

public function set rootNode(aString:String):void 
{
 	_rootNode = aString
}

public function get rootNode():String
{
 	return _rootNode
}

private function createStructure():void
{
	var visibleCount:int = 0;
	
	numFormatter0.precision = 0;
	numFormatter1.precision = 1;
	numFormatter2.precision = 2;
	numFormatter3.precision = 3;
	numFormatter4.precision = 4;
	numFormatter5.precision = 5;
	numFormatter6.precision = 6;

	if (structure != null && columnCount <= 0)
	{
		cols = columns; // Try to run with comment this line
		
	  	for(var i:int=0; i < structure.children().length(); i++)
		{
			dgc = new DataGridColumn(structure.children()[i].@data)
			dgc.headerText = structure.children()[i].@label
			
			if(structure.children()[i].@editable == 'true')
			{
				dgc.setStyle('headerStyleName','gridHeader');
			}
			
			dgc.editable = false; // Grid will always editable false, editbar component modify grid
	  		dgc.setStyle('textAlign', structure.children()[i].@textAlign)
	
			///
			var cfTextInput:ClassFactory 		= new ClassFactory(CellRenderer);
			var objTextInput:Object 			= new Object()
			objTextInput.setTextAlignment		= structure.children()[i].@textAlign;
			cfTextInput.properties				= objTextInput;
			dgc.itemRenderer = cfTextInput
			//
			if(structure.children()[i].@dataType == "D")
			{
				dgc.sortCompareFunction = new SortFieldFunction(structure.children()[i].@data).date_sortCompare
				dgc.labelFunction = dateFunc;
			}
			else if(structure.children()[i].@sortDataType == 'N')
			{
				dgc.sortCompareFunction = new SortFieldFunction(structure.children()[i].@data).numeric_sortCompare;
				columnPrecision  = structure.children()[i].@columnPrecision;
				
				if(columnPrecision == 0)
				{
					dgc.labelFunction = numcFunc0;
				}
				else if(columnPrecision == 1)
				{
					dgc.labelFunction = numcFunc1;
				}
				else if(columnPrecision == 2)
				{
					dgc.labelFunction = numcFunc2;
				}
				else if(columnPrecision == 3)
				{
					dgc.labelFunction = numcFunc3;
				}
				else if(columnPrecision == 4)
				{
					dgc.labelFunction = numcFunc4;
				}
				else if(columnPrecision == 5)
				{
					dgc.labelFunction = numcFunc5;
				}
				else if(columnPrecision == 6)
				{
					dgc.labelFunction = numcFunc6;
				}
			}
	
			if(structure.children()[i].@visible == 'true')
			{
				visibleCount++;
				dgc.visible = true;
				dgc.width = structure.children()[i].@width;
		  		cols.push(dgc)
			}
			else  
			{
				dgc.visible = false;
			}
			columns = cols;
			
			if(visibleCount > (int)(structure.@lockedColumnCount))
			{
				lockedColumnCount = (int)(structure.@lockedColumnCount)
			}
		}
	}
}

private function getSelectedRow():XML
{
	var xml:XML = null;
	
	if (selectedIndex >= 0)
	{
		xml = (XML)(dataProvider[selectedIndex]);
	}

	return xml;	
}

protected function itemClickHandler(event:ListEvent):void
{
	if(handleDoubleClick)
	{
		localListEvent = event;
		clearInterval(interval);
		interval = setInterval(deferredItemClickHandler, 300);
	}
	else
	{
		colname = DataGridColumn(event.currentTarget.columns[event.columnIndex]).dataField.toString()
		selectedRow = getSelectedRow();
		dispatchEvent(new NewGenDataGridEvent('itemClickGenGridEvent'));
	}
}

public function itemDoubleClickEventHandler(event:ListEvent):void
{
	if(handleDoubleClick)
	{
		clearInterval(interval);

		colname = DataGridColumn(event.currentTarget.columns[event.columnIndex]).dataField.toString()
		selectedRow = getSelectedRow();
		dispatchEvent(new NewGenDataGridEvent('itemDoubleClickGenGridEvent'));
	}
}

// Need it to handle itemclick & itemdoubleclick both
private function deferredItemClickHandler():void
{
	clearInterval(interval);

	colname = DataGridColumn(localListEvent.currentTarget.columns[localListEvent.columnIndex]).dataField.toString()
	selectedRow = getSelectedRow();
	dispatchEvent(new NewGenDataGridEvent('itemClickGenGridEvent'));
}

override protected function drawRowBackground(s:Sprite, rowIndex:int, y:Number, height:Number, color:uint, dataIndex:int):void
{
	if(rowColorFunction != null && dataProvider != null) 
	{
	    var item:Object;
	    if(dataIndex < dataProvider.length)
	    {
	      item = dataProvider[dataIndex];
	    }
	    
	    if(item)
	    {
	      color = rowColorFunction(item, rowIndex, dataIndex, color);
	    }
	}
	super.drawRowBackground(s, rowIndex, y, height, color, dataIndex);
}

private function dateFunc(item:Object, column:DataGridColumn):String
{
	var dateFormatter:DateFormatter = new DateFormatter();
	var date_format:String = GenModelLocator.getInstance().user.date_format.toLocaleUpperCase();
		
	if(date_format == null || date_format == "")
	{
		dateFormatter.formatString = 'MM/DD/YYYY';
	}
	else
	{
		dateFormatter.formatString = date_format;
	}

	return dateFormatter.format(item[column.dataField].toString());
}

private function numcFunc0(item:Object, column:DataGridColumn):String
{
	return numFormatter0.format(item[column.dataField].toString());
}

private function numcFunc1(item:Object, column:DataGridColumn):String
{
	return numFormatter1.format(item[column.dataField].toString());
}

private function numcFunc2(item:Object, column:DataGridColumn):String
{
	return numFormatter2.format(item[column.dataField].toString());
}

private function numcFunc3(item:Object, column:DataGridColumn):String
{
	return numFormatter3.format(item[column.dataField].toString());
}

private function numcFunc4(item:Object, column:DataGridColumn):String
{
	return numFormatter4.format(item[column.dataField].toString());
}

private function numcFunc5(item:Object, column:DataGridColumn):String
{
	return numFormatter5.format(item[column.dataField].toString());
}

private function numcFunc6(item:Object, column:DataGridColumn):String
{
	return numFormatter6.format(item[column.dataField].toString());
}

