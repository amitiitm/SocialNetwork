import business.events.GetInformationEvent;

import com.generic.components.LookupLimitedRecordSearch;
import com.generic.events.GenTextInputWithHelpEvent;
import com.generic.events.LookupRecordSearchEvent;

import flash.events.Event;
import flash.events.FocusEvent;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.managers.PopUpManager;
import mx.rpc.IResponder;

[Bindable]
private var _dataType:String = "S";
[Bindable]
private var _defaultDataValue:String	=	"";
[Bindable]
private var _defaultLabelValue:String	=	"";
[Bindable]
private var _xmlTag:String	=	""; // we will send/receive data in this tag  to/from table, will work behind the seen
[Bindable]
private var _labelTag:String	=	""; // we will send/receive data in this tag to/from table, will be viewable to user
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
private var _dataField:String	=	"";  // it will contain tag name of lookup corrosponding to the _xmlTag
[Bindable]
private var _labelValue:String	=	"";
[Bindable]
private var _labelField:String	=	"";// it will contain tag name of lookup corrosponding to the _labelTag
[Bindable]
private var _recordStatusEnabled:Boolean = true;
[Bindable]
private var _viewOnlyFlag:Boolean = false;
[Bindable]
private var _initialEditableFlag:Boolean = true;
[Bindable]
private var _toolTip:String;
/* private var __genModel:GenModelLocator=GenModelLocator.getInstance(); */

private var _filterEnabled:Boolean = false;
private var _filterKeyName:String = "";
private var _filterKeyValue:String = "";
		
private var changedFlag:Boolean = false;		 
private var _oldValue:String;
private var isLookupOpen:Boolean	=	false;
private var getInformationEvent:GetInformationEvent;
private var isFirstTimeFocusIn:Boolean	=	true;
private var _minimumChar:String			=	'0';
private var _lookupFormatUrl:String		=	"lookupHelpFormat";
/*note ...only dataField and labelField is reqquired it is the field which we will show and send for save.........   */


[Bindable]
public function set text(value:String):void
{
	tiLabelField.text	=	value;
} 
 
public function get text():String
{
	return tiLabelField.text;
}
public function set dataType(aString:String):void
{
	_dataType = aString;
}

public function get dataType():String
{
	return _dataType;
}

public function set defaultDataValue(aString:String):void
{
	_defaultDataValue = aString;
}

public function get defaultDataValue():String
{
	return _defaultDataValue;
}
public function set defaultLabelValue(aString:String):void
{
	_defaultLabelValue = aString;
}

public function get defaultLabelValue():String
{
	return _defaultLabelValue;
}
public function set xmlTag(aString:String):void
{
	_xmlTag = aString;
}
/*since this property is used at many places , we are not removing it*/
public function set defaultValue(aString:String):void
{
	_defaultLabelValue = aString;
}
public function get defaultValue():String
{
	return _defaultLabelValue;
}
public function get xmlTag():String
{
	return _xmlTag;
}
public function set labelTag(aString:String):void
{
	_labelTag = aString;
}

public function get labelTag():String
{
	return _labelTag;
}
public function set validationFlag(aString:String):void
{
	_validationFlag = aString;
}

public function get validationFlag():String
{
	return _validationFlag;
}

public function set updatableFlag(aString:String):void
{
	_updatableFlag = aString;
}

public function get updatableFlag():String
{
	return _updatableFlag;
}

public function set tableName(aString:String):void
{
	_tableName = aString;
}

public function get tableName():String
{
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
}

public function get dataValue():String
{
	return _dataValue;
}
[Bindable]
public function set labelValue(aString:String):void
{
	_labelValue = aString;
	tiLabelField.dataValue = _labelValue;	
}

public function get labelValue():String
{
	_labelValue = tiLabelField.dataValue;
	return _labelValue;
}
public function set dataField(aString:String):void
{
	_dataField = aString;
}
public function get dataField():String
{
	return _dataField;
}
public function set labelField(aString:String):void
{
	_labelField = aString;
}
public function get labelField():String
{
	return _labelField;
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
	if(aString == null)
	{
		aString = ""
	}
	_filterKeyValue = aString

		
	if(filterEnabled)
	{
		if(_filterKeyValue == "")
		{
			labelValue	=	"";
			dataValue	=	"";
		}
	}
}

public function get filterKeyValue():String
{
 	return _filterKeyValue
}

public function set filterEnabled(aBoolean:Boolean):void 
{
 	_filterEnabled = aBoolean
}

public function get filterEnabled():Boolean
{
 	return _filterEnabled
}

public function set recordStatusEnabled(aBoolean:Boolean):void
{
	_recordStatusEnabled = aBoolean;
}

public function get recordStatusEnabled():Boolean
{
	return _recordStatusEnabled;
}

public function set viewOnlyFlag(aBoolean:Boolean):void
{
	_viewOnlyFlag    = aBoolean;
	if(initialEditableFlag)
	{
		tiLabelField.enabled	=	!aBoolean;
		btnLookup.enabled	=	!aBoolean;
	}	
}
public function get viewOnlyFlag():Boolean
{
	return _viewOnlyFlag;
}
public function set initialEditableFlag(aBoolean:Boolean):void
{
	_initialEditableFlag	=	this.enabled;
}

public function get initialEditableFlag():Boolean
{
	return _initialEditableFlag;
}
public function set oldValue(aString:String):void 
{
 		_oldValue = aString	;
}

public function get oldValue():String
{
 	return _oldValue
}

public function set minimumChar(aString:String):void
{
	if(aString != null && aString != '')
	{
		_minimumChar	=	aString;	
	}
} 
 
public function get minimumChar():String
{
	return _minimumChar;
}
public function set lookupFormatUrl(aString:String):void
{
	_lookupFormatUrl	=	aString;
} 
 
public function get lookupFormatUrl():String
{
	return _lookupFormatUrl;
}
/*--------------------------lookup detail window----------------------*/

private function handleLookupClick():void
{
	if(!viewOnlyFlag)
	{
		if(isLookupOpen)
		{
			return;	
		}
			
		
		/* if(tiLabelField.text.length >= int(minimumChar))
		{ */
			
			if(filterEnabled)
			{
			   if(filterKeyValue == "")
			   {
			   	 return;
			   }	
			}
			isLookupOpen			=	true;	
			var lookupObj:LookupLimitedRecordSearch;
			lookupObj				= 	LookupLimitedRecordSearch(PopUpManager.createPopUp(this , LookupLimitedRecordSearch ,true));
			lookupObj.searchValue	=	tiLabelField.text;
			lookupObj.lookupName	=	dataSourceName;
			lookupObj.labelField	=	labelField;
			lookupObj.targetObj		=	tiLabelField;
			lookupObj.lookupFormatUrl	=	lookupFormatUrl;
			lookupObj.filterKeyName		=	filterKeyName;
			lookupObj.filterKeyValue	=	filterKeyValue;
			lookupObj.minimumChar		=	int(minimumChar)
			lookupObj.addEventListener(LookupRecordSearchEvent.LOOKUPCLOSE_EVENT,lookupWindowCloseEventHandler)
		/* }
		else
		{
			//Alert.show('Atleast 3 character is required to refine search.');
		}	 */		
	}
}
private function lookupWindowCloseEventHandler(e:Event):void
{
	isLookupOpen			=	false;
	 if(oldValue	!= tiLabelField.text)
	{
		changedFlag = true;
		//__genModel.isLockScreen = true;
	} 
	
}
private function hbFocusInHandler(e:Event):void
{
	if(isFirstTimeFocusIn)
	{
		changedFlag = false;
		oldValue = tiLabelField.text;
		isFirstTimeFocusIn	=	false;		
	}	
}
private function textInputItemChangeHandler(e:Event):void
{
	// if we donot stop this event(GenTextInputEvent) here then it will go to the parent of this and 
	//since we are using itemChangedEvent in parent as GenTextInputWithHelpEvent it will give type mismatch error
	//and also we donot want this event in its parent to call.
	e.stopImmediatePropagation();
}
private function textInputHandler():void
{
	changedFlag = true;
}
private function changeHandler():void
{
	changedFlag = true;//23 may 2012 changedFlag will not get affected on backspace and delete press so we have do this.
	//__genModel.isLockScreen = true;
}
private function hbFocusOutHandler(e:FocusEvent):void
{
	if(!isLookupOpen)
	{
		
		if(Object(focusManager.getFocus()).name == this.tiLabelField.name ||  Object(focusManager.getFocus()).name == this.btnLookup.name)
		{
			
		}
		else
		{
			//we have got focus out of hbox .
			//we have to check validity of value call service if valid then call itemchangevent if not valid then set blank and call
			//item change event
			
			isFirstTimeFocusIn	=	true;
			
			if(oldValue	!= tiLabelField.text && changedFlag)
			{
				if(filterEnabled)
				{
				   if(filterKeyValue == "")
				   {
				   	  checkValidityResultHandler(new XML(<results><result><valid>N</valid></result></results>))
				   	 return;
				   }	
				}
				var callbacks:IResponder = new mx.rpc.Responder(checkValidityResultHandler, null);
				
				getInformationEvent	=	new GetInformationEvent('checkvalidity', callbacks, tiLabelField.text ,dataSourceName,labelField,dataField,filterKeyName,filterKeyValue);
				getInformationEvent.dispatch(); 				
			}
			else
			{
				changedFlag = false;
				//__genModel.isLockScreen = false;
			}			
		}			
	}				
}
private function checkValidityResultHandler(resultXml:XML):void
{
	if(resultXml.children().child('valid').toString().toUpperCase() == 'Y')
	{
		/* we also need values because user can direct type code(labelFieled without using lookup help to select) 
		in this case we donot know dataValue of this code thus we need both labelValue and dataValue also if valid */		
		
		dataValue	=		resultXml.children().child('data_value').toString()
		//labelValue	=		resultXml.children().child('label_value').toString()
		this.dispatchEvent(new GenTextInputWithHelpEvent(GenTextInputWithHelpEvent.ITEMCHANGED_EVENT))
		
	}
	else
	{
		dataValue				=	defaultDataValue;
		labelValue				=	defaultLabelValue;	
		this.dispatchEvent(new GenTextInputWithHelpEvent(GenTextInputWithHelpEvent.ITEMCHANGED_EVENT))
	}
	
	//__genModel.isLockScreen = false;		
}
private function creationCompleteHandler():void
{
	this.tiLabelField.name     = this.tiLabelField.name+this.id;
	this.btnLookup.name		   = this.btnLookup.name+this.id
	
	this.addEventListener(FocusEvent.FOCUS_IN,hbFocusInHandler);
	this.addEventListener(FocusEvent.FOCUS_OUT,hbFocusOutHandler);
	
}