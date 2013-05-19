import com.generic.customcomponents.GenCheckBox;
import com.generic.customcomponents.GenComboBox;
import com.generic.customcomponents.GenDateField;
import com.generic.customcomponents.GenTextInput;
import com.generic.events.GenDataGridEvent;
import com.generic.genclass.GenNumberFormatter;
import com.generic.genclass.SortFieldFunction;

import model.GenModelLocator;

import mx.controls.DateField;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.ClassFactory;
import mx.events.DataGridEvent;
import mx.events.ListEvent;
import mx.formatters.DateFormatter;

import saoi.muduleclasses.CellRenderer;
// Local variable.
private var colname:String;
public var cols:Array;
private var dgc:DataGridColumn;
//

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
private var _initialEditableFlag:Boolean = true
public var arrPrintWidth:Array;

private var columnPrecision:Number;

private var numFormatter0:GenNumberFormatter = new GenNumberFormatter();
private var numFormatter1:GenNumberFormatter = new GenNumberFormatter();
private var numFormatter2:GenNumberFormatter = new GenNumberFormatter();
private var numFormatter3:GenNumberFormatter = new GenNumberFormatter();
private var numFormatter4:GenNumberFormatter = new GenNumberFormatter();
private var numFormatter5:GenNumberFormatter = new GenNumberFormatter();
private var numFormatter6:GenNumberFormatter = new GenNumberFormatter();

public function set initialEditableFlag(aBoolean:Boolean):void
{
	// VD 12 April 2010
	if(dropEnabled || editable)
	{
		_initialEditableFlag = true
	}
	else
	{
		_initialEditableFlag = false
	}
}

public function get initialEditableFlag():Boolean
{
 	return _initialEditableFlag
}

public function set dataValue(aXML:XML):void //jeetu 21/01/2010 
{
 	this.rows	=	aXML;
}

public function get dataValue():XML
{
 	return this.rows;
}

public function set viewOnlyFlag(aBoolean:Boolean):void
{
 	_viewOnlyFlag = aBoolean

 	if(initialEditableFlag)
 	{
 		dropEnabled = !aBoolean;
 		dragEnabled = !aBoolean;
 		dragMoveEnabled = !aBoolean;
 		editable = !aBoolean; // VD 12 April 2010.
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
	cols						=	new Array();
	
	var visibleCount:int = 0;

	numFormatter0.precision = 0;
	numFormatter1.precision = 1;
	numFormatter2.precision = 2;
	numFormatter3.precision = 3;
	numFormatter4.precision = 4;
	numFormatter5.precision = 5;
	numFormatter6.precision = 6;

	arrPrintWidth			=	new Array();
	
	if (structure != null)
	{
		//cols = columns; // Try to run with comment this line
		// this width is not being used anywhere, we can take any value here;
	  	for(var i:int=0; i < structure.children().length(); i++)
		{
			dgc = new DataGridColumn(structure.children()[i].@data)
			dgc.headerText = structure.children()[i].@label
			
			/// for color and align problems
			var cfTextInput:ClassFactory 		= new ClassFactory(CellRenderer);
			var objTextInput:Object 			= new Object()
			objTextInput.setTextAlignment		= structure.children()[i].@textAlign;
			cfTextInput.properties				= objTextInput;
			dgc.itemRenderer = cfTextInput
			//	
			if(structure.children()[i].@editable == 'true')
			{
				dgc.editable = true;
				dgc.setStyle('headerStyleName','gridHeader');
				
				if(structure.children()[i].@booleanFlag == 'true')
				{
					var cfGenChkBox:ClassFactory = new ClassFactory(com.generic.customcomponents.GenCheckBox);
					dgc.editorDataField = "value"

					var obj1:Object = new Object()

					obj1.dataValueForOn = "Y"
					obj1.dataValueForOff = "N"
					obj1.setEditAlignment	=		structure.children()[i].@textAlign;

					cfGenChkBox.properties = obj1;
					cfGenChkBox.newInstance();
					dgc.itemEditor = cfGenChkBox;
				}
				else if(structure.children()[i].@dateFlag == 'true')
				{
					var cfGenDateField:ClassFactory = new ClassFactory(com.generic.customcomponents.GenDateField);
					dgc.itemEditor = cfGenDateField;
				}
				/*
				else if(structure.children()[i].@lookupFlag == 'true')
				{
					var cfGenDynamicComboBox:ClassFactory = new ClassFactory(com.generic.customcomponents.GenDynamicComboBox);
					dgc.editorDataField = "value"

					var obj2:Object = new Object()

					obj2.dataSourceName = structure.children()[i].@dataSourceName
					obj2.dataField = structure.children()[i].@dataField
					obj2.labelField = structure.children()[i].@labelField

					cfGenDynamicComboBox.properties = obj2
					cfGenDynamicComboBox.newInstance();
					dgc.itemEditor = cfGenDynamicComboBox;
				}
				*/
	 			else
				{
					var cfTextInput:ClassFactory = new ClassFactory(com.generic.customcomponents.GenTextInput);
					var objTextInput:Object = new Object()
					objTextInput.setEditAlignment	= structure.children()[i].@textAlign;
					cfTextInput.properties	=	objTextInput;
					
					dgc.itemEditor = cfTextInput
				}
			}
			else 
			{
				dgc.editable = false;
			}
	
	  		dgc.setStyle('textAlign', structure.children()[i].@textAlign)
	
			if(structure.children()[i].@sortDataType == 'D')
			{
				dgc.sortCompareFunction = new SortFieldFunction(structure.children()[i].@data).date_sortCompare
				// Vivek Dubey 20 Nov 2009
				dgc.labelFunction = dateFunc
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
				
				if(structure.children()[i].hasOwnProperty('@print_width'))
				{
					if(structure.children()[i].@print_width != '')
					{
						arrPrintWidth.push(structure.children()[i].@print_width);
					}
					else
					{
						arrPrintWidth.push(0);
					}
				}
				else
				{
					arrPrintWidth.push(0);
				}
				
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
		dispatchEvent(new GenDataGridEvent('structureCompleteEvent'));
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

private function editBeginHandler(event:DataGridEvent):void
{
	try
	{
		var xml:XML;
		var str:String;
		
		if(colname == '')
		{
			colname = DataGridColumn(event.currentTarget.columns[event.columnIndex]).dataField.toString()
		}
		
		xml = getSelectedRow()
	
		createItemEditor(event.columnIndex, event.rowIndex);
		
		str = xml[colname].toString();
		
		event.currentTarget.itemEditorInstance.data = str;
	
		var className:String = getQualifiedClassName(event.currentTarget.itemEditorInstance)
	
		if(className == 'com.generic.customcomponents::GenCheckBox')
		{
			GenCheckBox(event.currentTarget.itemEditorInstance).defaultValue = xml.child(colname).toString();
			GenCheckBox(event.currentTarget.itemEditorInstance).value = xml.child(colname).toString();
		}
	 	else if (className == 'com.generic.customcomponents::GenTextInput')
		{
			GenTextInput(event.currentTarget.itemEditorInstance).text = xml.child(colname).toString();
			GenTextInput(event.currentTarget.itemEditorInstance).id = colname;
		}
		else if (className == 'com.generic.customcomponents::GenDateField')
		{
			event.preventDefault();
			DateField(event.currentTarget.itemEditorInstance).text = xml.child(colname).toString();
		} 
		else if (className == 'com.generic.customcomponents::GenComboBox')
		{
			GenComboBox(event.currentTarget.itemEditorInstance).dataValue = xml.child(colname).toString();
		}
	}
	catch(e:Error)
	{
		
	}
}


// SO 2012/03/02
public function deleteRow(row:int):void
{
	if(!viewOnlyFlag)
	{
		if(row >= 0)
		{	
			var tempXml:XML;
			var dgDtlRow:XML = new XML(dataProvider[row]);
			var node:String = dgDtlRow.localName();
			var deleteChild:XML	=	new XML(dgDtlRow);
			
			deleteChild.trans_flag = "D";
			
			/*if(XML(deletedRows).children().length()<=0)
			{
				deletedRows	 = new XML("<"+rootNode+"/>");
			}*/
			if(Number(deleteChild.child('id').toString()) > 0)
			{
				var tempDeletedRows:XML				= XML(deletedRows).copy();
				tempDeletedRows.appendChild(deleteChild.copy());
				deletedRows		= tempDeletedRows.copy();
			} 
			
			delete rows.child(node)[row];	
			tempXml	=  new XML(XML(rows).copy());
			rows	=	tempXml.copy(); 
		}
	} 
}
// SO 2012/05/18
public function seprateRows():void
{
	var tempDeleteRows:XML    =  new XML("<"+rootNode+"/>");
	var tempRows:XML  		  =  new XML("<"+rootNode+"/>");
	
	var tempXml:XML     	  =  mergedRows.copy();
	
	for(var i:int=0;i<tempXml.children().length();i++)
	{
		var trans_flag:String  = tempXml.children()[i].trans_flag.toString();
		var id:Number		   = Number(tempXml.children()[i].id.toString())
		if(trans_flag=='D' &&  id > 0)
		{
			tempDeleteRows.appendChild(XMLList(tempXml.children()[i]).copy());
		}
		else
		{
			tempRows.appendChild(XMLList(tempXml.children()[i]).copy());
		}
	}
	rows    				= tempRows.copy();
	deletedRows				= tempDeleteRows.copy();
}


private function itemFocusOutHandler(event:DataGridEvent):void
{
	colname = '';
}

protected function itemClickHandler(event:ListEvent):void
{
	/* if(handleDoubleClick)
	{
		localListEvent = event;
		clearInterval(interval);
		interval = setInterval(deferredItemClickHandler, 300);
	}
	else
	{ */
		colname = DataGridColumn(event.currentTarget.columns[event.columnIndex]).dataField.toString()
		selectedRow = getSelectedRow();
		dispatchEvent(new GenDataGridEvent('itemClickGenGridEvent'));
	/* } */
}

public function itemDoubleClickEventHandler(event:ListEvent):void
{
	/* if(handleDoubleClick)
	{
		clearInterval(interval); */

		colname = DataGridColumn(event.currentTarget.columns[event.columnIndex]).dataField.toString()
		selectedRow = getSelectedRow();
		dispatchEvent(new GenDataGridEvent('itemDoubleClickGenGridEvent'));
	/* } */
}

private function deferredItemClickHandler():void
{
	clearInterval(interval);

	colname = DataGridColumn(localListEvent.currentTarget.columns[localListEvent.columnIndex]).dataField.toString()
	selectedRow = getSelectedRow();
	dispatchEvent(new GenDataGridEvent('itemClickGenGridEvent'));
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

