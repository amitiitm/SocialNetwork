import business.events.RecordStatusEvent;

import com.generic.events.*;
import com.generic.genclass.GenNumberFormatter;

import flash.events.KeyboardEvent;

import mx.controls.Alert;
import mx.formatters.NumberBaseRoundType;
import mx.messaging.channels.StreamingHTTPChannel;

private var _dataType:String = "S";
private var _defaultValue:String = "";
private var _xmlTag:String = "";
private var _setDefaultOnEmpty:String = "false";
private var _validationFlag:String = "false";
private var _validationType:String = "";
private var _updatableFlag:String = "false";
private var _tableName:String = "";
private var _oldValue:String;
private var _upperCaseFlag:String = "false"

private var _negativeFlag:String = "false";
private var _rounding:String = "false";
private var _numericFormatter:GenNumberFormatter = new GenNumberFormatter();
private var _maxValue:Number = 0
private var changedFlag:Boolean = false;
private var _allTrim:String;

private var _viewOnlyFlag:Boolean = false
private var _keyColumn:Boolean = false
private var _initialEditableFlag:Boolean = true
private var recordStatusEvent:RecordStatusEvent
public var recordStatusEnabled:Boolean = true;

public function set initialEditableFlag(aBoolean:Boolean):void //jeetu 21/01/2010 
{
 	_initialEditableFlag	=	this.editable;
}

public function get initialEditableFlag():Boolean
{
 	return _initialEditableFlag
}

[Bindable]
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

public function set upperCaseFlag(aString:String):void
{
 	_upperCaseFlag = aString
}

public function get upperCaseFlag():String
{
 	return _upperCaseFlag
}

public function set dataType(aString:String):void
{
 	_dataType = aString
}

public function get dataType():String
{
	return _dataType
}

public function set negativeFlag(aString:String):void 
{
 	_negativeFlag = aString
}

public function get negativeFlag():String
{
 	return _negativeFlag
}

public function set setDefaultOnEmpty(aString:String):void 
{
 	_setDefaultOnEmpty = aString
}

public function get setDefaultOnEmpty():String
{
 	return _setDefaultOnEmpty
}

public function set maxValue(aNumber:Number):void 
{
 	_maxValue = aNumber
}

public function get maxValue():Number
{
 	return _maxValue
}

public function set rounding(aString:String):void 
{
 	_rounding = aString
}

public function get rounding():String
{
 	return _rounding
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

public function set validationType(aString:String):void 
{
	_validationType = aString
}

public function get validationType():String
{
	return _validationType
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

public function set oldValue(aString:String):void 
{
 	_oldValue = aString
}

public function get oldValue():String
{
 	return _oldValue
}

public function set allTrim(aString:String):void 
{
 	_allTrim = aString
}

public function get allTrim():String
{
	var str:String = text
	var startIndex:int = 0;

    while(str.indexOf(' ', startIndex) == startIndex)
    {
		++startIndex;
	}
	
	var endIndex:int = str.length - 1;
	while(str.lastIndexOf(' ', endIndex) == endIndex)
	{
		--endIndex;
	}
	
	_allTrim = endIndex >= startIndex ? str.slice(startIndex, endIndex + 1) :"";

 	return _allTrim
}

private function onCreationComplete():void
{
	if(dataType.toString().toUpperCase() == "N")
	{
		if(negativeFlag.toString().toUpperCase() == "TRUE")
		{
			this.restrict = "-.0123456789"
		}
		else
		{
			this.restrict = ".0123456789"
		}
	}
	else
	{
		if(upperCaseFlag.toLocaleUpperCase() == "TRUE")
		{
			restrict = ".\\-A-Z0-9/"
		}
	}
}

private function onFocusIn():void
{
	changedFlag = false;
	this.setSelection(0,this.text.length)
	oldValue = this.text
}

private function onFocusOut():void
{
	if(setDefaultOnEmpty.toString().toUpperCase() == "TRUE")
	{
		if(this.text == "")
		{
			this.text = this.defaultValue;
			onTextInput();
		}
	}
	
	onUpdateComplete()
	
	if(oldValue != this.text && changedFlag == true)
	{
		changedFlag = true
	}

	if(oldValue == this.text && changedFlag == true)
	{
		changedFlag = false
	}

	if(changedFlag)
	{
		if(recordStatusEnabled)
		{
			recordStatusEvent = new	RecordStatusEvent("MODIFY")
			recordStatusEvent.dispatch()
		}
		dispatchEvent(new GenTextInputEvent('itemChangedEvent'));
	}
}

private function onTextInput():void
{
	changedFlag = true;	
}

private function onKeyPress(event:KeyboardEvent):void//to make effective backspace and delete key.
{
	if(event.charCode.toString()=='8' || event.charCode.toString()=='127')
	{
		onTextInput();
	}
	
}

private function onUpdateComplete():void
{
	if(dataType.toString().toUpperCase() == "N")
	{
		var llPrecision:int;
		
		if(rounding.toString().toUpperCase() == "TRUE")
		{
			_numericFormatter.rounding = NumberBaseRoundType.NEAREST
		}

		if(maxValue.toString().lastIndexOf('.') == -1)
		{
			llPrecision = 0
		} 
		else
		{
			llPrecision = (int)(maxValue.toString().length) - maxValue.toString().lastIndexOf('.') - 1
		}
		
		if(llPrecision >= 0)
		{
			_numericFormatter.precision = llPrecision;
			this.text = _numericFormatter.format(String(this.text));
		}
	}
}
public function set setEditAlignment(align:String):void
{
	this.setStyle('textAlign',align);
}
