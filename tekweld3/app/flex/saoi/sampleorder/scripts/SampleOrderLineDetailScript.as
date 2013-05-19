import business.commands.PreSaveRowCommand;
import business.events.GetInformationEvent;
import business.events.PreSaveRowEvent;
import business.events.RecordStatusEvent;

import com.generic.customcomponents.GenTextInput;
import com.generic.events.DetailAddEditEvent;
import com.generic.events.GenTextInputEvent;

import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.MouseEvent;

import model.GenModelLocator;

import mx.containers.HBox;
import mx.containers.VBox;
import mx.controls.Alert;
import mx.controls.ComboBox;
import mx.controls.Label;
import mx.controls.TextInput;
import mx.events.CloseEvent;
import mx.events.ListEvent;
import mx.formatters.NumberFormatter;
import mx.managers.CursorManager;
import mx.rpc.IResponder;

import saoi.muduleclasses.ApplicationConstant;
import saoi.muduleclasses.CommonMooduleFunctions;
import saoi.muduleclasses.DrawItemsOptionsFunctions;
import saoi.muduleclasses.OptionsVisiblityFunctions;
import saoi.muduleclasses.TierPricingFunctions;
import saoi.sampleorder.SampleOrderModelLocator;

private var numericFormatter:NumberFormatter = new NumberFormatter();
private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __localModel:SampleOrderModelLocator = (SampleOrderModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var item_detail:GetInformationEvent;
private var optionDescription:String = new String();
private var resultXmlFromItem:XML = new XML();
private var lot_size:int = 1;
private var isOkToSSave:Boolean	=	false;
private var preSaveRowEvent:PreSaveRowEvent;
private var blank_good_price:String ;
private var oldOptionValue:String = '';
private var newOptionValue:String = '';	
private var item_workflow:String = '';


public function creationCompleteHandler():void 
{
	numericFormatter.precision = 2;
	numericFormatter.rounding = "nearest";
	numericFormatter.useThousandsSeparator = false;
	
	dfTrans_date.dataValue = __localModel.trans_date;
	
}

private function getItemDetailAfterSave():void
{
		if(__localModel.customer_id!='' && __localModel.customer_id!=null)
		{
			if(dcItemId.text!='' && dcItemId.text!=null)
			{
				CursorManager.setBusyCursor();
				this.parentDocument.enabled  = false;
				
				var callbacks:IResponder = new mx.rpc.Responder(getItemDetailAfterSaveHandler, null);
				item_detail	=	new GetInformationEvent('item_detail_sample_order', callbacks, dcItemId.dataValue,__localModel.customer_id);
				item_detail.dispatch(); 
			}
		}
		else
		{
		 Alert.show("Please Select Customer");
		}

}
private function getItemDetailAfterSaveHandler(resultXml:XML):void
{
	CursorManager.removeBusyCursor();
	this.parentDocument.enabled  = true;
	
	initOrderOption(resultXml.attributes,dgItemOptions.rows);
	resultXmlFromItem				= resultXml
	//blank_good_price				= resultXml.blank_good_price.toString();
	item_workflow					= resultXml.workflow.toString();
    lot_size						= int(resultXml.lot_size.toString());
}

private function getItemDetails():void
{
	if(__localModel.customer_id!='' && __localModel.customer_id!=null)
	{
		if(dcItemId.text!='' && dcItemId.text!=null)
		{
			CursorManager.setBusyCursor();
			this.parentDocument.enabled  = false;
			
			var callbacks:IResponder = new mx.rpc.Responder(getItemDetailHandler, null);
			item_detail	=	new GetInformationEvent('item_detail_sample_order', callbacks, dcItemId.dataValue,__localModel.customer_id,cbBlankPrice_flag.dataValue);
			item_detail.dispatch(); 
		}
		else
		{
			cbUnit.dataValue	 			= cbUnit.defaultValue;
			taItemDescription.dataValue 	= taItemDescription.defaultValue;
			tiImage_thumnail.dataValue 		= tiImage_thumnail.defaultValue;
			tiType.dataValue				= tiType.defaultValue;
			blank_good_price				= '0.00';
			lot_size						= 1;
			resultXmlFromItem				= new XML();
		}
	}
	else
	{
	 Alert.show("Please Select Customer");
	}
	setItemCost();
}

private function getItemDetailHandler(resultXml:XML):void
{
		CursorManager.removeBusyCursor();
		this.parentDocument.enabled  = true;
	
		var dgOptionsLength:int  = dgItemOptions.rows.children().length();
		for(var i:int=0;i<dgOptionsLength;i++)
		{
			dgItemOptions.deleteRow(0);	
		}
	
		tiItemCode.dataValue 			= resultXml.code;
		//tiItemPrice.dataValue			= resultXml.cost;
		cbUnit.dataValue	 			= resultXml.unit;
		taItemDescription.dataValue 	= resultXml.description;
		tiImage_thumnail.text 			= resultXml.image_thumnail;
		tiType.dataValue				= resultXml.item_type;
		//blank_good_price				= resultXml.blank_good_price;
		item_workflow					= resultXml.workflow.toString();
		lot_size						= int(resultXml.lot_size.toString());
		resultXmlFromItem				= resultXml
		initOrderOption(resultXml.attributes);
		setItemCost();
}
private function isItemQtyMinimum(columnXml:XMLList,qty:Number):Boolean
{
	var returnValue:Boolean  = false;
	if(qty<Number(columnXml.column1.toString()))   // qty<Number((columnXml.column1.toString())/2)
	{
		returnValue  = true;
	}
	return returnValue;
}
private function setItemCost():void
{
	
	if(isItemQtyMinimum(resultXmlFromItem.columns,Number(tiItemQty.dataValue)))
	{
		blank_good_price  				=  resultXmlFromItem.ltm_price.catalog_item_prices.catalog_item_price.blank_good_price.toString();
	}
	else
	{
		blank_good_price  		 		=  resultXmlFromItem.catalog_item_prices.catalog_item_price.blank_good_price.toString();
	}
	
	if(cbBlankPrice_flag.dataValue=='Y')
	{
		tiItemPrice.dataValue 		= blank_good_price;
	}
	else
	{
		var index:int 				= new TierPricingFunctions().getColumnSize(resultXmlFromItem.columns,Number(tiItemQty.dataValue));
		if(isItemQtyMinimum(resultXmlFromItem.columns,Number(tiItemQty.dataValue)))
		{
			tiItemPrice.dataValue  				= new TierPricingFunctions().returnColumnPrice(resultXmlFromItem.ltm_price.catalog_item_prices.catalog_item_price,index);
		}
		else
		{
			tiItemPrice.dataValue  				= new TierPricingFunctions().returnColumnPrice(resultXmlFromItem.catalog_item_prices.catalog_item_price,index);
		}
		if(tiItemPrice.dataValue=='' || item_workflow !=ApplicationConstant.ITEM_WORKFLOW_EMBROIDERY) //  NO ITEM CHARGE EXCEPT EMBROIDERY TYPE ITEM
		{
			tiItemPrice.dataValue		= tiItemPrice.defaultValue;
		}
	}
	
	tiAmount.dataValue 				= (Number(tiItemPrice.dataValue) * Number(tiItemQty.dataValue)).toString();
	
	if(isInLots(int(tiItemQty.dataValue),lot_size))
	{
		
	}
	else
	{
		//Alert.show("Qty Should be in Lots"+lot_size);
	}
}

private function initOrderOption(xml:XMLList,resultXml:XML=null):void
{
	new DrawItemsOptionsFunctions().drawItemOptions(dgItemOptions,xml,vbMain,resultXml,resultXmlFromItem);
}
private function changeVisibilityOfOtheroptions(vbMain:VBox,selectedId:Number):void
{
	var optionsVisiblityFunctions:OptionsVisiblityFunctions				= new OptionsVisiblityFunctions();
	optionsVisiblityFunctions.changeVisibilityOfOtheroptions(vbMain,selectedId);	
}

public  function setDefaultLabel(xml:XMLList,index:int):void
{
	for(var i:int =0; i<XMLList(xml.children()).length();i++)
	{
		var defaultValue:String = XMLList(xml.children())[i].default_value;
		if(defaultValue.toUpperCase()=='Y')
		{
			var hbox:HBox = HBox(vbMain.getChildByName('hb'+index));
			var lblDefault:Label  = Label(hbox.getChildAt(3));         //default label
			lblDefault.text       = "Default Value :"+XMLList(xml.children())[i].code.toString();
			break;
		}
	}
}
private function remarksItemChnageHandler(event:Event):void
{
	if(dgItemOptions.rows.children().length()>0)
	{
		for(var i:int = 0 ; i < dgItemOptions.rows.children().length(); i++)
		{
			dgItemOptions.rows.children()[Number(GenTextInput(event.target).id)].remarks = GenTextInput(event.target).dataValue;
		}
	}
}
public  function setComboBoxValueBlank(cb:ComboBox):void
{
	var index:int  = 0;
	cb.selectedIndex = index;
} 
public  function setDefault(cb:ComboBox):void
{
		var index:int  = -1;
		for(var i:int =0; i<XMLList(cb.dataProvider).length();i++)
		{
			var defaultValue:String = XMLList(cb.dataProvider)[i].default_value;
			if(defaultValue.toUpperCase()=='Y')
			{
				index = i;
				break;
			}
		}
		cb.selectedIndex = index;
}
private function focusInEventhandler(event:FocusEvent):void
{
	oldOptionValue	  = '';
	if(ComboBox(event.target).selectedIndex>=0)
	{
		oldOptionValue  = ComboBox(event.target).selectedItem.code.toString();
	}
	
}
private function focusOutEventhandler(event:FocusEvent):void
{
	newOptionValue    = '';
	if(ComboBox(event.target).selectedIndex>=0)
	{
		newOptionValue  = ComboBox(event.target).selectedItem.code.toString();
	}
	
	/*if(oldOptionValue!=newOptionValue)
	{
		var commonMooduleFunctions:CommonMooduleFunctions	= new CommonMooduleFunctions();
		commonMooduleFunctions.checkForOptionsCharge(dtlSetup,oldOptionValue,newOptionValue,__localModel.customer_id);
	}*/
}
private function comboboxClickHandler(event:MouseEvent):void
{
	var cbOptions:ComboBox			= ComboBox(event.currentTarget);
	cbOptions.dispatchEvent(new FocusEvent("focusIn"));							// after click it doesn't take focus out event 
	cbOptions.setFocus();
}
private function comboboxChangeHandler(event:ListEvent):void
{
	var recordStatusEvent:RecordStatusEvent  = new RecordStatusEvent('MODIFY');
	recordStatusEvent.dispatch();
	
	var selectedId:Number			  = Number(ComboBox(event.target).id);
	changeVisibilityOfOtheroptions(vbMain,selectedId);
	
	for(var j:int=0;j<vbMain.getChildren().length;j++)                    // reset remarks when no options save in database
	{
		var hbox:HBox 					  							  = HBox(vbMain.getChildByName('hb'+j));
		var remarksTextInput:GenTextInput 							  = GenTextInput(hbox.getChildAt(2))
		remarksTextInput.dataValue									  = '';
	}
	
	if(dgItemOptions.rows.children().length()>0)
	{
		for(var i:int=0;i<vbMain.getChildren().length;i++)
		{
			var hbox:HBox 					  							  = HBox(vbMain.getChildByName('hb'+i));
			var comboBoxValue:ComboBox									  = ComboBox(hbox.getChildAt(1))
			
			var attribute_value:String									  = '';
			if(comboBoxValue.selectedIndex>=0)
			{
				attribute_value	 									  	  = ComboBox(hbox.getChildAt(1)).selectedItem.code.toString();
			}
			if(selectedId==0)  // means imprint options r changes than we have to reset remarks text
			{		
				dgItemOptions.rows.children()[i].remarks 					  = '';
			}
			
			dgItemOptions.rows.children()[i].catalog_attribute_value_code = attribute_value;
		}
	}
}

private function setOptionValue(recordXml:XML):void
{
	
	var optionXml:XML  = dgItemOptions.rows;
 	for(var i:int=0;i<vbMain.getChildren().length;i++)
 	{
 		var hbox:HBox = HBox(vbMain.getChildByName('hb'+i));
 		Label(hbox.getChildAt(0)).text  	   = optionXml.children()[i].catalog_attribute_code;
 		
		var remarksValue:TextInput  			= TextInput(hbox.getChildAt(2));
		remarksValue.text						= optionXml.children()[i].remarks.toString();
		
 		var cb:ComboBox  = ComboBox(hbox.getChildAt(1));
 		var value_code:String   = optionXml.children()[i].catalog_attribute_value_code.toString();
 		
 		var index:int  = -1;
		for(var k:int =0; k<XMLList(cb.dataProvider).length();k++)
		{
			var code:String = XMLList(cb.dataProvider)[k].code;
			if(code==value_code)
			{
				index = k;
				break;
			}
		}
		
		cb.selectedIndex = index;
 	}
 	
	
}
private function saveOptions():XML
 {
	var __saveOption:XML = new XML("<" + dgItemOptions.rootNode + "/>")
	for(var i:int=0;i<vbMain.getChildren().length;i++)
	{
		var attribute:XMLList = new XMLList(<sales_order_attributes_value/>);
		var hbox:HBox = HBox(vbMain.getChildByName('hb'+i));
		attribute.catalog_attribute_code = Label(hbox.getChildAt(0)).text;
		
		
		var remarksValue:GenTextInput  	= GenTextInput(hbox.getChildAt(2));
		attribute.remarks 			   	= remarksValue.dataValue;
		
		var comboBoxValue:ComboBox  = ComboBox(hbox.getChildAt(1));
		if(comboBoxValue.selectedIndex<0)
		{
			attribute.catalog_attribute_value_code  = '';
		}
		else
		{
			attribute.catalog_attribute_value_code = comboBoxValue.selectedItem.code.toString();
		}
		attribute.company_id 		=	__genModel.user.default_company_id;
		attribute.updated_by 		= 	__genModel.user.userID;
		attribute.created_by		= 	__genModel.user.userID;
		attribute.trans_flag		=   'A';
		attribute.id				= '';
		attribute.lock_version		= 0
		attribute.catalog_item_id 	= dcItemId.dataValue.toString();
		__saveOption.appendChild(attribute);
	}
	return __saveOption;
 }

private function saveOptionDescription():String
{
	var __OptionDesc:String = new String();
	for(var i:int=0;i<vbMain.getChildren().length;i++)
	{
		var hbox:HBox 					= HBox(vbMain.getChildByName('hb'+i));
		var attribute_String:String  	= Label(hbox.getChildAt(0)).text +":";
		var comboBoxValue:ComboBox  	= ComboBox(hbox.getChildAt(1));
		if(hbox.visible)
		{
			if(comboBoxValue.selectedIndex<0)
			{
				attribute_String 		= attribute_String.concat('');
				__OptionDesc 			= __OptionDesc.concat(attribute_String,';');
			}
			else if(comboBoxValue.selectedItem.code.toString() =='')
			{
				attribute_String 		= attribute_String.concat(comboBoxValue.selectedItem.code.toString());
				__OptionDesc 			= __OptionDesc.concat(attribute_String,';');
			}
			else
			{
				attribute_String 		= attribute_String.concat(comboBoxValue.selectedItem.code.toString());
				__OptionDesc 			= __OptionDesc.concat(attribute_String,';');
			}
			
		}
	}
	return __OptionDesc;
}
private function saveMissingInfoDescription():String
{
	var resultXml:XML							= resultXmlFromItem;
	var attributeXml:XMLList					= XMLList(resultXml.attributes);
	
	var missInfo:String 						= new String();
	for(var i:int=0;i<vbMain.getChildren().length;i++)
	{
		var hbox:HBox 							= HBox(vbMain.getChildByName('hb'+i));
		var attribute_String:String  			= Label(hbox.getChildAt(0)).text +":";
		var comboBoxValue:ComboBox  			= ComboBox(hbox.getChildAt(1));
		var missing_info_required_flag:String  	= attributeXml.children()[i].missing_info_required_flag.toString();
		
		if(hbox.visible && missing_info_required_flag.toUpperCase()=='Y')
		{
			if(comboBoxValue.selectedIndex<0)
			{
				attribute_String 		= attribute_String.concat('');
				missInfo 				= missInfo.concat(attribute_String,';');
			}
			else if(comboBoxValue.selectedItem.code.toString() =='')
			{
				attribute_String 		= attribute_String.concat(comboBoxValue.selectedItem.code.toString());
				missInfo 				= missInfo.concat(attribute_String,';');
			}
			
		}
	}
	return missInfo;
} 

 	
override protected function preSaveRowEventHandler(event:DetailAddEditEvent):int
{
	var returnValue:int = 0;
	/*if(isOkToSSave)
	{
		isOkToSSave		=  false;
		returnValue 	=  0;
	}
	else if(!isInLots(int(tiItemQty.dataValue),lot_size))
	{
		Alert.show("Item Quantity should be in the lots of ".concat(lot_size.toString().concat(" . Do you want to continue to save order?")),"",Alert.YES | Alert.NO,this,discardChangeEvent,null,Alert.YES);
		return -1;
	}*/
	if(dgItemOptions.rows.children().length()<=0)
	{
		dgItemOptions.rows.appendChild(saveOptions().children());
	}
	taOptionsDescription.dataValue		= '';
	taOptionsDescription.dataValue		= saveOptionDescription();
	taMissingInfoDescription.dataValue	= '';
	taMissingInfoDescription.dataValue	= saveMissingInfoDescription();
	return returnValue;
}
private function discardChangeEvent(event:CloseEvent):void
{
	if(event.detail == Alert.YES)
	{
		isOkToSSave	=	true;
		preSaveRowEvent = new PreSaveRowEvent();
		preSaveRowEvent.dispatch();
	}
}
override protected function retrieveRowEventHandler(event:DetailAddEditEvent):void
{
	var rowXml:XML		= event.rowXml.copy();
	dgItemOptions.seprateRows();                             // it seprate rows and deleteRows becouse grid all rows deleted rows as well as rows  
	//dgItemOptions.rows	= XML(rowXml.sales_order_attributes_values);
	
	getItemDetailAfterSave();
}

override protected function resetObjectEventHandler():void
{
	vbMain.removeAllChildren();
}

/*private function  getColumnSize(columnXml:XMLList,size:int):int
{
	var index:int=1;
	if(size<Number(columnXml.column2.toString()))
	{
		index = 1;
	}
	else if(size<Number(columnXml.column3.toString()))
	{
		index = 2;
	}
	else if(size<Number(columnXml.column4.toString()))
	{
		index = 3;
	}
	else if(size<Number(columnXml.column5.toString()))
	{
		index = 4;
	}
	else if(size<Number(columnXml.column6.toString()))
	{
		index = 5;
	}
	else if(size<Number(columnXml.column7.toString()))
	{
		index = 6;
	}
	else if(size<Number(columnXml.column8.toString()))
	{
		index = 7;
	}
	else if(size<Number(columnXml.column9.toString()))
	{
		index = 8;
	}
	else if(size<Number(columnXml.column10.toString()))
	{
		index = 9;
	}
	else if(size>=Number(columnXml.column10.toString()))
	{
		index = 10;
	}
	return index;
}

private function returnColumnPrice(column_pricing:XMLList,index:int):String
{
	var price:String = column_pricing.column10.toString();
	if(index==1)
	{
		price =  column_pricing.column1.toString();
	}
	else if(index==2)
	{
		price =  column_pricing.column2.toString();
	}
	else if(index==3)
	{
		price =  column_pricing.column3.toString();
	}
	else if(index==4)
	{
		price =  column_pricing.column4.toString();
	}
	else if(index==5)
	{
		price =  column_pricing.column5.toString();
	}
	else if(index==6)
	{
		price =  column_pricing.column6.toString();
	}
	else if(index==7)
	{
		price =  column_pricing.column7.toString();
	}
	else if(index==8)
	{
		price =  column_pricing.column8.toString();
	}
	else if(index==9)
	{
		price =  column_pricing.column9.toString();
	}
	else if(index==10)
	{
		price =  column_pricing.column10.toString();
	}
	return price;
}*/
private function isInLots(qty:int,lotsize:int):Boolean
{
	var returnValue:Boolean= false;
	returnValue =  (((qty %lotsize)==0) ? true : false);
	return returnValue;
}
private function setBlankPrice():void
{
	setItemCost();
}
	