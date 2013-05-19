// ActionScript file
import com.generic.components.LookupLimitedRecordSearch;
import com.generic.events.LookupRecordSearchEvent;

import flash.events.Event;

import mx.managers.PopUpManager;


private var __dataField:String;
private var __lookupName:String;


private var _initialEditableFlag:Boolean 	= 	true;
private var _viewOnlyFlag:Boolean 			= 	false;
private var _xmlTag:String 					= 	"";
private var _updatableFlag:String 			= 	"false";
private var _tableName:String 				= 	"";

private var _filterEnabled:Boolean = false;
private var _filterKeyName:String = "";
private var _filterKeyValue:String = ""; 

private var minimumChar:int	=	0;
public var recordStatusEnabled:Boolean 		= true;
private var _lookupFormatUrl:String		=	"lookupHelpFormat";
private var isLookupOpen:Boolean	=	false;

private function openLookUp():void
{
	if(!viewOnlyFlag)
	{
		if(isLookupOpen)
		{
			return;	
		}
		
		isLookupOpen			=	true;		
		var lookupObj:LookupLimitedRecordSearch;
		lookupObj					= 	LookupLimitedRecordSearch(PopUpManager.createPopUp(this , LookupLimitedRecordSearch ,true));
		
		lookupObj.isMultiValueLookup	=	true;
		
		lookupObj.searchValue		=	""
		lookupObj.lookupName		=	lookupName;
		lookupObj.labelField		=	dataField;
		lookupObj.targetObj			=	tiLookup;
		lookupObj.lookupFormatUrl	=	lookupFormatUrl//"itemLookupHelpFormat"//lookupName;
		lookupObj.filterKeyName		=	filterKeyName;
		lookupObj.filterKeyValue	=	filterKeyValue;
		lookupObj.minimumChar		=	int(minimumChar);
		lookupObj.addEventListener(LookupRecordSearchEvent.LOOKUPCLOSE_EVENT,lookupWindowCloseEventHandler)
		
		
		//lookupObj.addEventListener(LookupRecordSearchEvent.LOOKUPCLOSE_EVENT,lookupWindowCloseEventHandler)	
	}
}
private function lookupWindowCloseEventHandler(e:Event):void
{
	isLookupOpen			=	false;	
}
public function set lookupFormatUrl(aString:String):void
{
	_lookupFormatUrl	=	aString;
} 
 
public function get lookupFormatUrl():String
{
	return _lookupFormatUrl;
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
//--------------------------------------------------------------------------------------
public function set initialEditableFlag(aBoolean:Boolean):void  
{
 	_initialEditableFlag	=	true
}

public function get initialEditableFlag():Boolean
{
 	return _initialEditableFlag
}

public function set dataValue(aString:String):void  
{
 	tiLookup.text	=	aString; 	
}

public function get dataValue():String
{
 	return tiLookup.text;
}
public function set viewOnlyFlag(aBoolean:Boolean):void
{
 	_viewOnlyFlag = aBoolean
 	
 	if(initialEditableFlag)
 	{
 		tiLookup.editable = !aBoolean
 	}
}

public function get viewOnlyFlag():Boolean
{
 	return _viewOnlyFlag
}
public function set xmlTag(aString:String):void 
{
 	_xmlTag = aString
}

public function get xmlTag():String
{
 	return _xmlTag
}
public function get updatableFlag():String
{
 	return _updatableFlag
}

public function set tableName(aString:String):void 
{
 	_tableName = aString
}

public function get tableName():String
{
 	return _tableName
}// ActionScript file
