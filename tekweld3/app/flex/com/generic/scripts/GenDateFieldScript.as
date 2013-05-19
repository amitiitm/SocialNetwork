import business.events.RecordStatusEvent;

import com.generic.events.*;

import flash.events.Event;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.controls.DateField;
import mx.formatters.DateFormatter;

public 	var databaseDateFormat:String   = 'YYYY/MM/DD';                 // date always set in database format
private var _dataType:String = "D";
private var _defaultValue:String = DateField.dateToString(new Date(),databaseDateFormat);
private var _xmlTag:String = "";
private var _validationFlag:String = "false";
private var _updatableFlag:String = "false";
private var _tableName:String = "";
private var _changedFlag:Boolean = false;
private var _oldValue:String;
private var _viewOnlyFlag:Boolean = false
private var _keyColumn:Boolean = false
private var _initialEditableFlag:Boolean = true
private var recordStatusEvent:RecordStatusEvent
public var recordStatusEnabled:Boolean = true;





public function set initialEditableFlag(aBoolean:Boolean):void //jeetu 21/01/2010 
{
	_initialEditableFlag	=	this.enabled;
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
	return this.text;
}

public function set viewOnlyFlag(aBoolean:Boolean):void
{
	_viewOnlyFlag = aBoolean
	
	if(initialEditableFlag)
	{
		dropdown.enabled = !aBoolean
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

public function set oldValue(aString:String):void 
{
	_oldValue = aString
}

public function get oldValue():String
{
	return _oldValue
}

private function onFocusIn():void
{
	_changedFlag = false
	oldValue = super.text;
}

private function onFocusOut():void
{	
	if(_oldValue != super.text)    // super.text = 12/23/2011   and this.text  = 2011/12/23
	{
		_changedFlag = true
	}
	
	if(_oldValue == super.text && _changedFlag == true)
	{
		_changedFlag = false
	}
	
	if(_changedFlag)
	{
		if(recordStatusEnabled)
		{
			recordStatusEvent = new	RecordStatusEvent("MODIFY")
			recordStatusEvent.dispatch()
		}
		if(super.text=='')
		{
			this.text = '';
			dispatchEvent(new GenDateFieldEvent('itemChangedEvent'));
			return;
		}
		validateDate(this.dataValue);
	}
}

private function onChange():void
{
	_changedFlag = true
	if(DateField.dateToString(this.selectedDate, databaseDateFormat)!='')
		dataValue = DateField.dateToString(this.selectedDate, databaseDateFormat);
}

private function creationCompleteHandler(event:Event):void
{
	if(event.currentTarget.text == 'NaN/NaN/NaN' || event.currentTarget.text == '')
	{
		event.currentTarget.text = defaultValue;
	}
}

private function dateFunc(date:Date):String
{
	return getFormattedDate(this.text);
}

override public function set text(value:String):void
{
	if(value!='' && value!=null)
	{
		var str:String = getFormattedDate(value);
		var date_format:String = getDateFormat();
		
		if(str == "" || str == null)
		{
			str = DateField.dateToString(new Date(), databaseDateFormat);;
		}
		super.text = str;
		return
	}
	if(value==''|| value==null )
	{ 
		if(this.text==''||this.text==null)               // after first valid value if user enter invalid then it is not override super.text value 
		{
			return;
		}
		else;
		{
			super.text="";
			return;
		}
	}
}

public function getValue(value:String):String
{
	var date_format:String = getDateFormat();
	var dateFormatter:DateFormatter = new DateFormatter();
	dateFormatter.formatString = databaseDateFormat;
	
	if(date_format == "DD/MM/YYYY")
	{
		var tstr1:String = value.substr(0, 2);
		var tstr2:String = value.substr(3, 2);
		var tstr3:String = value.substr(6, 4);
		var dateStr:String = tstr3 + '/' + tstr2 + '/' + tstr1;  //  date always set in database format sarvesh
		
		return dateFormatter.format(dateStr);
	}
	else if(date_format == "MM/DD/YYYY")
	{
		var tstr1:String = value.substr(0, 2);
		var tstr2:String = value.substr(3, 2);
		var tstr3:String = value.substr(6, 4);
		var dateStr:String = tstr3 + '/' + tstr1 + '/' + tstr2;  //  date always set in database format sarvesh
		
		return dateFormatter.format(dateStr);
	}
	else
	{
		return dateFormatter.format(value);
	}
} 

override public function get text():String
{
	return getValue(super.text);
}  

public function getFormattedDate(value:String):String
{
	var dateFormatter:DateFormatter = new DateFormatter();
	dateFormatter.formatString = getDateFormat();
	return dateFormatter.format(value);
}

private function getDateFormat():String
{
	var date_format:String = GenModelLocator.getInstance().user.date_format.toLocaleUpperCase();
	
	if(date_format == null || date_format == "")
	{
		date_format = 'MM/DD/YYYY';
	}
	
	return date_format;
}

private function validateDate(value:String):void
{ 
	var dateStr:String	 = isValidDate(value);
	if(dateStr == '' || dateStr == null)
	{
		this.text = currentDate();
	}
	else
	{
		this.text  = dateStr;
	} 
	
	dispatchEvent(new GenDateFieldEvent('itemChangedEvent'));
}  

private function isValidDate(value:String):String
{
	var str:String =  DateField.dateToString(DateField.stringToDate(value, databaseDateFormat), databaseDateFormat);
	var year:Number =  Number(str.substr(0, 4));
	if(year>2100 || year<1990)
	{
		return '';
	}
	return str;
}

public function currentDate():String
{
	return DateField.dateToString(new Date(), databaseDateFormat);
}
private function onOpen():void
{
	this.selectedDate    = DateField.stringToDate(super.text, getDateFormat())
}