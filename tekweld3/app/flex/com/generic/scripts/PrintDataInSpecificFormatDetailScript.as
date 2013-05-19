// ActionScript file
import com.generic.customcomponents.*;
import com.generic.events.*;

import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.utils.getQualifiedClassName;

import model.GenModelLocator;

import mx.containers.HBox;
import mx.controls.*;
import mx.managers.PopUpManager;

private var viewFormat:XML;
private var selectedView:XML;
private var _ckAll:CheckBox = new CheckBox();
private var aryObjects:Array = new Array();
private var lbSuccess:Boolean;


[Bindable]
public var printDataXML:XML = new XML(<print_data_params/>);
private var __genModel:GenModelLocator=GenModelLocator.getInstance();

public function handleCreationComplete():void
{
	this.setFocus();
	__genModel = GenModelLocator.getInstance();
	viewFormat = __genModel.activeModelLocator.viewObj.viewFormat;
	
	selectedView = new XML(__genModel.activeModelLocator.viewObj.selectedView)
	

	generateObjects();
	popupSize()
	setViewData();
} 

private function popupSize():void
{
	this.x = (this.screen.width - this.width) / 3;
	this.y =  (this.screen.height - this.height) / 3; 
}

public function generateObjects():void
{
	addLabel();
	addCriteria();
}

private function addLabel():void
{
	var _hBox:HBox = new HBox();
	
	var _lblFrom:Label = new Label();
	var _lblTo:Label = new Label();
	var _lblMultiSelect:Label = new Label();
	
	_ckAll.addEventListener(MouseEvent.CLICK, ckAllClickHandler)
	_hBox.setStyle("horizontalAlign", "center");
	_hBox.percentWidth = 100;

	_ckAll.width = 120;
	_ckAll.label = "All";
	_ckAll.labelPlacement = "left";
	_ckAll.setStyle("textAlign","right");

	_lblFrom.width = 100;
	_lblTo.width = 100;
	_lblMultiSelect.width = 300;

	_hBox.addChild(_ckAll);
	_hBox.addChild(_lblFrom);
	_hBox.addChild(_lblTo);
	_hBox.addChild(_lblMultiSelect);
	
	_lblFrom.text = "From";
	_lblFrom.setStyle("textAlign", "center");
	
	_lblTo.text = "To";
	_lblTo.setStyle("textAlign", "center");

	_lblMultiSelect.text = "Select Multiple (',' separated)";
	_lblMultiSelect.setStyle("textAlign", "center");

	vbMain.addChild(_hBox);
}

private function ckAllClickHandler(event:MouseEvent):void
{
	for(var i:int = 0; i < aryObjects.length; i++)
	{
		if(getQualifiedClassName(aryObjects[i]) == 'com.generic.customcomponents::CriteriaCheckBox')
		{
			if(aryObjects[i].id.substr(0, 2).toLowerCase() == 'ck')
			{
				if (_ckAll.selected == true)
				{
					aryObjects[i].selected = true;
				}
				else
				{
					aryObjects[i].selected = false;
				}
				resetObjects(aryObjects[i])
			}
		}
	}
}

private function addCriteria():void
{
	vbMain.setStyle("verticalGap", "3");

	var _hBox:HBox;
	var _lblComp:Label;
	var _objFrom:String;
	var ccbAll:CriteriaCheckBox;
	var cwcbAll:CriteriaWithoutCheckBox;
		
	for(var i:int = 0; i < viewFormat.children().length(); i++)
	{
		_hBox = new HBox();
		_hBox.height = 24;
		_hBox.setStyle("horizontalAlign","left")

		//add checkbox
		_objFrom = viewFormat.children()[i].attribute("from");
		
		if(_objFrom == "")
		{
			cwcbAll = new CriteriaWithoutCheckBox();
			cwcbAll.label = viewFormat.children()[i].attribute("label");
			cwcbAll.setStyle("textAlign","right")
			cwcbAll.id = viewFormat.children()[i].attribute("checkbox");
			cwcbAll.dataType = viewFormat.children()[i].attribute("dataType");
			cwcbAll.width= 112;

			_hBox.addChild(cwcbAll);
			aryObjects.push(cwcbAll);

			generateControls(cwcbAll, viewFormat.children()[i].attribute("dataType").toString(), i, _hBox);
		}
		else
		{
			ccbAll = new CriteriaCheckBox();
			ccbAll.label = viewFormat.children()[i].attribute("label");
			ccbAll.labelPlacement = "left"
			ccbAll.setStyle("textAlign","right")
			ccbAll.id = viewFormat.children()[i].attribute("checkbox");
			ccbAll.dataType = viewFormat.children()[i].attribute("dataType");
			ccbAll.width= 120;
			ccbAll.addEventListener(MouseEvent.CLICK, setCriteriaValue);

			_hBox.addChild(ccbAll);
			aryObjects.push(ccbAll);

			generateControls(ccbAll, viewFormat.children()[i].attribute("dataType").toString(), i, _hBox);
		}
		
		vbMain.addChild(_hBox);
	} 

	// VD added 08 May 2009
	var idCriteria:GenTextInput = new GenTextInput();
	idCriteria.xmlTag = "context"
	idCriteria.id = "tiContext"
	idCriteria.text = "0"
	
	idCriteria.visible = false    	
	aryObjects.push(idCriteria)
	// End VD
}

private function objTextInputFromFocusOutHandler(event:Event):void
{
	var tempHBox:HBox = (HBox)(event.target.parent.parent)

	for(var i:int=0; i < tempHBox.getChildren().length; i++)
	{
		if(getQualifiedClassName(tempHBox.getChildAt(i)) == 'com.generic.customcomponents::CriteriaCheckBox')
		{
			var tempCCB:CriteriaCheckBox = (CriteriaCheckBox)(tempHBox.getChildAt(i))

			tempCCB.objFrom.text = (GenTextInput)(tempCCB.objFrom).allTrim
			tempCCB.objTo.text = (GenTextInput)(tempCCB.objFrom).text + 'zzzz'

			break;
		}
	}
}

private function objDynamicComboBoxFromFocusOutHandler(event:Event):void
{
	var tempHBox:HBox = (HBox)(event.target.parent.parent.parent)

	for(var i:int=0; i < tempHBox.getChildren().length; i++)
	{
		if(getQualifiedClassName(tempHBox.getChildAt(i)) == 'com.generic.customcomponents::CriteriaCheckBox')
		{
			var tempCCB:CriteriaCheckBox = (CriteriaCheckBox)(tempHBox.getChildAt(i))

			tempCCB.objFrom.text = (GenDynamicComboBox)(tempCCB.objFrom).text
			tempCCB.objTo.text = (GenDynamicComboBox)(tempCCB.objFrom).text + 'zzzz'

			break;
		}
	}
}

private function objComboBoxFromChangeHandler(event:Event):void
{
	var tempHBox:HBox = (HBox)(event.target.parent)

	for(var i:int=0; i < tempHBox.getChildren().length; i++)
	{
		if(getQualifiedClassName(tempHBox.getChildAt(i)) == 'com.generic.customcomponents::CriteriaCheckBox')
		{
			var tempCCB:CriteriaCheckBox = (CriteriaCheckBox)(tempHBox.getChildAt(i))
			
			if ( event.target.selectedIndex >= 0)
			{
				tempCCB.objTo.selectedIndex = event.target.selectedIndex
			}
			break;
		}
	}
}

private function generateControls(crit:Object, type:String, i:int, hBox:Object):void
{
 	var _objFrom:Object;
	var _objTo:Object; 
	var _objMultiSelect:Object;
	var _fromVisible:Boolean=true;
	
	var _maxChar:String;
	var type_cd:String;
	var subType_cd:String;

	var xmlTagMultiSelect:String;
	
	//Set maximum No of Charachers.
	 _maxChar = viewFormat.children()[i].attribute("maxChar");
	
	switch(type)
	{
	    case 'D':
	    	_objFrom = new GenDateField();
	    	_objTo = new GenDateField();
	    	
	        break;
	    case 'S':
			_objFrom = new GenTextInput();
			_objTo = new GenTextInput();
			
			if (_maxChar != '')
			{
				_objFrom.maxChars = _maxChar
				_objTo.maxChars = _maxChar
			}

			_objFrom.addEventListener(FocusEvent.FOCUS_OUT, objTextInputFromFocusOutHandler)

	    	break;
 		case 'N':
			_objFrom = new GenTextInput();
			_objTo = new GenTextInput()	;    	
			
			_objFrom.restrict = "-.0123456789"
			_objTo.restrict = "-.0123456789"
			
			if(_maxChar != '')
			{
				_objFrom.maxChars = _maxChar
				_objTo.maxChars = _maxChar
			}

			_objFrom.addEventListener(FocusEvent.FOCUS_OUT, objTextInputFromFocusOutHandler)

	    	break;
	    case 'C':
			_objFrom = new GenComboBox();
			_objTo = new GenComboBox();
			
			_objFrom.type_cd = viewFormat.children()[i].attribute("type_cd");
			_objFrom.subtype_cd = viewFormat.children()[i].attribute("subtype_cd");

			_objTo.type_cd = viewFormat.children()[i].attribute("type_cd");
			_objTo.subtype_cd = viewFormat.children()[i].attribute("subtype_cd");
			
			_objFrom.addEventListener(FocusEvent.FOCUS_OUT, objComboBoxFromChangeHandler)
			
			break;	
	    default :
	    	break;
 	}
 	
	_objFrom.recordStatusEnabled = false
	_objTo.recordStatusEnabled = false		

	_objFrom.height = 20
	_objTo.height = 20		

	_objFrom.id = viewFormat.children()[i].attribute("from");
	_objTo.id = viewFormat.children()[i].attribute("to");

	_objFrom.xmlTag = viewFormat.children()[i].attribute("xmlTagFrom");
	_objTo.xmlTag = viewFormat.children()[i].attribute("xmlTagTo");
	

	if(_objFrom.id == "")
	{
		_objFrom.width = 0;
		_objFrom.visible = false;
	}
	else
	{
		_objFrom.width = 100;
		_objFrom.visible = true;
	}

	_objTo.width = 100;

	xmlTagMultiSelect = viewFormat.children()[i].attribute("xmlTagMultiSelect");

	// VD 16 Jul 2010, multiselect condition add.
	if(type == "S" && (!(xmlTagMultiSelect == null || xmlTagMultiSelect == "")))
	{
		if(String(viewFormat.children()[i].attribute("lookupFlag")).toLowerCase() == 'true')
		{
			_objMultiSelect 			=	new  GenTextInputMultiValueWithHelp()  //new  GenMultiValueWithHelp()
			
/* 			var lookupRows:XML 			=	new LookupVO().getData(viewFormat.children()[i].attribute("lookupName"));
			
		 	_objMultiSelect.lookupRows	=	lookupRows
 */

			if(viewFormat.children()[i].hasOwnProperty('@lookupFormatUrl'))
			{
				if(viewFormat.children()[i].attribute("lookupFormatUrl") != "")
				{
					_objMultiSelect.lookupFormatUrl	=	viewFormat.children()[i].attribute("lookupFormatUrl")	
				}
				
			}



			_objMultiSelect.dataField	=	viewFormat.children()[i].attribute("dataField")
			_objMultiSelect.lookupName	=	viewFormat.children()[i].attribute("lookupName")
			
			if(viewFormat.children()[i].attribute("filterEnabled").toString().toUpperCase() == 'TRUE')
			{
				_objMultiSelect.filterEnabled	=	true;
			}
			else
			{
				_objMultiSelect.filterEnabled	=	false;
			}
			
			_objMultiSelect.filterKeyName	=	viewFormat.children()[i].attribute("filterKeyName")
			 _objMultiSelect.filterKeyValue	=	viewFormat.children()[i].attribute("filterKeyValue")
			 
			_objMultiSelect.id 			= 	viewFormat.children()[i].attribute("multiSelect");
			_objMultiSelect.xmlTag 		= 	viewFormat.children()[i].attribute("xmlTagMultiSelect");
			_objMultiSelect.width 		= 	300;
			_objMultiSelect.recordStatusEnabled = false
		}
		else
		{
			_objMultiSelect = new GenTextInput();
			_objMultiSelect.id = viewFormat.children()[i].attribute("multiSelect");
			_objMultiSelect.xmlTag = viewFormat.children()[i].attribute("xmlTagMultiSelect");
			_objMultiSelect.width = 300;
			_objMultiSelect.recordStatusEnabled = false
		}
	}
	else
	{
		_objMultiSelect = new Spacer()
		_objMultiSelect.id = "tiSpacer"
		_objMultiSelect.width = 300;
	}

	_objMultiSelect.height = 20;
	
	crit.objFrom = _objFrom ;
	crit.objTo = _objTo;
	
	hBox.addChild(_objFrom);
	hBox.addChild(_objTo);
	hBox.addChild(_objMultiSelect);
	
	aryObjects.push(_objFrom);
	aryObjects.push(_objTo) ;
	
	if(type == "S")
	{
		crit.objMultiSelect = _objMultiSelect;
		aryObjects.push(_objMultiSelect);
	}
}

private function setViewData():void
{
	var _element:String ;

	for(var i:int = 0; i < aryObjects.length; i++)
	{
		_element = aryObjects[i].id.substr(2, aryObjects[i].id.length).toLowerCase();
		
		if(_element == 'context' || _element == 'spacer')
		{
			continue;
		}

		if (selectedView.elements('id').toString() !='')
		{
			if(aryObjects[i].id.substr(0, 2).toLowerCase() == 'ck')
			{
				if(selectedView.elements(_element).toString().toUpperCase() == 'Y')
				{
					if(getQualifiedClassName(aryObjects[i]) == 'com.generic.customcomponents::CriteriaCheckBox')
					{
						aryObjects[i].selected = true;
						resetObjects(aryObjects[i]);
					}
				}
				else
				{
					if(getQualifiedClassName(aryObjects[i]) == 'com.generic.customcomponents::CriteriaCheckBox')
					{
						aryObjects[i].selected = false;
						resetObjects(aryObjects[i]);
					}
				}
			}
			else 
			{
				if ( aryObjects[i].id.substr(0, 2).toLowerCase() == 'df')
				{
					aryObjects[i].text = selectedView.elements(_element).toString();
				}
				else if( aryObjects[i].id.substr(0, 2).toLowerCase() == 'cb')
				{
					aryObjects[i].dataValue = selectedView.elements(_element).toString();
				}
				else
				{
					aryObjects[i].dataValue = selectedView.elements(_element).toString();
				}
			}
		}
		else
		{
			if(aryObjects[i].id.substr(0, 2).toLowerCase() == 'ck')
			{
				if(getQualifiedClassName(aryObjects[i]) == 'com.generic.customcomponents::CriteriaCheckBox')
				{
					aryObjects[i].selected = true;
					resetObjects(aryObjects[i]);
				}
			}
		}
	}
	
	setCheckBox();
	lbSuccess = true;
}

private function setCheckBox():void
{
	_ckAll.selected = true
	for(var i:int = 0; i < aryObjects.length; i++)
	{
		if(aryObjects[i].id.substr(0, 2).toLowerCase() == 'ck')
		{
			if(getQualifiedClassName(aryObjects[i]) == 'com.generic.customcomponents::CriteriaCheckBox')
			{
				if (aryObjects[i].selected == false)
				{
					_ckAll.selected = false
					break;
				}
			}
		}
	}
}

private function closePopUp():void
{
	this.parentApplication.focusManager.activate();
	PopUpManager.removePopUp(this)
}

private function convertCriteriaToXml():void
{
	var _element:String ;

	for(var i:int = 0; i < aryObjects.length; i++)
	{
		_element = aryObjects[i].id.substr(2, aryObjects[i].id.length).toLowerCase();
	
		// VD 16072010		
		if(_element == 'spacer')
		{
			continue;
		}
		
		if(aryObjects[i].id.substr(0, 2).toLowerCase() == 'ck')
		{
			if(aryObjects[i].selected)
			{
				selectedView[_element] = 'Y';
			}
			else
			{ 
				selectedView[_element] = 'N';
			}
		}
		else 
		{
			if(aryObjects[i].id.substr(0, 2).toLowerCase() == 'cb')
			{
				if (aryObjects[i].text == '')
				{
					selectedView[_element] = '';
				}
				else if (aryObjects[i].text == 'zzzz')
				{
					selectedView[_element] = 'zzzz';
				}
				else
				{
					selectedView[_element] = aryObjects[i].dataValue;
				}
			}
			else
			{
				selectedView[_element] = aryObjects[i].dataValue;
			}
		}
	}
	
	selectedView["company_id"] = __genModel.user.default_company_id.toString(); // VD 20 May 2010.
}

private function resetObjects(accb:CriteriaCheckBox):void 
{
	if (accb.selected)
	{
		accb.objFrom.enabled = false;
		accb.objTo.enabled = false;

		switch (accb.dataType)
		{
			case'D':
				accb.objFrom.text = '01/01/1990';
				accb.objTo.text = '12/12/2025';
				break;
				
			case'C':
				accb.objFrom.text = '';
				accb.objTo.text = 'zzzz';
				break;
					
			case 'N':
				accb.objFrom.text = '-99999999.00';
				accb.objTo.text = '99999999.00';
				break;
			default:
				if(accb.objMultiSelect.id != "tiSpacer")
				{
					accb.objMultiSelect.enabled = true;
				}
			 	
				accb.objFrom.text = "";
				accb.objTo.text = "zzzz";

				break;
		}
	}
	else
	{
		accb.objFrom.enabled = true;
		accb.objTo.enabled = true;
		
		if(accb.dataType == "S" && accb.objMultiSelect.id != "tiSpacer")
		{
			accb.objMultiSelect.enabled = false;
			accb.objMultiSelect.dataValue = '';
		}
	} 
}

private function setCriteriaValue(event:MouseEvent):void
{
	resetObjects((CriteriaCheckBox)(event.target));
}

/*print related functionality*/
public function set printFormats(aXML:XML):void
{
	cmbFormats.dataProvider	=	aXML.children();
}
private function btnOKClickHandler():void
{
	convertCriteriaToXml();
	
	switch(String(rdogroupPrint.selectedValue).toUpperCase())
	{
		case  'PDF' 	:
							printDataXML.export_type			=	'PDF'
							printDataXML.export_format			=	cmbFormats.selectedItem.name.toString();
							printDataXML.component_name			=	cmbFormats.selectedItem.component_name.toString();
							printDataXML.user_id				=	__genModel.user.userID
							printDataXML.document_id			=	__genModel.activeModelLocator.documentObj.documentID
							
							printDataXML.appendChild(selectedView.copy());
							
																			 
							closePopUp();
							break;
		case  'EXCEL' :
							printDataXML.export_type			=	'EXCEL'
							printDataXML.export_format			=	cmbFormats.selectedItem.name.toString();
							printDataXML.component_name			=	cmbFormats.selectedItem.component_name.toString();
							printDataXML.user_id				=	__genModel.user.userID
							printDataXML.document_id			=	__genModel.activeModelLocator.documentObj.documentID
							
							
							printDataXML.appendChild(selectedView.copy());
							
							closePopUp();
							break;
		default			:	Alert.show('Please Select Print Type');					
	}
	
}

private function detailKeyDownHandler(event:KeyboardEvent):void
{
	//it is needed otherwise keydown at application level will also work.

	var char:String 		= 	String.fromCharCode(event.charCode).toUpperCase();	
	
	if(event.ctrlKey &&  char != 'V')// we donot want to stop event when user press  ctrl + V(paste),so we cannot take ctrl + V as shortcust now 
	{
		event.stopImmediatePropagation();
		event.stopPropagation();
	}	

}