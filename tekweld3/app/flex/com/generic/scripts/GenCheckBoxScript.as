import business.events.RecordStatusEvent;

import com.generic.events.*;

private var _dataType:String = "S";
private var _defaultValue:String = "";
private var _xmlTag:String = "";
private var _validationFlag:String = "false";
private var _updatableFlag:String = "false";
private var _tableName:String = "";
private var _dataValueForOn:String = "Y";
private var _dataValueForOff:String = "N";
private var _value:String = "";

private var _viewOnlyFlag:Boolean = false
private var _keyColumn:Boolean = false
private var _initialEditableFlag:Boolean = true
private var recordStatusEvent:RecordStatusEvent
public var recordStatusEnabled:Boolean = true;


//jeetu 21/01/2010
public function set initialEditableFlag(aBoolean:Boolean):void
{
 	_initialEditableFlag	=	this.enabled
}

public function get initialEditableFlag():Boolean
{
 	return _initialEditableFlag
}
public function set dataValue(aString:String):void //jeetu 21/01/2010 
{
 	this.value	=	aString;
}

public function get dataValue():String
{
 	return this.value
}
// *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


public function set viewOnlyFlag(aBoolean:Boolean):void
{
 	_viewOnlyFlag = aBoolean

 	if(initialEditableFlag)
 	{
 		enabled = !aBoolean;
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

public function set dataValueForOn(aString:String):void 
{
 	_dataValueForOn = aString
}

public function get dataValueForOn():String
{
 	return _dataValueForOn
}

public function set dataValueForOff(aString:String):void 
{
 	_dataValueForOff = aString
}

public function get dataValueForOff():String
{
 	return _dataValueForOff
}

public function set value(aString:String):void 
{
 	_value = aString
 	
 	if(aString == dataValueForOn)
 	{
 		this.selected = true
 	}
 	else
 	{
 		this.selected = false
 	}
}

public function get value():String
{
 	return _value
}

private function onChange():void
{
	if(this.selected)
	{
		value = _dataValueForOn		
	}
	else
	{
		value = _dataValueForOff		
	}

	dispatchEvent(new GenCheckBoxEvent('itemChangedEvent'));

	if(recordStatusEnabled)
	{
		recordStatusEvent = new	RecordStatusEvent("MODIFY")
		recordStatusEvent.dispatch()
	}
}

private function onCreationComplete():void
{
	if(defaultValue == dataValueForOn)
	{
		this.selected = true
		value = dataValueForOn		
	}
	else
	{
		this.selected = false
		value = dataValueForOff
		defaultValue = dataValueForOff		
	}
}
public function set setEditAlignment(align:String):void
{
	this.setStyle('textAlign',align);
}