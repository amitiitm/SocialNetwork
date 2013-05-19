import business.events.RecordStatusEvent;

import com.generic.events.*;

import model.GenModelLocator;

import mx.controls.Alert;

private var _dataValue:String = "";
private var _dataType:String = "S";
private var _defaultValue:String = "";
private var _xmlTag:String = "";
private var _validationFlag:String = "false";
private var _updatableFlag:String = "false";
private var _tableName:String = "";
private var _type_cd:String = ""
private var _subtype_cd:String = ""

private var _changedFlag:Boolean = false;
private var _oldValue:String;
private var _newValue:String;

private var _viewOnlyFlag:Boolean = false
private var _keyColumn:Boolean = false
private var _initialEditableFlag:Boolean = true
private var recordStatusEvent:RecordStatusEvent
public var recordStatusEnabled:Boolean = true;
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

// *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
public function set initialEditableFlag(aBoolean:Boolean):void
{
 	_initialEditableFlag	=	this.enabled
}

public function get initialEditableFlag():Boolean
{
 	return _initialEditableFlag
}
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

public function set dataValue(aString:String):void 
{
 	_dataValue = aString
 	setLabel()
}

public function get dataValue():String
{
 	return _dataValue
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

public function set type_cd(aString:String):void 
{
 	_type_cd = aString
 	
 	if(!(subtype_cd == '' || subtype_cd == null))
 	{
		dataProvider = __genModel.masterData.child(type_cd)[subtype_cd]
 	}
}

public function get type_cd():String
{
 	return _type_cd
}

public function set subtype_cd(aString:String):void 
{
 	_subtype_cd = aString
 	if(!(type_cd == '' || type_cd == null))
 	{
		dataProvider = __genModel.masterData.child(type_cd)[subtype_cd]
 	}
}

public function get subtype_cd():String
{
 	return _subtype_cd
}

public function set oldValue(aString:String):void 
{
 	_oldValue = aString
}

public function get oldValue():String
{
 	return _oldValue
}

public function set newValue(aString:String):void 
{
 	_newValue = aString
}

public function get newValue():String
{
 	return _newValue
}

private function onFocusIn():void
{
	_changedFlag = false;
	if(this.selectedItem != null)
	{
		oldValue = this.dataValue// text
		newValue = this.dataValue// text
	}
}

private function onFocusOut():void
{
	if(this.selectedItem != null)
	{
		if(_oldValue != this.dataValue && _changedFlag == true)
		{
			_changedFlag = true
		}
	
		if(_oldValue == this.dataValue && _changedFlag == true)
		{
			_changedFlag = false
		}
		
		if(_changedFlag)
		{
			dispatchEvent(new GenComboBoxEvent('itemChangedEvent'));
		}
	}
}

private function onChange():void
{
	//
	dataValue = this.selectedItem.value
	//
	//oldValue = newValue // VD 30 Dec 2010
	newValue = this.selectedItem.dataValue

	_changedFlag = true
	
	if(recordStatusEnabled)
	{
		recordStatusEvent = new	RecordStatusEvent("MODIFY")
		recordStatusEvent.dispatch()
	}
}

public function setLabel():void
{
	if(!(this.dataProvider.toString() == '' || this.dataProvider.toString() == null))
	{
		var flag:Boolean=false;
		for(var i:int = 0; i < this.dataProvider.length; i++)
		{
			if(this.dataValue == this.dataProvider[i].value)
			{
				this.selectedIndex = i;
				this.text = this.dataProvider[i].label;
				flag = true
				
				break;
			}
		}
		
		if(flag == false)
		{
				this.selectedIndex = -1;
				this.text = this.dataValue; 
			
		} 
	}
	else
	{
		Alert.show("No Record Is Exist In Type Table Corresponding To Components "+this.id);
	}
	/* var flag:Boolean=false;
	for(var i:int = 0; i < this.dataProvider.length; i++)
	{
		if(this.dataValue == this.dataProvider[i].value)
		{
			this.selectedIndex = i;
			this.text = this.dataProvider[i].label;
			flag = true
			
			break;
		}
	}
	
	if(flag == false)
	{
		this.selectedIndex = 0;
		this.text = this.dataProvider[0].label;
		this.dataValue = this.dataProvider[0].value
	} */
}
