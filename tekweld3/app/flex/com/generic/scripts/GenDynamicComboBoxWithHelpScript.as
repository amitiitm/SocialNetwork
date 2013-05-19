import business.events.GetLookupDataEvent;

import com.generic.components.LookupRecordSearch;
import com.generic.events.GenDynamicComboBoxEvent;
import com.generic.events.GenDynamicComboBoxWithHelpEvent;
import com.generic.events.LookupRecordSearchEvent;

import flash.events.Event;

import mx.managers.CursorManager;
import mx.managers.PopUpManager;
import mx.rpc.IResponder;

import valueObjects.LookupVO;

[Bindable]
private var _dataType:String = "S";

[Bindable]
private var _defaultValue:String	=	"";

[Bindable]
private var _xmlTag:String	=	"";

[Bindable]
private var _validationFlag:String = "false";

[Bindable]
private var _updatableFlag:String = "false";

[Bindable]
private var _tableName:String	=	"";

[Bindable]
private var _dataSourceName:String	=	"";

[Bindable]
private var _dataValue:String	=	"";

[Bindable]
private var _dataField:String	=	"";

[Bindable]
private var _validateData:Boolean = true;

[Bindable]
private var _filterEnabled:Boolean = false;

[Bindable]
private var _filterKeyName:String	=	"";

[Bindable]
private var _filterKeyValue:String	=	"";

[Bindable]
private var _recordStatusEnabled:Boolean = true;

[Bindable]
private var _viewOnlyFlag:Boolean = false;

[Bindable]
private var _keyColumn:Boolean = false;

[Bindable]
private var _initialEditableFlag:Boolean = true;

[Bindable]
private var _labelField:String	=	"";

[Bindable]
private var _dataProvider:Object;

[Bindable]
private var _toolTip:String;
private var currentValue:String	=	"";//jeetu 25 oct 2010
private var isSetDataFromLookup:Boolean	=	false;
private var valueFromLookup:String;
[Bindable]
public function set text(value:String):void
{
	dcb.text	=	value;
} 
 
public function get text():String
{
	return dcb.text;
}

public function get selectedItem():Object
{
	return dcb.selectedItem
}

public function set selectedIndex(value:int):void
{
	dcb.selectedIndex	=	value;
}

public function get selectedIndex():int
{
	return dcb.selectedIndex
}

public function set dataType(aString:String):void
{
	_dataType = aString;
}

public function get dataType():String
{
	_dataType = dcb.dataType;
	return _dataType;
}

public function set defaultValue(aString:String):void
{
	_defaultValue = aString;
}

public function get defaultValue():String
{
	_defaultValue = dcb.defaultValue;
	return _defaultValue;
}

public function set xmlTag(aString:String):void
{
	_xmlTag = aString;
}

public function get xmlTag():String
{
	_xmlTag = dcb.xmlTag;
	return _xmlTag;
}

public function set validationFlag(aString:String):void
{
	_validationFlag = aString;
}

public function get validationFlag():String
{
	_validationFlag = dcb.validationFlag;
	return _validationFlag;
}

public function set updatableFlag(aString:String):void
{
	_updatableFlag = aString;
}

public function get updatableFlag():String
{
	_updatableFlag = dcb.updatableFlag;
	return _updatableFlag;
}

public function set tableName(aString:String):void
{
	_tableName = aString;
}

public function get tableName():String
{
	_tableName = dcb.tableName;
	return _tableName;
}

public function set dataSourceName(aString:String):void
{
	_dataSourceName = aString;

}

public function get dataSourceName():String
{
	return _dataSourceName;
}

public function set dataValue(aString:String):void
{
	_dataValue = aString;
	dcb.dataValue = _dataValue;	
}

public function get dataValue():String
{
	_dataValue = dcb.dataValue;
	return _dataValue;
}

public function set dataField(aString:String):void
{
	_dataField = aString;
}

public function get dataField():String
{
	_dataField = dcb.dataField;
	return _dataField;
}

public function set validateData(aBoolean:Boolean):void
{
	_validateData = aBoolean;
}

public function get validateData():Boolean
{
	_validateData = dcb.validateData;
	return _validateData;
}

public function set filterEnabled(aBoolean:Boolean):void
{
	_filterEnabled = aBoolean;
}

public function get filterEnabled():Boolean
{
	_filterEnabled = dcb.filterEnabled;
	return _filterEnabled;
}

public function set filterKeyName(aString:String):void
{
	_filterKeyName = aString;
}

public function get filterKeyName():String
{
	_filterKeyName = dcb.filterKeyName;
	return _filterKeyName;
}

public function set filterKeyValue(aString:String):void
{
	_filterKeyValue = aString;
	dcb.filterKeyValue = _filterKeyValue;		
}

public function get filterKeyValue():String
{
	_filterKeyValue = dcb.filterKeyValue;
	return _filterKeyValue;
}

public function set recordStatusEnabled(aBoolean:Boolean):void
{
	_recordStatusEnabled = aBoolean;
}

public function get recordStatusEnabled():Boolean
{
	_recordStatusEnabled = dcb.recordStatusEnabled;
	return _recordStatusEnabled;
}

public function set viewOnlyFlag(aBoolean:Boolean):void
{
	_viewOnlyFlag    = aBoolean;
	if(initialEditableFlag)
	{
		dcb.enabled			=	!aBoolean;
		/* 16 march 2011 we have used above and comment this one . dcb.viewOnlyFlag	=	aBoolean */
		btn.enabled			=	!aBoolean;		
		btnLookup.enabled	=	!aBoolean;
	}	
}

public function get viewOnlyFlag():Boolean
{
	return _viewOnlyFlag;
}

public function set keyColumn(aBoolean:Boolean):void
{
	_keyColumn = aBoolean;
}

public function get keyColumn():Boolean
{
	_keyColumn = dcb.keyColumn;
	return _keyColumn;
}

public function set initialEditableFlag(aBoolean:Boolean):void
{
	_initialEditableFlag	=	this.enabled;
}

public function get initialEditableFlag():Boolean
{
	return _initialEditableFlag;
}

public function set labelField(aString:String):void
{
	_labelField = aString;
}

public function get labelField():String
{
	_labelField = dcb.labelField;
	return _labelField;
}

public function set dataProvider(aObject:Object):void
{
	_dataProvider = aObject;
}

public function get dataProvider():Object
{
	_dataProvider = dcb.dataProvider;
	return _dataProvider;
}

private function handleBtnClick():void
{
	dispatchEvent(new GenDynamicComboBoxWithHelpEvent(GenDynamicComboBoxWithHelpEvent.REFRESH_EVENT));

	CursorManager.setBusyCursor();
	currentValue	=	dcb.dataValue;
	var callbacks:IResponder = new mx.rpc.Responder(handleLookupUpResult, null);
	var getLookupDataEvent:GetLookupDataEvent = new GetLookupDataEvent(dataSourceName, callbacks);
	getLookupDataEvent.dispatch();
}

private function handleLookupUpResult(result:Object):void
{
	CursorManager.removeBusyCursor();
	_dataProvider 			= 	(XML)(result).children();
	_dataValue				=	currentValue;
	dcb.dataValue 			= 	_dataValue;//jeetu 25 oct 2010
		
	dispatchEvent(new GenDynamicComboBoxWithHelpEvent(GenDynamicComboBoxWithHelpEvent.REFRESHCOMPLETE_EVENT));
}
/*--------------------------lookup detail window----------------------*/
private function handleCreationComplete():void
{
	
}
public function set btnLookupVisible(aBoolean:Boolean):void
{
	if(aBoolean)
	{
		btn.visible	=	false;
		btn.width	=	0;
		btn.height	=	0;
		
		btnLookup.visible	=	true;
		btnLookup.width		=	14;
		btnLookup.height	=	16;
	}
	else
	{
		btn.visible	=	true;
		btn.width	=	14;
		btn.height	=	16;
		
		btnLookup.visible	=	false;
		btnLookup.width		=	0;
		btnLookup.height	=	0;
		
	}
}

private function lookupRecordSearchRefereshEvent(event:Event):void
{
	handleBtnClick();
}
private function lookupRecordSearchRefereshEventComplete(event:Event):void
{
	
}
private function handleLookupClick():void
{
	if(!viewOnlyFlag)
	{
		var lookupObj:LookupRecordSearch;
		var lookupRows:XML 		=	new LookupVO().getData(dataSourceName);
		
		lookupObj				= 	LookupRecordSearch(PopUpManager.createPopUp(this , LookupRecordSearch ,true));
		
		
		lookupObj.addEventListener(LookupRecordSearchEvent.REFRESH_EVENT, lookupRecordSearchRefereshEvent);
		lookupObj.addEventListener(LookupRecordSearchEvent.REFRESHCOMPLETE_EVENT, lookupRecordSearchRefereshEventComplete);

		lookupObj.lookupRows	=	lookupRows.copy();
		lookupObj.dataField		=	dataField;
		lookupObj.oldValue		=	dcb.dataValue;
		lookupObj.targetObj		=	dcb;
		lookupObj.lookupName	=	dataSourceName;
		lookupObj.filterEnabled	=	filterEnabled;
		lookupObj.filterKeyName	=	filterKeyName;
		lookupObj.filterKeyValue=	filterKeyValue	;		
	}
}