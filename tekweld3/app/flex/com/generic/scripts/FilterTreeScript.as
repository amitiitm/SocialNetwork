import business.events.FilterListEvent;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.events.*;
import mx.formatters.DateFormatter;

private var _dataXML:XML;
private var _xmlFilter:XML;
private var filterListEvent:FilterListEvent;
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
 

[Bindable]
public var treeXml:XML;   // to create filter tree

private function expandTree():void 
{
	if(treeXml != null)
 	{
    	expandItem(treeXml[0], true);
	}
}

public function set dataXML(aXML:XML):void 
{
 	_dataXML = aXML;
}

public function get dataXML():XML
{
   	return _dataXML;
}

public function set xmlFilter(aXML:XML):void 
{
 	_xmlFilter = aXML;
}

public function get xmlFilter():XML
{
   	return _xmlFilter;
}


public function filterListEventHandler():void
{
	filterList();
	//dispatchEvent(new FilterListEvent('filterListEvent'));
}

private function filterList():void
{
	var ary:Array = new Array();
	var tObj:Object;
	var aObj:Object;

	if(XML(this.selectedItem).children().length() > 0)
	{
		tObj = this.selectedItem;

		while(tObj != null)
		{
			aObj = new Object();
			aObj.name = tObj.@name;
			aObj.value = tObj.@value;

			if(!(aObj.name == 'treeRoot')) // Vivek Dubey 11 March, 2010. View name to be set on value so no ALL hardcode now.
			{
				ary.push(aObj);
			}
			
			tObj = this.getParentItem(tObj);
		}
		
		filterListEvent	=	new FilterListEvent(ary);
		filterListEvent.dispatch(); 
	}
}

private function tree_labelFunc(item:XML):String 
{
	var value:String = item.@value.toString();
	
	if((XML)(__genModel.activeModelLocator.sortOrderSelectionObj.selectedLevel1)["dataType"].toString() == "D" && item.@name.toString() == (XML)(__genModel.activeModelLocator.sortOrderSelectionObj.selectedLevel1)["data"].toString())
	{
		value = getFormattedDate(item.@value.toString())		
	}
	else if((XML)(__genModel.activeModelLocator.sortOrderSelectionObj.selectedLevel2)["dataType"].toString() == "D" && item.@name.toString() == (XML)(__genModel.activeModelLocator.sortOrderSelectionObj.selectedLevel2)["data"].toString())
	{
		value = getFormattedDate(item.@value.toString())		
	}
	else if((XML)(__genModel.activeModelLocator.sortOrderSelectionObj.selectedLevel3)["dataType"].toString() == "D" && item.@name.toString() == (XML)(__genModel.activeModelLocator.sortOrderSelectionObj.selectedLevel3)["data"].toString())
	{
		value = getFormattedDate(item.@value.toString())		
	}

	return value;
}

private function getFormattedDate(value:String):String
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

	return dateFormatter.format(value);
}
