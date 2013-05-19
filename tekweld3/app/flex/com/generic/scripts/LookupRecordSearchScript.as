import business.events.GetLookupDataEvent;
import business.events.QuickAddEvent;

import com.generic.customcomponents.GenDynamicComboBox;
import com.generic.events.GenDynamicComboBoxEvent;
import com.generic.events.LookupRecordSearchEvent;

import business.events.RecordStatusEvent;

import flash.events.Event;
import flash.utils.getQualifiedClassName;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.events.DataGridEvent;
import mx.managers.CursorManager;
import mx.managers.PopUpManager;
import mx.rpc.IResponder;
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
private var __oldValue:String;

[Bindable]
private var width1:int;
private var width2:int;
private var width3:int;

[Bindable]
private var isNewButtonActive:Boolean	=	false;
[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var quickAddEvent:QuickAddEvent;

private function creationCompleteHandler():void
{
	this.x = (this.screen.width - this.width) / 3
	this.y = (this.screen.height - this.height) / 3
	
	
	lbLabel.width = Number(DataGridColumn(gridLookup.columns[0]).width)
	tiCode.width = Number(DataGridColumn(gridLookup.columns[1]).width)
	tiName.percentWidth = 100;
	 
	filterdRows	= lookupRows.copy();////becuase if user removes some text than we do not want it selected in lookupRows
	filterDataProvider();	

}
public function set oldValue(aString:String):void
{
		__oldValue	=	aString;
}

public function get oldValue():String
{
	return __oldValue;
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
	var lsClassName:String = getQualifiedClassName(targetObj)
		
	if(lsClassName == "com.generic.customcomponents::GenDynamicComboBox")
	{
		if(GenDynamicComboBox(targetObj).dataProvider.length <=0 && lookupRows.children().length() > 0)
		{
			GenDynamicComboBox(targetObj).dataProvider	=	lookupRows.children().copy();//new changes 22 sep 2011 jeetu it was filterdRows.chilren.copy()
			GenDynamicComboBox(targetObj).dataValue		=	'';
		}
	}
	
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
		__lookupName			=	aString;
		this.title				=	aString;
		
		var menuXML:XML				=	__genModel.applicationObject.menu
		var createPermission:String	=	"N";
		var tempXMLList:XMLList		=	new XMLList(<root/>);
		var obj:Object				=	__genModel.lookupObj.getMasterInfo(aString);
		
		if(obj.modulePath.toString()	==	"")
		{
			return;
		}

		tempXMLList					=	menuXML.children().(component_cd.toString() == obj.modulePath.toString());
		
		if(!__genModel.lookupObj.isQuickAddActive)  // it is a first level Quick Add
		{
			if(tempXMLList.children().length() > 0)  // module exist in menu
			{
				if(tempXMLList[0].create_permission.toString()	==	'Y')  // user is having create permission 
				{
					isNewButtonActive	=	true;
				}
			}
			
		}
		
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
	 
	var lsClassName:String = getQualifiedClassName(targetObj);
	
	if(lsClassName == "com.generic.customcomponents::GenDynamicComboBox")
	{
		if(GenDynamicComboBox(targetObj).dataProvider.length > 0)
		{
			targetObj.dataValue	=	value;
			if(targetObj.dataValue	 !=  oldValue)
			{
				GenDynamicComboBox(targetObj).dispatchEvent(new GenDynamicComboBoxEvent(GenDynamicComboBoxEvent.ITEMCHANGED_EVENT));
			}
		}
		else
		{
			//first we have to referesh data and then set the data;
			if(lookupRows.children().length() > 0)
			{
				GenDynamicComboBox(targetObj).dataProvider	=	lookupRows.children().copy(); //new changes 22 sep 2011 jeetu it was filterdRows.chilren.copy()
				targetObj.dataValue	=	value;
				if(targetObj.dataValue	 !=  oldValue)
				{
					GenDynamicComboBox(targetObj).dispatchEvent(new GenDynamicComboBoxEvent(GenDynamicComboBoxEvent.ITEMCHANGED_EVENT));
				}	
			}
					
		}						
	}	
	
	PopUpManager.removePopUp(this);
}
private function btnCancelCilckHandler():void
{
	closeHandler();
}
private function btnrefreshCilckHandler():void
{
	isRefreshBtnClicked	=	true;
		
	dispatchEvent(new LookupRecordSearchEvent(LookupRecordSearchEvent.REFRESH_EVENT));

	CursorManager.setBusyCursor();
	//currentValue	=	dcb.dataValue//jeetu 25 oct 2010
	var callbacks:IResponder = new mx.rpc.Responder(handleLookupUpResult, null);
	var getLookupDataEvent:GetLookupDataEvent = new GetLookupDataEvent(lookupName, callbacks);
	getLookupDataEvent.dispatch();
}
private function handleLookupUpResult(result:Object):void
{
	CursorManager.removeBusyCursor();
	lookupRows	=	(XML)(result);
	filterdRows	= 	lookupRows.copy();
	filterDataProvider();
	dispatchEvent(new LookupRecordSearchEvent(LookupRecordSearchEvent.REFRESHCOMPLETE_EVENT));
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
private function itemFocusOutEventHandler(event:Event):void
{
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
private function btnAddCilckHandler():void
{

	if(!__genModel.lookupObj.isQuickAddActive)
	{
		__genModel.lookupObj.lookupName		=		lookupName;	
		__genModel.lookupObj.refereshBtn	=		btnRefresh;				
			
		var callbacks:IResponder = new mx.rpc.Responder(callbackLookupRecordSearch, null);
		
		quickAddEvent= new QuickAddEvent();
		quickAddEvent.dispatch();
	}		
}
private function callbackLookupRecordSearch(obj:Object):void
{
	Alert.show('callback');	
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
	
	var recordStatusEvent:RecordStatusEvent = new RecordStatusEvent("MODIFY");
	recordStatusEvent.dispatch();
}