import business.events.GetLookupDataEvent;
import flash.events.Event;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.managers.PopUpManager;
import mx.utils.StringUtil;

[Bindable]
private var __lookupRows:XML

private var __dataField:String;
private var __lookupName:String;
public  var targetObj:Object;
private var _filterdRows:XML;
private var _filterEnabled:Boolean = false;
private var _filterKeyName:String = "";
private var _filterKeyValue:String = ""; 
private var isRefreshBtnClicked:Boolean	=	false;

[Bindable]
private var width1:int;
private var width2:int;
private var width3:int;

private function creationCompleteHandler():void
{
	this.x = (this.screen.width - this.width) / 3
	this.y = (this.screen.height - this.height) / 3
	
	lbLabel.width = Number(DataGridColumn(gridLookup.columns[0]).width)
	tiCode.width = Number(DataGridColumn(gridLookup.columns[1]).width)
	tiName.percentWidth = 100;
	// lookupRows = lookupRows.copy(); 
	
	filterdRows	= lookupRows.copy();////becuase if user removes some text than we do not want it selected in lookupRows
	filterDataProvider();
	
	//	selectExistingValues();
}
private function changeColumnSizeHandler():void
{
	lbLabel.width = Number(DataGridColumn(gridLookup.columns[0]).width)
	tiCode.width = Number(DataGridColumn(gridLookup.columns[1]).width)
	tiName.percentWidth = 100;
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
		tempXmlList	=	filterdRows.children().(String(child(dataField)).toUpperCase()	==	tempArr[i].toString().toUpperCase())
		if(tempXmlList.children().length()	> 0)
		{
			tempXmlList[0].select_yn	=	'Y';
		}
	}
}
private function closeHandler():void
{
	PopUpManager.removePopUp(this);
}
[Bindable]
public function set lookupRows(aXML:XML):void
{
		__lookupRows	=	aXML;
		
		/*for refresh button click*/
		if(isRefreshBtnClicked)
		{
			isRefreshBtnClicked	=	false;
			filterdRows	=	lookupRows.copy();
			filterDataProvider();
		}
}

public function get lookupRows():XML
{
	return __lookupRows;
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
public function set dataField(aString:String):void
{
		__dataField	=	aString;
}

public function get dataField():String
{
	return __dataField;
}
public function set lookupName(aString:String):void
{
		__lookupName	=	aString;
		this.title		=	aString;
}

public function get lookupName():String
{
	return __lookupName;
}
public function set filterEnabled(aBoolean:Boolean):void 
{
 	_filterEnabled = aBoolean
}

public function get filterEnabled():Boolean
{
 	return _filterEnabled
}
public function set filterKeyName(aString:String):void 
{
 	_filterKeyName = aString
}

public function get filterKeyName():String
{
 	return _filterKeyName
}

public function set filterKeyValue(aString:String):void 
{
	_filterKeyValue = aString
}

public function get filterKeyValue():String
{
 	return _filterKeyValue
}

private function btnOKCilckHandler():void
{
	var rows:XML		=	filterdRows//gridLookup.rows;
	var value:String	=	''
	for (var i:int = 0 ; i < rows.children().length() ; i++)
	{
		if(rows.children()[i].select_yn	==	'Y')
		{
			if(value != '')
			{
				value	=	value + ',' + XML(rows.children()[i]).child(dataField).toString()	
			}
			else
			{
				value	=	XML(rows.children()[i]).child(dataField).toString();
			}
		}
	}
	
	targetObj.dataValue	=	value;
	closeHandler();
}
private function btnCancelCilckHandler():void
{
	closeHandler();
}
private function btnrefreshCilckHandler():void
{
	isRefreshBtnClicked	=	true;
	var getLookupDataEvent:GetLookupDataEvent;
			
	getLookupDataEvent = new GetLookupDataEvent(lookupName);
	getLookupDataEvent.dispatch();
}

private function filterDataProvider():void
{
	if(filterEnabled)
	{
		var tempList:XMLList;
		var filteredXml:XML
		filteredXml	=	new XML('<'+ lookupRows.localName().toString()+ '/>')
		
		tempList	=	lookupRows.children().(elements(filterKeyName) == filterKeyValue);
		if(tempList.children().length() > 0)
		{
			filteredXml.appendChild(tempList.copy());
		}
		filterdRows	=	filteredXml
	}
	selectExistingValues();
}
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