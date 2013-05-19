import com.generic.events.CustomReportEvent;
import com.generic.genclass.SortFieldFunction;
import com.generic.genclass.Utility;

import model.GenModelLocator;

import mx.collections.Grouping;
import mx.collections.GroupingCollection;
import mx.collections.GroupingField;
import mx.collections.SummaryField;
import mx.collections.SummaryRow;
import mx.controls.Alert;
import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
import mx.events.ListEvent;
import mx.formatters.DateFormatter;
import mx.formatters.NumberFormatter;

import saoi.muduleclasses.CellRenderer;
public var colname:String;
public var cols:Array	=	new Array();
private var dgc:AdvancedDataGridColumn;
private var _rows:XML;
private var _structure:XML;
private var _formatServiceID:String = "";
public var rowColorFunction:Function;
public var colColorFunction:Function;
private var grouping:Grouping;
public var arrayOfGroupingFields:Array
public var ishavingGroup:Boolean	=	false;
public var arrPrintWidth:Array;
public var arrDrilldownColumns:Array;
private var summaryRow:SummaryRow;
private var arrOfSummaryFields:Array;
private var arrOfNumericFields:Array;
public var ishavingSummary:Boolean	=	false;
private var arrOfSummaryRow:Array;
private var numericFormatter:NumberFormatter;	
private var colors:Array	=	['#ffffff', '#eeeeee', '#dddddd', '#cccccc', '#bbbbbb', '#aaaaaa', '#999999', '#888888' , '#777777' ,'#666666']
private var groupColors:Array	=	new Array();

[Bindable]
private var groupingCollection:GroupingCollection

public function expandAllTreeNodes():void
{
	this.expandAll();
}
public function collapsAllTreeNodes():void
{
	this.collapseAll();
	
	if(ishavingSummary) //we need to open first group (i.e. for summary) if there is a summary row.
	{
	 	this.expandItem(this.firstVisibleItem,true,false,true);
	}	 
}
private function groupLabelFuntionHandler(item:Object, column:AdvancedDataGridColumn):String
{
	if(item.GroupLabel	==	'Not Available')
	{
		//since we have added an extra group of field whixh doesnot exist top group label is 'Not Available'
		item.GroupLabel	=	'';
		return  '';
	}
	return item.GroupLabel;
}
public function generateGroup():void 
{
	if(rows.children().length()>0)
	{
		var i:int	=	0;
		if(ishavingSummary)
		{
			summaryRow.fields	=	arrOfSummaryFields;
			arrOfSummaryRow		=	new Array();
			arrOfSummaryRow.push(summaryRow);
			
			for(i= 0 ; i < arrayOfGroupingFields.length  ;i++)
			{
				GroupingField(arrayOfGroupingFields[i]).summaries	=	arrOfSummaryRow
			}	
		}
		
		for(i = arrayOfGroupingFields.length  ; i >=0 ; i--)
		{
			groupColors.push(colors[i]);
		}
		
		this.setStyle('depthColors',groupColors);
		
		grouping.fields						=	arrayOfGroupingFields;
		groupingCollection.source			=	rows.children();
		groupingCollection.childrenField	=	XML(rows.children()[0]).localName().toString()	//tag name which is having grouping fields
		
		groupingCollection.grouping	=	grouping; //comment this if there is no group
		
		this.dataProvider	=	groupingCollection;
		groupingCollection.refresh(); 	
		this.validateNow(); //it is required to expand function runs from here
		this.expandAll();
 	} 

}

/*if we want summary and their is no group then only it is used*/
public function generateSummaryForNoGroup():void 
{
	if(rows.children().length()>0)
	{
		summaryRow.fields	=	arrOfSummaryFields;
		arrOfSummaryRow		=	new Array();
		arrOfSummaryRow.push(summaryRow);
		
		arrayOfGroupingFields	=	new Array();
		/*since their is no group and we want summay we have added a dummy group which doesnot exist*/
		arrayOfGroupingFields.push(new GroupingField("fielddoesnotexist"));
		GroupingField(arrayOfGroupingFields[0]).summaries	=	arrOfSummaryRow
				
		
		this.setStyle('depthColors',null);
		grouping.fields						=	arrayOfGroupingFields;
		groupingCollection.source			=	rows.children();
		groupingCollection.childrenField	=	XML(rows.children()[0]).localName().toString()	//tag name which is having grouping fields
		
		groupingCollection.grouping	=	grouping; //comment this if there is no group
		
		this.dataProvider	=	groupingCollection;
		groupingCollection.refresh(); 	
		this.validateNow();//it is required to expand function runs from here
		this.expandAll();
	} 

}
public function summaryRowStyleFunction(data:Object, column:AdvancedDataGridColumn) : Object  
{  
	var output:Object;  

   	if(data.children == null)
	{  
    	output = {fontWeight:"bold"}
	}
	
	return output;
}

public function set dataValue(aXML:XML):void //jeetu 21/01/2010 
{
	this.rows	=	aXML;
}

public function get dataValue():XML
{
 	return this.rows;
}

public function set structure(aXML:XML):void 
{
	_structure = aXML;
	
	initGroup()
	createStructure()
}

public function get structure():XML
{
   	return _structure;
}

public function set changeInLayout(aXML:XML):void 
{
	dataValue	=	this.rows;
}
/* public function calculatesum(aXML:XML):XML
{
	var xml:XML	= new XML('<'+ aXML.children()[0].localName().toString()+ '/>')
 	if(arrOfNumericFields.length > 0)
 	{
 		var sum:Array	=	new Array(arrOfNumericFields.length);
 		var value:Number;
 		
 		for(var k:int=0 ; k < sum.length ; k++)
 		{
 			sum[k]	= 0;	
 		}
 			
 		for(var i:int= 0 ; i < aXML.children().length(); i++)
 		{
 			for(var j:int=0 ; j < sum.length ; j++)
 			{
 				value	=	0;
 				value	=	Number(XML(aXML.children()[i]).child(arrOfNumericFields[j].toString()))
 				if(value.toString()	!=	'NaN')
 				{
 					sum[j]	= sum[j] + 		value;
 				}
 				
 			}
 		}
 		var str:String;
 		for(var l:int=0;	l	< structure.children().length() ; l++)
 		{
 			str	=	structure.children()[l].column_name.toString()
 			xml[str]	=	''	;
 		}
 		for(var m:int=0;	m	< arrOfNumericFields.length ; m++)
 		{
 			xml[arrOfNumericFields[m].toString()]	=	sum[m]	;
 		}
 		
 	}
 	return 	xml;
}
 */
public function set rows(aXML:XML):void 
{
 	_rows = aXML;
 	
 	dataProvider = aXML.children();
 	
 	if(ishavingGroup || !ishavingSummary) //it will handle two condition 1)group with summary 2) group without summary 3) no group and no summary needed
 	{ 
 		generateGroup();
 	}
 	else  //it handles no group and summary needed
 	{
 		generateSummaryForNoGroup();
 	}
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

private function initGroup():void
{
	var tempSelectedGroupXml:XMLList	=	XMLList(structure.children().(isgroup.toString()	==	'Y')).copy()
	
	var tempSummaryFieldsXml:XMLList	=	XMLList(structure.children().(child('isvisible').toString() == 'Y' && child('istotal').toString()	==	'Y')).copy()
	
	//var tempSummaryFieldsXml:XMLList	=	XMLList(structure.children().(isvisible.toString() == 'Y' && istotal.toString()	==	'Y')).copy()
	
	arrayOfGroupingFields	=	new Array();
	groupingCollection		=	new  GroupingCollection();
	grouping				=	new Grouping();
	groupColors				=	new Array();
				
	if(tempSelectedGroupXml.length() > 0)
	{
		var utility:Utility	=	new Utility();
		var sortedXmlList:XMLList	=	utility.getSortedXmlList(tempSelectedGroupXml ,'group_level', 'N')
		
		if(tempSummaryFieldsXml.length() > 0)/*since we want grand total as group level also*/
		{
			arrayOfGroupingFields.push(new GroupingField('fielddoesnotexist'));
		}
		
		for(var i:int = 0 ; i< sortedXmlList.length()	;	i++)
		{
			arrayOfGroupingFields.push(new GroupingField(sortedXmlList[i].column_name.toString()));
		}
	}	
}

private function createStructure():void
{
	cols						=	new Array();
	arrPrintWidth				=	new Array();
	arrDrilldownColumns			=	new Array();
	arrOfNumericFields			=	new Array();
	var visibleCount:int 		= 	0;
	
	ishavingGroup				=	false;
	ishavingSummary				=	false;
	summaryRow					=	new SummaryRow();
	summaryRow.summaryPlacement	=	'group'
	
	arrOfSummaryFields		=	new Array();
	var drillObject:Object;
	
	if(structure != null)
	{
		dgc = new AdvancedDataGridColumn('group_column');
		dgc.headerText = 'Group';
		dgc.visible = false;
		dgc.width = 0;
		dgc.setStyle('textAlign', 'left');
		arrPrintWidth.push(100);  // this width is not being used anywhere, we can take any value here;
		
		cols.push(dgc)
		
		for(var i:int=0; i < structure.children().length(); i++)
		{
			dgc = new AdvancedDataGridColumn(structure.children()[i].column_name)
			dgc.headerText = structure.children()[i].column_label
			dgc.itemRenderer	= new ClassFactory(CellRenderer);
			// dgc.headerWordWrap	=	true;
			dgc.editable = false;
			if(structure.children()[i].column_textalign.toString() == 'L')
			{
				dgc.setStyle('textAlign', 'left');
			}
			else if(structure.children()[i].column_textalign.toString() == 'R')
			{
				dgc.setStyle('textAlign', 'right');
			}
			else
			{
				dgc.setStyle('textAlign', 'center');
			}
			
			if(structure.children()[i].isgroup == 'Y')
			{
				if(!ishavingGroup)  //because we have to do this only once
				{
					visibleCount++;
					ishavingGroup	=	true;
					AdvancedDataGridColumn(cols[0]).visible	=	true;
					AdvancedDataGridColumn(cols[0]).width	=	80;	
				}
				else
				{
					AdvancedDataGridColumn(cols[0]).width	=	AdvancedDataGridColumn(cols[0]).width + 10;	
				}
			}
			
			if(structure.children()[i].istotal == 'Y')
			{
				ishavingSummary	=	true;
				arrOfSummaryFields.push(new SummaryField(structure.children()[i].column_name.toString()));
				 
				dgc.styleFunction	=	summaryRowStyleFunction;				
			}
						
			if(structure.children()[i].sortdatatype == 'D')
			{
				dgc.sortCompareFunction = new SortFieldFunction(structure.children()[i].column_name).date_sortCompare
				// Vivek Dubey 20 Nov 2009
				// dgc.labelFunction = dateFunc
			}
			else if(structure.children()[i].sortdatatype == 'N')
			{
				dgc.sortCompareFunction = new SortFieldFunction(structure.children()[i].column_name).numeric_sortCompare
			}
			
			if(structure.children()[i].column_datatype == 'N')
			{
				arrOfNumericFields.push(structure.children()[i].column_name);
				
				numericFormatter	=	new NumberFormatter();
				numericFormatter.rounding = "nearest";
				numericFormatter.useThousandsSeparator = false;
				numericFormatter.precision = 0;
				
				if(!(String(structure.children()[i].column_precision) == 'NaN'  || String(structure.children()[i].column_precision) == ''))
				{
					numericFormatter.precision = Number(structure.children()[i].column_precision);

				}
				dgc.formatter	=	numericFormatter;
			}
			else if(structure.children()[i].column_datatype == 'D') // SO 15/03/2011
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
				dgc.formatter = dateFormatter;
			}
			
			if(structure.children()[i].isvisible == 'Y')
			{
				visibleCount++;
				dgc.visible = true;
				dgc.width = structure.children()[i].column_width;
				
				//in printReportCommand minWidth will be used as prin_twidth.
				if(structure.children()[i].print_width != '')
				arrPrintWidth.push(structure.children()[i].print_width);
				else
				arrPrintWidth.push(0);
				
				if(structure.children()[i].isdrilldowncolumn == 'Y')
				{
					drillObject	=	new Object();
					drillObject.column_name				=	structure.children()[i].column_name.toString();
					drillObject.isFixedColumnURL		=	structure.children()[i].isfixedurl.toString();
					drillObject.drilldown_component_code =	structure.children()[i].drilldown_component_code.toString();
					arrDrilldownColumns.push(drillObject);
				}
				
				cols.push(dgc)
			}
			else  
			{
				dgc.visible = false;
			}
			columns = cols;
			
			if(visibleCount > (int)(structure.children()[i].lockedcolumncount.toString()))
			{
				lockedColumnCount = (int)(structure.children()[i].lockedcolumncount.toString())
			}
		}
		
		dispatchEvent(new CustomReportEvent('structureCompleteEvent'));
	}
}

protected function itemClickHandler(event:ListEvent):void
{
	if(AdvancedDataGridColumn(event.currentTarget.columns[0]).visible)
	{
		colname = AdvancedDataGridColumn(event.currentTarget.columns[event.columnIndex]).dataField.toString()
	}
	else
	{
		colname = AdvancedDataGridColumn(event.currentTarget.columns[event.columnIndex + 1]).dataField.toString()
	}
	dispatchEvent(new CustomReportEvent('itemClickCustomReportEvent'));
}

public function itemDoubleClickEventHandler(event:ListEvent):void
{
	if(AdvancedDataGridColumn(event.currentTarget.columns[0]).visible)
	{
		colname = AdvancedDataGridColumn(event.currentTarget.columns[event.columnIndex]).dataField.toString()
	}
	else
	{
		colname = AdvancedDataGridColumn(event.currentTarget.columns[event.columnIndex + 1]).dataField.toString()
	}

	dispatchEvent(new CustomReportEvent('itemDoubleClickCustomReportEvent'));
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

private function dateFunc(item:Object, column:AdvancedDataGridColumn):String
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

