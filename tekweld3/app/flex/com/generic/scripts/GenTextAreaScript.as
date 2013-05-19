// ActionScript file
import business.events.RecordStatusEvent;
import com.generic.events.*;

private var _dataType:String = "S";
private var _defaultValue:String = "";
private var _xmlTag:String = "";
private var _validationFlag:String = "false";
private var _updatableFlag:String = "false";
private var _tableName:String = "";
private var _allTrim:String = "";

private var _viewOnlyFlag:Boolean = false
private var _keyColumn:Boolean = false
private var _initialEditableFlag:Boolean = true
private var recordStatusEvent:RecordStatusEvent;
public var recordStatusEnabled:Boolean = true;

public function set initialEditableFlag(aBoolean:Boolean):void //jeetu 21/01/2010 
{
 	_initialEditableFlag	=	this.editable;
}

public function get initialEditableFlag():Boolean
{
 	return _initialEditableFlag
}
public function set dataValue(aString:String):void //jeetu 21/01/2010 
{
 	this.text	=	aString;
}

public function get dataValue():String
{
 	return this.text
}
// *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
public function set viewOnlyFlag(aBoolean:Boolean):void
{
 	_viewOnlyFlag = aBoolean
 	
 	if(initialEditableFlag)
 	{
 		editable = !aBoolean
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

public function set dataType(aString:String):void 
{
 	_dataType = aString
}

public function get dataType():String
{
 	return _dataType
}

public function set defaultValue(aString:String):void 
{
 	_defaultValue = aString
}

public function get defaultValue():String
{
 	return _defaultValue
}

public function set xmlTag(aString:String):void 
{
 	_xmlTag = aString
}

public function get xmlTag():String
{
 	return _xmlTag
}

public function set validationFlag(aString:String):void 
{
 	_validationFlag = aString
}

public function get validationFlag():String
{
 	return _validationFlag
}

public function set updatableFlag(aString:String):void 
{
 	_updatableFlag = aString
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
}

public function get allTrim():String
{
	_allTrim = trimString()
 	return _allTrim;
}

private function trimString():String
{
	var str:String = text
	var startIndex:int = 0;
	
	while(str.indexOf(' ', startIndex) == startIndex)
	{
		++startIndex;
	}
	
    var endIndex:int = str.length - 1;
    while (str.lastIndexOf(' ', endIndex) == endIndex)
    {
        --endIndex;
    }
	
    return endIndex >= startIndex ? str.slice(startIndex, endIndex + 1) : "";
}

private function onTextInput():void
{
	if(recordStatusEnabled)
	{
		recordStatusEvent = new	RecordStatusEvent("MODIFY")
		recordStatusEvent.dispatch()
	}
}
