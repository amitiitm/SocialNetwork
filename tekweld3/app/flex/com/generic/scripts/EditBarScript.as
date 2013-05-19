import com.generic.customcomponents.GenCheckBox;
import com.generic.customcomponents.GenComboBox;
import com.generic.customcomponents.GenDateField;
import com.generic.customcomponents.GenTextInput;
import com.generic.customcomponents.GenTextInputWithHelp;
import com.generic.events.EditBarEvent;
import com.generic.events.GenCheckBoxEvent;
import com.generic.events.GenComboBoxEvent;
import com.generic.events.GenDateFieldEvent;
import com.generic.events.GenTextInputEvent;
import com.generic.events.GenTextInputWithHelpEvent;

import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.utils.getQualifiedClassName;

import mx.controls.Alert;

private var _record:XML;
private var _structure:XML;
private var _newRow:XML;
public var firstEditableCompID:String
public var lastEditableCompID:String

public function get newRow():XML
{
	return _newRow;
}

public function reset():void
{
	visible = false
	record = new XML()
}

public function set record(aXML:XML):void
{
	_record = aXML;
	setValue()
}

public function get record():XML
{
	return _record;
}

public function set structure(aXML:XML):void
{
	_structure = aXML;
	_newRow	=	new XML(<root/>)
	createStructure()
}

public function get structure():XML
{
	return _structure;
}

private function createStructure():void
{
	var visibleCount:int = 0;

	removeAllChildren()
	
	if(structure != null)
	{
		var firstFlag:Boolean = true;

	  	for(var i:int=0; i < structure.children().length(); i++)
		{
			_newRow.appendChild("<" + structure.children()[i].@data + "/>")
			if(String(structure.children()[i].@editable).toLocaleLowerCase() == 'true' && firstFlag)
			{
				firstEditableCompID = structure.children()[i].@data
				firstFlag = false
			}

			if(String(structure.children()[i].@editable).toLocaleLowerCase() == 'true')
			{
				lastEditableCompID = structure.children()[i].@data
			}
			
			if(String(structure.children()[i].@visible).toLocaleLowerCase() == 'true')
			{
				if(String(structure.children()[i].@componentType).toLocaleLowerCase() == 'checkbox')
				{
					addChild(createCheckBox(i))
				}
				else if(String(structure.children()[i].@componentType).toLocaleLowerCase() == 'lookup')
				{
					addChild(createLookup(i))
				}
				else if(String(structure.children()[i].@componentType).toLocaleLowerCase() == 'combobox')
				{
					addChild(createComboBox(i))
				}
				else if(String(structure.children()[i].@componentType).toLocaleLowerCase() == 'date')
				{
					addChild(createDateField(i))
				}
				else if(String(structure.children()[i].@componentType).toLocaleLowerCase() == 'text')
				{
					if(structure.children()[i].@dataType == 'S')
					{
						addChild(createStringInput(i))
					}
					else
					{
						addChild(createNumericInput(i))
					}
				}
			}
		}
		
	}
}

private function createCheckBox(i:int):GenCheckBox
{
	var chk:GenCheckBox = new GenCheckBox();

	if(String(structure.children()[i].@editable).toLocaleLowerCase() == 'true')
	{
		chk.enabled = true

		chk.dataValueForOn = structure.children()[i].@dataValueForOn
		chk.dataValueForOff = structure.children()[i].@dataValueForOff
		chk.addEventListener(GenCheckBoxEvent.ITEMCHANGED_EVENT, handleGenCheckBoxItemChanged)
		chk.addEventListener(FocusEvent.FOCUS_IN, handleFocusInEvent)
	}
	else
	{
		chk.setStyle('disabledColor', '#000000')
		chk.setStyle('backgroundDisabledColor', '#FFFFFF')
		chk.enabled = false
	}

	chk.id = structure.children()[i].@data
	chk.dataType = structure.children()[i].@dataType
	chk.xmlTag = structure.children()[i].@data
	chk.width = (Number)(structure.children()[i].@width)

	chk.height = 24
  	chk.setStyle('textAlign', structure.children()[i].@textAlign)
	chk.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyboardDown)
	
  	return chk
}

private function createStringInput(i:int):GenTextInput
{
	var tis:GenTextInput = new GenTextInput();

	tis.id = structure.children()[i].@data
	tis.dataType = structure.children()[i].@dataType
	tis.xmlTag = structure.children()[i].@data
  	tis.setStyle('textAlign', structure.children()[i].@textAlign)
	tis.width = (Number)(structure.children()[i].@width)

	tis.height = 24

	if(String(structure.children()[i].@editable).toLocaleLowerCase() == 'true')
	{
		tis.editable = true
		
		tis.validationFlag = structure.children()[i].@validationFlag
		tis.upperCaseFlag = structure.children()[i].@upperCaseFlag
		
		tis.setDefaultOnEmpty = structure.children()[i].@setDefaultOnEmpty
		tis.maxChars = parseInt(structure.children()[i].@maxChars)
		
		tis.addEventListener(GenTextInputEvent.ITEMCHANGED_EVENT, handleGenTextInputItemChanged)
		tis.addEventListener(FocusEvent.FOCUS_IN, handleFocusInEvent)
	}
	else
	{
		//tis.editable = false
		tis.enabled = false
		tis.setStyle('disabledColor', '#000000')
		tis.setStyle('backgroundDisabledColor', '#FFFFFF')
	}	
	
	tis.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyboardDown)

	return tis;
}

private function createNumericInput(i:int):GenTextInput
{
	var tin:GenTextInput = new GenTextInput();

	if(String(structure.children()[i].@editable).toLocaleLowerCase() == 'true')
	{
		tin.editable = true

		tin.validationFlag = structure.children()[i].@validationFlag
		tin.negativeFlag = structure.children()[i].@negativeFlag
		tin.rounding = structure.children()[i].@rounding

		tin.addEventListener(GenTextInputEvent.ITEMCHANGED_EVENT, handleGenTextInputItemChanged)
		tin.addEventListener(FocusEvent.FOCUS_IN, handleFocusInEvent)
	}
	else
	{
		// tin.editable = false
		tin.enabled = false
		tin.setStyle('disabledColor', '#000000')
		tin.setStyle('backgroundDisabledColor', '#FFFFFF')
	}

	tin.id = structure.children()[i].@data
	tin.dataType = structure.children()[i].@dataType
	tin.xmlTag = structure.children()[i].@data
  	tin.setStyle('textAlign', structure.children()[i].@textAlign)
	tin.width = (Number)(structure.children()[i].@width)
	tin.maxValue = Number(structure.children()[i].@maxValue)
	tin.height = 24
	tin.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyboardDown)
	
	return tin
}	

/* private function createLookup(i:int):GenDynamicComboBox
{
	var lkp:GenDynamicComboBox = new GenDynamicComboBox();

	if(String(structure.children()[i].@editable).toLocaleLowerCase() == 'true')
	{
		lkp.enabled = true
		lkp.validationFlag = structure.children()[i].@validationFlag

		// Modify by VD 09 April 2010		
		if(String(structure.children()[i].@filterEnabled).toLocaleLowerCase() == 'true')
		{
			lkp.filterEnabled = true
			lkp.filterKeyName = structure.children()[i].@filterKeyName
		} 
		
		lkp.addEventListener(GenDynamicComboBoxEvent.ITEMCHANGED_EVENT, handleDynamicComBoxBoxItemChanged)
		lkp.addEventListener(FocusEvent.FOCUS_IN, handleFocusInEvent)
	}
	else
	{
		lkp.setStyle('disabledColor', '#000000')
		lkp.setStyle('backgroundDisabledColor', '#FFFFFF')
		lkp.enabled = false
	}

	lkp.id = structure.children()[i].@data
	lkp.dataType = structure.children()[i].@dataType
	lkp.xmlTag = structure.children()[i].@data
	lkp.dataSourceName = structure.children()[i].@dataSourceName
	lkp.dataField = structure.children()[i].@dataField
	lkp.labelField = structure.children()[i].@labelField
	lkp.width = (Number)(structure.children()[i].@width)

	lkp.height = 24
  	lkp.setStyle('textAlign', structure.children()[i].@textAlign)
	lkp.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyboardDown)
  	
  	return lkp;
} */

// chnages becuase Lookups are removed. -- kushwaha

private function createLookup(i:int):GenTextInputWithHelp
{
	var lkp:GenTextInputWithHelp = new GenTextInputWithHelp();
	
	if(String(structure.children()[i].@editable).toLocaleLowerCase() == 'true')
	{
		lkp.enabled = true
		lkp.validationFlag = structure.children()[i].@validationFlag

		// Modify by VD 09 April 2010		
		if(String(structure.children()[i].@filterEnabled).toLocaleLowerCase() == 'true')
		{
			lkp.filterEnabled = true
			lkp.filterKeyName = structure.children()[i].@filterKeyName
		} 
		
		lkp.addEventListener(GenTextInputWithHelpEvent.ITEMCHANGED_EVENT, handleGenTextInputHelpItemChanged)
		lkp.addEventListener(FocusEvent.FOCUS_IN, handleFocusInEvent)
	}
	else
	{
		lkp.setStyle('disabledColor', '#000000')
		lkp.setStyle('backgroundDisabledColor', '#FFFFFF')
		lkp.enabled = false
	}
	
	lkp.id = structure.children()[i].@data
	lkp.dataType = structure.children()[i].@dataType
	lkp.xmlTag = structure.children()[i].@data
	lkp.labelTag = structure.children()[i].@data
	lkp.dataSourceName = structure.children()[i].@dataSourceName
	lkp.dataField = structure.children()[i].@dataField
	lkp.labelField = structure.children()[i].@labelField
	lkp.width = (Number)(structure.children()[i].@width)

	if(structure.children()[i].hasOwnProperty('lookupFormatUrl'))
	{
		if(structure.children()[i].@lookupFormatUrl != '')
		{
			lkp.lookupFormatUrl	=	structure.children()[i].@lookupFormatUrl	
		}
	}
		
	
	lkp.height = 24
	
  	lkp.setStyle('textAlign', structure.children()[i].@textAlign)
	lkp.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyboardDown)
  	
  	return lkp;
}

private function createComboBox(i:int):GenComboBox
{
	var cb:GenComboBox = new GenComboBox();

	if(String(structure.children()[i].@editable).toLocaleLowerCase() == 'true')
	{
		cb.enabled = true
		cb.addEventListener(GenComboBoxEvent.ITEMCHANGED_EVENT, handleComBoxBoxItemChanged)
		cb.addEventListener(FocusEvent.FOCUS_IN, handleFocusInEvent)
	}
	else
	{
		cb.enabled = false
		cb.setStyle('disabledColor', '#000000')
		cb.setStyle('backgroundDisabledColor', '#FFFFFF')
	}

	cb.id = structure.children()[i].@data
	cb.type_cd = structure.children()[i].@type_cd
	cb.subtype_cd = structure.children()[i].@subtype_cd
	cb.xmlTag = structure.children()[i].@data
	cb.width = (Number)(structure.children()[i].@width)

	cb.height = 24
  	cb.setStyle('textAlign', structure.children()[i].@textAlign)
	cb.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyboardDown)

  	return cb;
}					

private function createDateField(i:int):GenDateField
{
	var df:GenDateField = new GenDateField();

	if(String(structure.children()[i].@editable).toLocaleLowerCase() == 'true')
	{
		df.enabled = true
		df.addEventListener(GenDateFieldEvent.ITEMCHANGED_EVENT, handleGenDateFieldItemChanged)
		df.addEventListener(FocusEvent.FOCUS_IN, handleFocusInEvent)
	}
	else
	{
		df.setStyle('disabledColor', '#000000')
		df.setStyle('backgroundDisabledColor', '#FFFFFF')
		df.enabled = false
	}
	
	df.id = structure.children()[i].@data
	df.dataType = structure.children()[i].@dataType
	df.xmlTag = structure.children()[i].@data
	df.width = (Number)(structure.children()[i].@width)

	df.height = 24
  	df.setStyle('textAlign', structure.children()[i].@textAlign)
	df.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyboardDown)

  	return df;
}					

private function handleKeyboardDown(event:KeyboardEvent):void
{
	if(event.shiftKey)
	{
		/* Commented as issue in Dynamiccombox
		if(event.keyCode == Keyboard.TAB && event.currentTarget.id == firstEditableCompID)
		{
			triggerItemChanged(event.currentTarget)
			dispatchEvent(new EditBarEvent(EditBarEvent.SHIFTTABKEY_EVENT));
		}
		*/
	}
	else
	{
		if(event.keyCode == Keyboard.TAB && event.currentTarget.id == lastEditableCompID)
		{
			/* Commented as issue in Dynamiccombox
			triggerItemChanged(event.currentTarget)
			dispatchEvent(new EditBarEvent(EditBarEvent.TABKEY_EVENT));
			*/
		}
		else if(event.keyCode == Keyboard.UP)
		{
			triggerItemChanged(event.currentTarget)
			dispatchEvent(new EditBarEvent(EditBarEvent.UPKEY_EVENT));
		}
		else if(event.keyCode == Keyboard.DOWN)
		{
			triggerItemChanged(event.currentTarget)
			dispatchEvent(new EditBarEvent(EditBarEvent.DOWNKEY_EVENT));
		}
	}
}

private function triggerItemChanged(object:Object):void
{
	var className:String = getQualifiedClassName(object)
	
	if(className == "com.generic.customcomponents::GenTextInput")
	{
		object.dispatchEvent(new GenTextInputEvent(GenTextInputEvent.ITEMCHANGED_EVENT))
	}
	else if(className == "com.generic.customcomponents::GenDateField")
	{
		object.dispatchEvent(new GenDateFieldEvent(GenDateFieldEvent.ITEMCHANGED_EVENT))
	}
	else if(className == "com.generic.customcomponents::GenComboBox")
	{
		object.dispatchEvent(new GenComboBoxEvent(GenComboBoxEvent.ITEMCHANGED_EVENT))
	}
	else if(className == "com.generic.customcomponents::GenCheckBox")
	{
		object.dispatchEvent(new GenCheckBoxEvent(GenCheckBoxEvent.ITEMCHANGED_EVENT))
	}
	else if(className == "com.generic.customcomponents::GenTextInputWithHelp")
	{
		object.dispatchEvent(new GenTextInputWithHelpEvent(GenTextInputWithHelpEvent.ITEMCHANGED_EVENT))
	}
}

private function setValue():void
{
	var ary:Array = getChildren()

	for(var i:int=0; i<ary.length; i++)
	{
		if(ary[i] is GenTextInputWithHelp)
		{
			ary[i].dataValue = record[ary[i].xmlTag].toString();
			ary[i].labelValue = record[ary[i].labelTag].toString();
		}
		else
		{
			ary[i].dataValue = record[ary[i].xmlTag].toString();
		}
	}
}

private function handleGenCheckBoxItemChanged(event:GenCheckBoxEvent):void
{
	record[event.target.xmlTag] = event.currentTarget.dataValue;
	dispatchEvent(new EditBarEvent(EditBarEvent.EDITBARITEMCHANGED_EVENT, event.currentTarget));
}

private function handleGenTextInputHelpItemChanged(event:GenTextInputWithHelpEvent):void
{
	record[event.target.xmlTag] = event.currentTarget.dataValue;
	record[event.target.labelTag] = event.currentTarget.labelValue;	
	dispatchEvent(new EditBarEvent(EditBarEvent.EDITBARITEMCHANGED_EVENT, event.currentTarget));
}

private function handleComBoxBoxItemChanged(event:GenComboBoxEvent):void
{
	record[event.target.xmlTag] = event.currentTarget.dataValue;
	dispatchEvent(new EditBarEvent(EditBarEvent.EDITBARITEMCHANGED_EVENT, event.currentTarget));
}

private function handleGenTextInputItemChanged(event:GenTextInputEvent):void
{
	record[event.target.xmlTag] = event.currentTarget.dataValue;
	dispatchEvent(new EditBarEvent(EditBarEvent.EDITBARITEMCHANGED_EVENT, event.currentTarget));
}

private function handleGenDateFieldItemChanged(event:GenDateFieldEvent):void
{
	record[event.target.xmlTag] = event.currentTarget.dataValue;
	dispatchEvent(new EditBarEvent(EditBarEvent.EDITBARITEMCHANGED_EVENT, event.currentTarget));
}

public function getColumn(name:String):Object
{
	var column:Object;
	var ary:Array = getChildren();
	
	for(var i:int=0; i < ary.length; i++)
	{
		if(ary[i].id == name)
		{
			column = ary[i]
			break;
		}
	}
	
	return column;
}

private function handleFocusInEvent(event:FocusEvent):void
{
	dispatchEvent(new EditBarEvent(EditBarEvent.SCROLLONTAB_EVENT, event.currentTarget));
}
 
public function lastColumnWidth():void
{
	getColumn(structure.children()[structure.children().length() - 1].@data).percentWidth = 100
}
private function doubleClickHandler(event:Event):void
{
	dispatchEvent(new EditBarEvent(EditBarEvent.EDITBARDOUBLECLICK_EVENT, event.currentTarget));
}
 