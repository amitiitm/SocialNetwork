import business.events.GetInformationEvent;
import business.events.RecordStatusEvent;

import com.generic.customcomponents.GenDateField;
import com.generic.events.AddEditEvent;
import com.generic.events.GenTextInputEvent;
import com.generic.events.GenUploadButtonEvent;
import com.generic.genclass.GenNumberFormatter;
import com.generic.genclass.GenObject;

import invn.jewelry.JewelryModelLocator;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.core.Application;
import mx.events.DataGridEvent;
import mx.managers.CursorManager;
import mx.rpc.IResponder;
private var numericFormatter2:GenNumberFormatter = new GenNumberFormatter();
private var numericFormatter3:GenNumberFormatter = new GenNumberFormatter();
private var numericFormatter4:GenNumberFormatter = new GenNumberFormatter();
private var numericFormatter6:GenNumberFormatter = new GenNumberFormatter();

private var getInformationEvent:GetInformationEvent;

[Bindable]
private var image_name:String;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
private var __localModel:JewelryModelLocator = (JewelryModelLocator)(GenModelLocator.getInstance().activeModelLocator);


private function init():void
{
	getJewelryUnitConversion();
	setJewelryDefaultSetting();
	
	setJewelryDefaultValues();
	
	numericFormatter2.rounding 	= "nearest";
	numericFormatter2.precision = 2;

	numericFormatter3.rounding 	= "nearest";
	numericFormatter3.precision = 3;

	numericFormatter4.rounding 	= "nearest";
	numericFormatter4.precision = 4;

	numericFormatter6.rounding 	= "nearest";
	numericFormatter6.precision = 6;
	
	__localModel.tempGrid = dtlSimilar_items.dgDtl ;
	
	if(tiStore_code.dataValue != '')
	{
		__localModel.item_code = tiStore_code.dataValue ;
	}
}	

private function setJewelryDefaultValues():void
{
	tiGold_mu.dataValue      =	__genModel.masterData.child('jewelry_default').metal_markup.value
	tiSilver_mu.dataValue    =	__genModel.masterData.child('jewelry_default').metal_markup.value
	tiPlatinum_mu.dataValue  = 	__genModel.masterData.child('jewelry_default').metal_markup.value
	tiPalladium_mu.dataValue =	__genModel.masterData.child('jewelry_default').metal_markup.value
	
	tiMarkup_per.dataValue		  = __genModel.masterData.child('jewelry_default').wholesale_markup.value 
	tiMarkup_per_retail.dataValue = __genModel.masterData.child('jewelry_default').retail_markup.value
}

private function setAllWholeSellMarkup():void
{
	tiCasting_mu.dataValue 			=  tiMarkup_per.dataValue;
	tiFinding_mu.dataValue			=  tiMarkup_per.dataValue;
	tiDiamond_mu.dataValue			=  tiMarkup_per.dataValue;
	tiColor_stone_mu.dataValue		=  tiMarkup_per.dataValue;
	tiCenter_stone_mu.dataValue		=  tiMarkup_per.dataValue;
	tiSettinglabor_mu.dataValue		=  tiMarkup_per.dataValue;
	tiFinishing_labor_mu.dataValue	=  tiMarkup_per.dataValue;
	tiOther_mu.dataValue			=  tiMarkup_per.dataValue;
}

private function setAllWholesaleAndRetailPrice():void
{
	setCastingWholesaleAndRetailPrice();
	setFindingWholesaleAndRetailPrice();
	setDiamondWholesaleAndRetailPrice();
	setColorStoneWholesaleAndRetailPrice();
	setCenterStoneWholesaleAndRetailPrice();
	setSettingWholesaleAndRetailPrice();
	setFinishWholesaleAndRetailPrice();
	setOtherWholesaleAndRetailPrice();
}

private function setTotalWholesalePrice():void
{
	var _casting_price:Number		=	Number(numericFormatter2.format(tiCasting_amt.dataValue));
	var _finding_price:Number		=	Number(numericFormatter2.format(tiFinding_amt.dataValue));
	var _diam_price:Number			=	Number(numericFormatter2.format(tiDiamond_amt.dataValue));
	var _color_stone_price:Number	=	Number(numericFormatter2.format(tiColor_stone_amt.dataValue));
	var _center_stone_price:Number	=	Number(numericFormatter2.format(tiCenter_stone_amt.dataValue));
	var _setting_price:Number		=	Number(numericFormatter2.format(tiSettinglabor_amt.dataValue));
	var _finishing_price:Number		=	Number(numericFormatter2.format(tiFinishing_labor_amt.dataValue));
	var _other_price:Number			=	Number(numericFormatter2.format(tiOther_amt.dataValue));
	
	tiPrice.dataValue = numericFormatter2.format(_casting_price + _finding_price + _diam_price + _color_stone_price + _center_stone_price + _setting_price + _finishing_price + _other_price);
}

private function setTotalRetailPrice():void
{
	var _casting_retail_price:Number		=	Number(numericFormatter2.format(tiCasting_amt_retail.dataValue));
	var _finding_retail_price:Number		=	Number(numericFormatter2.format(tiFinding_amt_retail.dataValue));
	var _diam_retail_price:Number			=	Number(numericFormatter2.format(tiDiamond_amt_retail.dataValue));
	var _color_stone_retail_price:Number	=	Number(numericFormatter2.format(tiColor_stone_amt_retail.dataValue));
	var _center_stone_retail_price:Number	=	Number(numericFormatter2.format(tiCenter_stone_retail_price.dataValue));
	var _setting_retail_price:Number		=	Number(numericFormatter2.format(tiSettinglabor_amt_retail.dataValue));
	var _finishing_retail_price:Number		=	Number(numericFormatter2.format(tiFinishinglabor_amt_retail.dataValue));
	var _other_retail_price:Number			=	Number(numericFormatter2.format(tiOther_amt_retail.dataValue));
	
	tiRetail_price.dataValue				=	numericFormatter2.format(_casting_retail_price + _finding_retail_price + _diam_retail_price + _color_stone_retail_price + _center_stone_retail_price + _setting_retail_price + _finishing_retail_price + _other_retail_price);
}

private function setAllRetailMarkup(): void
{
	tiCasting_mu_retail.dataValue        =  tiMarkup_per_retail.dataValue;
	tiFinding_mu_retail.dataValue        =  tiMarkup_per_retail.dataValue;
	tiDiamond_mu_retail.dataValue        =  tiMarkup_per_retail.dataValue;
	tiColor_stone_mu_retail.dataValue	 =  tiMarkup_per_retail.dataValue;
	tiCenter_stone_retail_mu.dataValue   =  tiMarkup_per_retail.dataValue;
	tiSettinglabor_mu_retail.dataValue   =  tiMarkup_per_retail.dataValue;
	tiFinishinglabor_mu_retail.dataValue =  tiMarkup_per_retail.dataValue;
	tiOther_mu_retail.dataValue          =  tiMarkup_per_retail.dataValue;
}

private function handleVendorFixedCostItemChanged(event:GenTextInputEvent):void
{
	setModelLocatorValue();
	updateAllTotal();
}

// VD 20110104
private function handleDiscountAmtItemChanged(event:GenTextInputEvent):void
{
	tiDiscount_per.dataValue = "0";
	updateAllTotal();	
}

private function handleDiscountPerItemChanged(event:GenTextInputEvent):void
{
	updateAllTotal();
}

private function handleSurchargePerItemChanged(event:GenTextInputEvent):void
{
	updateAllTotal();
}

private function handleDutyPerItemChanged(event:GenTextInputEvent):void
{
	updateAllTotal();
}

private function handleMarupPerItemChanged(event:GenTextInputEvent):void
{
	var _markup_per:Number	=	Number(tiMarkup_per.dataValue);
	var _total_cost:Number	=	Number(tiTotal_cost.dataValue);	
	var _price:Number		=	0;

	if(isNaN(_total_cost))
	{
		_total_cost = 0
	}
		
	if(__localModel.margin_calculation_flag == 'N')
	{
		_price	=	Number(numericFormatter2.format(_total_cost * (100 + _markup_per) / 100));
	}
	else
	{
		_price	=	Number(numericFormatter2.format( (100 * _total_cost)/ (100 - _markup_per)));
	}

	tiPrice.dataValue	=	numericFormatter2.format(_price.toString());

	setAllWholeSellMarkup();
	updateAllTotal();
}

private function handlePriceItemChanged(event:GenTextInputEvent):void
{
	var _price:Number		=	Number(tiPrice.dataValue);
	var _total_cost:Number	=	Number(tiTotal_cost.dataValue);
	var _markup_per:Number	=	0;

	if(isNaN(_total_cost))
	{
		_total_cost	= 0;
	}	
	
	if(_total_cost > 0)
	{
		if(__localModel.margin_calculation_flag == 'N')
		{
			_markup_per	= Number(numericFormatter2.format(100 * (_price - _total_cost) / _total_cost));			
		}
		else
		{
			_markup_per	= Number(numericFormatter2.format(100 * (_price - _total_cost) / _price));
		}
		
		tiMarkup_per.dataValue	=	numericFormatter2.format(_markup_per.toString());
	}

	setAllWholeSellMarkup();
	updateAllTotal();
}

private function handleMarkupPerRetailItemChanged(event:GenTextInputEvent):void
{
	var _markup_per_retail:Number	=	Number(tiMarkup_per_retail.dataValue);
	var _price:Number				=	Number(tiPrice.dataValue);
	var _price_retail:Number		=	0;
	
	if(isNaN(_price))
	{
		_price = 0;
	}

	if(__localModel.margin_calculation_flag == 'N')
	{
		_price_retail	= Number(numericFormatter2.format(_price * (100 + _markup_per_retail) / 100));	
	}
	else
	{
		_price_retail	= Number(numericFormatter2.format((100 * _price) / (100 - _markup_per_retail)));	
	}

	tiRetail_price.dataValue	=	numericFormatter2.format(_price_retail.toString());

	setAllRetailMarkup();
	updateAllTotal();
}

private function handleRetailPriceItemChanged(event:GenTextInputEvent):void
{
	var _retail_price:Number	=	Number(tiRetail_price.dataValue);
	var _price:Number			=	Number(tiPrice.dataValue);
	var _markup_per:Number		=	0;
	
	if(isNaN(_price))
	{
		_price = 0;		
	}	

	if(_price > 0)
	{
		if(__localModel.margin_calculation_flag == 'N')
		{
			_markup_per	= Number(numericFormatter2.format(100 * (_retail_price - _price) / _price));
		}
		else
		{
			_markup_per	= Number(numericFormatter2.format(100 * (_retail_price - _price) / _retail_price));
		}
		
		tiMarkup_per_retail.dataValue	=	numericFormatter2.format(_markup_per.toString());
	}

	setAllRetailMarkup();
	updateAllTotal();
}

// VD End Event Handling

private function getDutyCost():Number
{
	var _duty_cost:Number 	= 	0.00;	
	var _cast_amt:Number 	= 	0.00;
	var _find_amt:Number 	= 	0.00;
	var _diam_amt:Number 	= 	0.00;
	var _stone_amt:Number 	= 	0.00;
	var _labor_amt:Number 	= 	0.00;
	
	_cast_amt 	= 	getCastingDutyCost();
	_find_amt 	= 	getFindingDutyCost();
	_diam_amt 	= 	getDiamondDutyCost();
	_stone_amt 	= 	getColorStoneDutyCost();
	_labor_amt 	= 	getLaborDutyCost();

	_duty_cost 	=	_cast_amt + _find_amt + _diam_amt + _stone_amt + _labor_amt 

	return _duty_cost;
}

// *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* Override Reset/Retrieve method *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*   
override protected function retrieveRecordEventHandler(event:AddEditEvent):void 
{
	tiStore_code.enabled = false;

	if(dgAttribute.rows.children().length > 0)
	{
		dgAttribute.selectedIndex = 0
	}	
	
	filterValue()
	setSelectedValue()
	setModelLocatorValue();
	setImages();
	
	__localModel.tempGrid = dtlSimilar_items.dgDtl ;
	__localModel.item_code = tiStore_code.dataValue ;
	
	dcDesign_id.enabled	=	false;
	FixedCostChangedHandler();	
}

override protected function resetObjectEventHandler():void
{
	tiStore_code.enabled = true;
	filterValue()
	setModelLocatorValue();
	setImages();
	
	dcDesign_id.enabled	=	true ;
	
	setJewelryDefaultValues();
	FixedCostChangedHandler();	
}

// *-*-*-*-*-*-*-*-*-*-*-*-* Gold/Silver/Platinum/Palladium total base rate *-*-*-*-*-*-*-*-*-*-*-*-*
private function setTotalGoldRate(event:GenTextInputEvent):void
{
	var total:Number = Number(tiGold_base_rate.dataValue) + Number(tiGold_surcharge.dataValue);
	tiGold_total_rate.dataValue = total.toString();
}

private function setTotalSilverRate(event:GenTextInputEvent):void
{
	var total:Number = (Number)(tiSilver_base_rate.dataValue) + (Number)(tiSilver_surcharge.dataValue)
	tiSilver_total_rate.dataValue = (String)(total)
}

private function setTotalPlatinumRate(event:GenTextInputEvent):void
{
	var total:Number = (Number)(tiPlatinum_base_rate.dataValue) + (Number)(tiPlatinum_surcharge.dataValue)
	tiPlatinum_total_rate.dataValue = (String)(total)
}

private function setTotalPalladiumRate(event:GenTextInputEvent):void
{
	var total:Number = (Number)(tiPalladium_base_rate.dataValue) + (Number)(tiPalladium_surcharge.dataValue)
	tiPalladium_total_rate.dataValue = (String)(total)
}

 
private function handleItemChangedItem_Category():void
{
	getAttributes()
	if(__genModel.masterData.child('jewelry_default').item_auto_number.value.toString() == 'Y')
	{	
		if(dcCatalog_item_category_id.dataValue != '')
		{
			CursorManager.setBusyCursor();
			Application.application.enabled = false; 
			var callbacks:IResponder = new mx.rpc.Responder(getItemAutoNumberHandler, null);

			getInformationEvent	= new GetInformationEvent('item_auto_number', callbacks, dcCatalog_item_category_id.dataValue);
			getInformationEvent.dispatch(); 
		}
	}
}	

private function getItemAutoNumberHandler(resultXml:XML):void
{
	tiStore_code.dataValue = resultXml
	
	CursorManager.removeBusyCursor();
	Application.application.enabled = true; 
}
// *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* Functions for Attribute *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*  
private function getAttributes():void
{
	if(dcCatalog_item_category_id.text != "" && dcCatalog_item_category_id.text != null)
	{
		var callbacks:IResponder = new mx.rpc.Responder(attributeListHandler, null);
		
		getInformationEvent = new GetInformationEvent('item_category_attributes_info', callbacks, dcCatalog_item_category_id.dataValue);
		getInformationEvent.dispatch(); 
	}
}

private function attributeListHandler(resultXml:XML):void
{
	if(resultXml.children().length() > 0)
	{
		dgAttribute.rows = resultXml;
		dgAttribute.selectedIndex = 0
	  
		filterValue()
		setSelectedValue()
	}
	else
	{
		dgAttribute.rows = new XML("<" + dgAttribute.rootNode + "></" + dgAttribute.rootNode + ">");
		
		while(dgValues.rows.children().length > 0)
		{
			if(Number(dgValues.rows.children()[0].child('id').toString()) > 0)
			{
				dgValues.rows.children()[0].trans_flag	=	"D";
				XML(dgValues.deletedRows).appendChild(new XML(dgValues.rows.children()[0]));
			} 
			
			delete dgValues.rows.children()[0];
		}
    
		dgValues.rows = new XML("<" + dgValues.rootNode + "/>");
	}
}

private function filterValue():void
{
	var strValue:String = '';

	if(dgAttribute.selectedRow != null)
	{
		strValue = dgAttribute.selectedRow['catalog_attribute_id'].toString();
	}
		
	var attributeValues:XMLList = __genModel.lookupObj.catalogattributevalue.children();
	var filteredValues:XMLList 	= attributeValues.(elements('catalog_attribute_id') == strValue);
	var xml:XML = new XML(<rows></rows>);
	
	xml.appendChild(filteredValues);
	
	dgValues.rows = xml;
}

private function handleValuesFocusOut(event:DataGridEvent):void
{
	if(event.currentTarget == dgValues)
	{
		var str:String = dgValues.selectedRow['select_yn'].toString()
		
		if(str == 'Y')
		{
			for(var i:int=0; i < dgValues.dataProvider.length; i++)
			{
				if(i == event.rowIndex)
				{
					dgAttribute.selectedRow.catalog_attribute_value_id = dgValues.dataProvider[i]['id'].toString() ;
					dgAttribute.selectedRow.value_name = dgValues.dataProvider[i]['name'].toString();
				}
				else
				{
					dgValues.dataProvider[i]['select_yn'] = 'N';
				}
			}
		}
		else if(str == 'N')
		{
			dgAttribute.selectedRow.catalog_attribute_value_id = ' ';
			dgAttribute.selectedRow.value_name = ' ';
		}
	}
}

private function handleAttributeItemClick():void
{
	filterValue()
	setSelectedValue()
}

private function setSelectedValue():void
{
	if(dgAttribute.dataProvider.length > 0)
	{
		if(dgAttribute.selectedIndex == -1)
		{
			dgAttribute.selectedIndex = 0
		}
		
		var value_id:String = dgAttribute.selectedRow['catalog_attribute_value_id'].toString()

		for(var i:int=0; i < dgValues.dataProvider.length; i++)
		{
			if(value_id == dgValues.dataProvider[i]['id'].toString())
			{
				dgValues.dataProvider[i]['select_yn'] = 'Y'
			}
			else
			{
				dgValues.dataProvider[i]['select_yn'] = 'N'
			}
		}
	}
}

// Vivek New Coding

// For Palladium
private function handlePalladiumTotalRateChanged(event:GenTextInputEvent):void
{
	setTotalPalladiumRate(event);

	setModelLocatorValue();	

	calculateGoldPrice_casting();
	calculateGoldPrice_finding();
	updateCastings();
	updateFindings();
	updateAllTotal()
}

private function handlePalladiumMarkupChanged(event:GenTextInputEvent):void
{
	setModelLocatorValue();	

	calculateGoldPrice_casting();
	calculateGoldPrice_finding();
	updateCastings();
	updateFindings();
	updateAllTotal()
}

// For Platinum
private function handlePlatinumTotalRateChanged(event:GenTextInputEvent):void
{
	setTotalPlatinumRate(event);

	setModelLocatorValue();	
	
	calculateGoldPrice_casting();
	calculateGoldPrice_finding();
	updateCastings();
	updateFindings();
	updateAllTotal()
}

private function handlePlatinumMarkupChanged(event:GenTextInputEvent):void
{
	setModelLocatorValue();	

	calculateGoldPrice_casting();
	calculateGoldPrice_finding();
	updateCastings();
	updateFindings();
	updateAllTotal()
}

// For Silver
private function handleSilverTotalRateChanged(event:GenTextInputEvent):void
{
	setTotalSilverRate(event);

	setModelLocatorValue();	
	
	calculateGoldPrice_casting();
	calculateGoldPrice_finding();
	updateCastings();
	updateFindings();
	updateAllTotal()
}

private function handleSilverMarkupChanged(event:GenTextInputEvent):void
{
	setModelLocatorValue();	

	calculateGoldPrice_casting();
	calculateGoldPrice_finding();
	updateCastings();
	updateFindings();
	updateAllTotal()
}

private function handleGoldTotalRateChanged(event:GenTextInputEvent):void
{
	setTotalGoldRate(event);
	setModelLocatorValue();
	
	if(Number(tiVendor_fixed_cost.dataValue) > 0)
	{
		setVendorFixedCost()	
	}
	
	calculateGoldPrice_casting();
	calculateGoldPrice_finding();
	updateCastings();
	updateFindings();
	updateAllTotal();
}

private function handleGoldMarkupChanged(event:GenTextInputEvent):void
{
	setModelLocatorValue();

	calculateGoldPrice_casting();
	calculateGoldPrice_finding();
	updateCastings();
	updateFindings();
	updateAllTotal();
}

private function setVendorFixedCost():void
{
	var _gold_increment:Number = Number(tiGold_increment.dataValue);
	var _gold_total_rate:Number = Number(tiGold_base_rate.dataValue) + Number(tiGold_surcharge.dataValue);
	var _gold_total_rate_old:Number = Number(tiGold_base_rate.oldValue) + Number(tiGold_surcharge.dataValue);
	var _vendor_fixed_cost:Number = Number(tiVendor_fixed_cost.dataValue);
	
	_vendor_fixed_cost = _vendor_fixed_cost + _gold_increment * (_gold_total_rate - _gold_total_rate_old)
	tiVendor_fixed_cost.dataValue = _vendor_fixed_cost.toString();
	setModelLocatorValue();
}	

private function updateAllTotal():void // PB's wf_updatehdrtotal
{
	var _vendor_fixed_cost:Number	=	Number(tiVendor_fixed_cost.dataValue);
	var _casting_cost:Number 		= 	Number(tiCasting_cost.dataValue);
	var _finding_cost:Number 		= 	Number(tiFinding_cost.dataValue);
	var _diamond_cost:Number 		= 	Number(tiDiamond_cost.dataValue);
	var _color_stone_cost:Number 	= 	Number(tiColor_stone_cost.dataValue);
	var _center_stone_cost:Number 	= 	Number(tiCenter_stone_cost.dataValue);
	var _setting_cost:Number 		= 	Number(tiSettinglabor_cost.dataValue);
	var _labor_cost:Number 			= 	Number(tiFinishing_labor_cost.dataValue);
	var _other_cost:Number 			= 	Number(tiOther_cost.dataValue);
	var _surcharge_per:Number		=	Number(tiSurcharge_per.dataValue);
	var _discount_per:Number		=	Number(tiDiscount_per.dataValue);
	var _duty_per:Number			=	Number(tiDuty_per.dataValue);
	var _total_cost:Number			=	0;
	var _surcharge_amt:Number		=	0;
	var _discount_amt:Number		=	0;
	var _duty_amt:Number			=	0;
	var _duty_cost:Number			=	0;
	var _subtotal_cost:Number		=	0;
	
		
	_total_cost 	=	Number(numericFormatter2.format(_casting_cost + _finding_cost + _diamond_cost + _color_stone_cost + _center_stone_cost + _setting_cost + _labor_cost + _other_cost));
	_subtotal_cost	= 	_total_cost;
	_total_cost 	= 	Number(numericFormatter2.format(_total_cost + _vendor_fixed_cost));
	
	tiSubTotal_cost.dataValue = _subtotal_cost.toString();		
	
	if(_vendor_fixed_cost > 0)
	{
		_surcharge_amt = _vendor_fixed_cost;
	}
	else
	{
		_surcharge_amt = Number(numericFormatter2.format(getSetterValue()));
	}	
	
	_surcharge_amt = Number(numericFormatter2.format((_surcharge_amt * _surcharge_per) / 100));
	tiSurcharge_amt.dataValue = _surcharge_amt.toString();
	
	_total_cost = _total_cost + _surcharge_amt;
	
	if(_discount_per > 0)
	{
		_discount_amt = Number(numericFormatter2.format((_total_cost * _discount_per) / 100));
	}
	else
	{
		_discount_amt = Number(tiDiscount_amt.dataValue);
	}
 
	_total_cost = _total_cost - _discount_amt;

	if(_vendor_fixed_cost > 0)
	{
		_duty_cost = _vendor_fixed_cost;
	}
	else
	{
		_duty_cost = Number(numericFormatter2.format(getDutyCost()));
	} 		 
	
	_duty_amt	= Number(numericFormatter2.format((_duty_cost * _duty_per) / 100));	
	_total_cost = _total_cost + _duty_amt;

	tiSurcharge_amt.dataValue 	= _surcharge_amt.toString();
	tiDiscount_amt.dataValue 	= _discount_amt.toString();
	tiDuty_amt.dataValue 		= _duty_amt.toString();
	
	// Rashmi & Vivek D 16 Jan 2012
	if(cbFixedCost.dataValue.toUpperCase() == 'F')
	{
		recalculateDiscount()
	}
	else
	{
		tiTotal_cost.dataValue = numericFormatter2.format(_total_cost.toString());
	}
	
	_total_cost = Number(tiTotal_cost.dataValue)
	// End
	
	setAllWholesaleAndRetailPrice();
	
	var _wholesale_price:Number;
	var _wholesale_markup_per:Number;
	var _retail_price:Number;
	var _retail_markup_per:Number;
	
	if(__localModel.change_component_price == 'N')
	{
		_wholesale_price = Number(tiPrice.dataValue);
		
		if(_total_cost > 0)
		{
			if(__localModel.margin_calculation_flag == 'N')
			{
				_wholesale_markup_per = Number(numericFormatter2.format(((_wholesale_price - _total_cost) * 100) / _total_cost));
			}
			else
			{
				if(_wholesale_price > 0)
				{
					_wholesale_markup_per = Number(numericFormatter2.format(((_wholesale_price - _total_cost) * 100) / _wholesale_price)); 
				}
				else
				{
					_wholesale_markup_per = 0;
				}
			}
			tiMarkup_per.dataValue = _wholesale_markup_per.toString();
		}
		
		_retail_price = Number(tiRetail_price.dataValue);
		
		if(_wholesale_price > 0)
		{
			if(__localModel.margin_calculation_flag == 'N')
			{
				_retail_markup_per = Number(numericFormatter2.format(((_retail_price - _wholesale_price) * 100) / _wholesale_price));
			}
			else
			{
				if(_retail_price > 0)
				{
					_retail_markup_per = Number(numericFormatter2.format(((_retail_price - _wholesale_price) * 100) / _retail_price));					
				}
			}
			tiMarkup_per_retail.dataValue = _retail_markup_per.toString();
		}
	}  
	else
	{
		_wholesale_markup_per = Number(tiMarkup_per.dataValue);
		
		if(_wholesale_markup_per >= 100 && __localModel.margin_calculation_flag == 'Y')
		{
			_wholesale_markup_per = 99;
		}

		if(__localModel.margin_calculation_flag == 'N')
		{
			_wholesale_price = Number(numericFormatter2.format(_total_cost + (_total_cost * _wholesale_markup_per / 100)));
		}
		else
		{
			_wholesale_price = Number(numericFormatter2.format((100 * _total_cost) / (100- _wholesale_markup_per))); 
		}
		
		tiPrice.dataValue 	= numericFormatter2.format(_wholesale_price.toString());
		_retail_markup_per 	= Number(tiMarkup_per_retail.dataValue);

		if(_retail_markup_per >= 100 && __localModel.margin_calculation_flag == 'Y')
		{
			_retail_markup_per = 99
		}

		if(__localModel.margin_calculation_flag == 'N')
		{
			_retail_price = Number(numericFormatter2.format(_wholesale_price + (_wholesale_price * _retail_markup_per / 100)));
		}	
		else
		{
			_retail_price = Number(numericFormatter2.format((100 * _wholesale_price) / (100 - _retail_markup_per)));
		}	

		tiRetail_price.dataValue = _retail_price.toString();
	}
	
	setVendorPOCost()	
}

private function setVendorPOCost():void
{
	var _surchanrge_amt:Number 		= 	Number(tiSurcharge_amt.dataValue);
	var _vendor_fixed_cost:Number	=	Number(tiVendor_fixed_cost.dataValue);
	var _vendor_cost:Number 		= 	0;
	
	if(isNaN(_surchanrge_amt))
	{
		_surchanrge_amt = 0;
	}	
	
	_vendor_cost = getCastingVendorValue() + getFindingVendorValue() + getDiamondVendorValue() + getColorStoneVendorValue() + getSettingVendorValue() + getLaborVendorValue(); 
	_vendor_cost = _vendor_cost + _surchanrge_amt;  
	
	if(_vendor_fixed_cost > 0)
	{
		tiVendor_po_cost.dataValue	=	numericFormatter2.format(_vendor_fixed_cost.toString()); 		
	}
	else
	{
		tiVendor_po_cost.dataValue	=	numericFormatter2.format(_vendor_cost.toString()); 		
	}
}

private function getSetterValue():Number // Should be use previous method but need to modify for setter
{
	var _setter_value:Number;
	_setter_value = getCastingSetterValue() + getFindingSetterValue() + getDiamondSetterValue() + getColorStoneSetterValue() + getLaborSetterValue(); 

	return _setter_value; 
}

private function styleUnitConversion(as_item:String, as_metal_type:String, as_from:String, as_to:String):Number // Later will move to class & can access from anywhere
{
	var _conversionList:XMLList = __localModel.jewelry_unit_conversion.children();
	var _resultXMLList:XMLList;	
	var _factor:Number; 
	
	if(as_from == as_to)
	{
		return 1;
	}
	
	_resultXMLList = _conversionList.(elements("item") == as_item && elements("metal_type") == as_metal_type && elements("from_unit") == as_from && elements("to_unit") == as_to);

	if(_resultXMLList.length() == 0)
	{
		_resultXMLList = _conversionList.(elements("item") == as_item && elements("metal_type") == as_metal_type && elements("from_unit") == as_to && elements("to_unit") == as_from);
	
		if(_resultXMLList.length() == 0)
		{
			return 0
		}
		else
		{
			_factor = Number(numericFormatter6.format(_resultXMLList.factor));
			
			if(_factor != 0)
			{
				_factor = Number(numericFormatter6.format(1/_factor));
			}
		}						
	} 
	else
	{
		_factor = Number(numericFormatter6.format(_resultXMLList.factor));
	}

	return _factor;
} 

private function setModelLocatorValue():void
{
	__localModel.gold_base_rate			=	Number(tiGold_base_rate.dataValue);
	__localModel.gold_mu				=	Number(tiGold_mu.dataValue);
	__localModel.gold_total_rate		=	Number(tiGold_total_rate.dataValue);
	__localModel.platinum_mu			=	Number(tiPlatinum_mu.dataValue);
	__localModel.platinum_total_rate	=	Number(tiPlatinum_total_rate.dataValue);
	__localModel.palladium_mu			=	Number(tiPalladium_mu.dataValue);
	__localModel.palladium_total_rate	=	Number(tiPalladium_total_rate.dataValue);
	__localModel.silver_mu				=	Number(tiSilver_mu.dataValue);
	__localModel.silver_total_rate		=	Number(tiSilver_total_rate.dataValue);
	__localModel.vendor_fixed_cost		=	Number(tiVendor_fixed_cost.dataValue);
}

private function getJewelryUnitConversion():void
{
	var callbacks:IResponder	=	new mx.rpc.Responder(setJewelryUnitConversion, null);
		
	getInformationEvent			=	new GetInformationEvent('jewelry_unit_conversion', callbacks);
	getInformationEvent.dispatch(); 
}

private function setJewelryUnitConversion(resultXml:XML):void
{
	__localModel.jewelry_unit_conversion = resultXml;
}

private function setJewelryDefaultSetting():void
{
	__localModel.margin_calculation_flag	=	__genModel.masterData.child('jewelry_default').margin_calculation.value.toString();
	__localModel.change_component_price		=	__genModel.masterData.child('jewelry_default').change_price.value.toString();
	__localModel.diamond_loss_percentage	=	Number(__genModel.masterData.child('jewelry_default').diam_loss_per.value.toString());
	__localModel.stone_loss_percentage		=	Number(__genModel.masterData.child('jewelry_default').stone_loss_per.value.toString());
	__localModel.wholesale_markup			=	Number(__genModel.masterData.child('jewelry_default').wholesale_markup.value.toString());
	__localModel.retail_markup				=	Number(__genModel.masterData.child('jewelry_default').retail_markup.value.toString());

	if(isNaN(__localModel.diamond_loss_percentage))
	{
		__localModel.diamond_loss_percentage = 0;
	} 

	if(isNaN(__localModel.stone_loss_percentage))
	{
		__localModel.stone_loss_percentage = 0;
	} 

	if(isNaN(__localModel.wholesale_markup))
	{
		__localModel.wholesale_markup = 0;
	} 

	if(isNaN(__localModel.retail_markup))
	{
		__localModel.retail_markup = 0;
	} 
}
override protected function  preSaveEventHandler(event:AddEditEvent):int
{
	if(dtlPrice.dgDtl.rows.children().length() <= 0)
	{
		var xml:XML			=	new XML(<catalog_item_price/>)
	   
		xml.id				=	''
		xml.company_id		=	__genModel.user.default_company_id
		xml.updated_by		=	__genModel.user.userID
		xml.created_by		=	__genModel.user.userID
        xml.lock_version	=	0
        
 	
        xml.serial_no		=	'101'
        xml.trans_flag		=	'A'
        xml.price			=	tiRetail_price.text;
        xml.discount_per	=	'0.00'
						
		
        xml.from_date		=	new GenDateField().currentDate();
        xml.to_date			=	new GenDateField().currentDate(); // We need to se 31 Dec with current year
        	
        	
		dtlPrice.dgDtl.rows.appendChild(xml);
	}
	return 0;
}

private function handleUploadEvent(event:GenUploadButtonEvent):void
{
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;

	var recordStstusEvent:RecordStatusEvent	=	new RecordStatusEvent('MODIFY');
	recordStstusEvent.dispatch();
}

private function handleCompleteEvent(event:GenUploadButtonEvent):void
{
	setImage(event.currentTarget.id);	
}
	
private function setImages():void
{
	setImage('btnBrowse_imageThumnail')
	setImage('btnBrowse_imageSmall')
	setImage('btnBrowse_imageNormal')
	setImage('btnBrowse_imageEnlarge')
	setImage('btnBrowse_sketchImage1')
	setImage('btnBrowse_sketchImage2')
	setImage('btnBrowse_sketchImage3')
}

private function setDesignImages():void
{
	setImage('btnBrowse_sketchImage1')
	setImage('btnBrowse_sketchImage2')
	setImage('btnBrowse_sketchImage3')
}

private function setImage(str:String):void
{
	switch(str)
	{
		 case 'btnBrowse_imageThumnail':
				imageThumnail.source = __genModel.path.image + tiImage_Thumnail.dataValue
			break;
		case 'btnBrowse_imageSmall':
			imageSmall.source = __genModel.path.image + tiImage_Small.dataValue;	
		    break;

		case 'btnBrowse_imageNormal':
			imageNormal.source = __genModel.path.image + tiImage_Normal.dataValue;	
		    break;                    

		case 'btnBrowse_imageEnlarge':
			imageEnlarge.source = __genModel.path.image + tiImage_Enlarge.dataValue;	
		    break;
 
		case 'btnBrowse_sketchImage1':
			image1Sketch1.source = __genModel.path.image + tiSketch_image1.dataValue;	
			break;

		case 'btnBrowse_sketchImage2':
			image1Sketch2.source = __genModel.path.image + tiSketch_image2.dataValue;	
		    break;                    

		case 'btnBrowse_sketchImage3':
			image1Sketch3.source = __genModel.path.image + tiSketch_image3.dataValue;	
			break;
	}
	setHeaderImage();
}
private function setHeaderImage():void
{ 
	if(tiImage_Thumnail.dataValue != '')
	{
		image.source = imageThumnail.source ;
	}
	else if(tiImage_Small.dataValue != '')
	{
		image.source = imageSmall.source ;
	}
	else if(tiImage_Normal.dataValue != '')
	{
		image.source = imageNormal.source ;
	}
	else 
	{
		image.source = imageEnlarge.source ;
	}
	
}
	
private function handleDesignChanged():void
{
	 if(dcDesign_id.dataValue != '')
		{	
			CursorManager.setBusyCursor();
			Application.application.enabled = false; 
		
			var callbacks:IResponder = new mx.rpc.Responder(getBomDetailsHandler, null);

			getInformationEvent	= new GetInformationEvent('bominfo', callbacks, dcDesign_id.dataValue, 'Master');
			getInformationEvent.dispatch(); 
		} 

}	

private function getBomDetailsHandler(resultXml:XML):void
{
	var sketch_code :String	=	tiStore_code.dataValue
	var genObj:GenObject = new GenObject();
	
	genObj.setRecord(__genModel.activeModelLocator.addEditObj.genObjects, resultXml);
	
	dcDesign_id.dataValue			=		resultXml.children()[0]['catalog_item_id'].toString();
	tiStore_code.dataValue			=		sketch_code
	tiWeb_code.dataValue			=		sketch_code
	tiImage_Thumnail.dataValue		=		''
	tiImage_Small.dataValue			=		''
	tiImage_Normal.dataValue		=		''
	tiImage_Enlarge.dataValue		=		''
	
	
	
	handleItemChangedItem_Category();
	setDesignImages();
	getJewelryUnitConversion();
		
	__localModel.margin_calculation_flag	=	__genModel.masterData.child('jewelry_default').margin_calculation.value.toString();
	__localModel.change_component_price		=	__genModel.masterData.child('jewelry_default').change_price.value.toString();
	__localModel.diamond_loss_percentage	=	Number(__genModel.masterData.child('jewelry_default').diam_loss_per.value.toString());
	__localModel.stone_loss_percentage		=	Number(__genModel.masterData.child('jewelry_default').stone_loss_per.value.toString());
	__localModel.wholesale_markup			=	Number(__genModel.masterData.child('jewelry_default').wholesale_markup.value.toString());
	__localModel.retail_markup				=	Number(__genModel.masterData.child('jewelry_default').retail_markup.value.toString());
	
	
	__localModel.gold_base_rate			=	resultXml.children()[0]['gold_base_rate'].toString();
	__localModel.gold_mu				=	resultXml.children()[0]['gold_mu'].toString();
	__localModel.gold_total_rate		=	resultXml.children()[0]['gold_total_rate'].toString();
	__localModel.platinum_mu			=	resultXml.children()[0]['platinum_mu'].toString();
	__localModel.platinum_total_rate	=	resultXml.children()[0]['platinum_total_rate'].toString();
	__localModel.palladium_mu			=	resultXml.children()[0]['palladium_mu'].toString();
	__localModel.palladium_total_rate	=	resultXml.children()[0]['palladium_total_rate'].toString();
	__localModel.silver_mu				=	resultXml.children()[0]['silver_mu'].toString();
	__localModel.silver_total_rate		=	resultXml.children()[0]['silver_total_rate'].toString();
	__localModel.vendor_fixed_cost		=	resultXml.children()[0]['vendor_fixed_cost'].toString();	
	
	tiJewelryOrDesignFlag.dataValue	=		'J'
	
	CursorManager.removeBusyCursor();
	Application.application.enabled = true; 
}



private function sizeChangeHandler():void
{
	__localModel.size = tiMm_size.dataValue.toString() ;
}

override protected function copyRecordCompleteEventHandler():void
{
	tiStore_code.dataValue	=	'';
	tiWeb_code.dataValue	=	'';
	dcDesign_id.dataValue 	=	'';
}	

private function preferedVendorChanged():void
{
	if(dcPrefered_vendor_id.text != "" && dcPrefered_vendor_id.text != null)
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(preferedVendorDetailsHandler, null);
		getInformationEvent	=	new GetInformationEvent('vendorinfo', callbacks, dcPrefered_vendor_id.dataValue);
		getInformationEvent.dispatch();   
	}

}

private function preferedVendorDetailsHandler(resultXml:XML):void
{
	tiGold_mu.dataValue			=	 resultXml.children().child('metal_mu').toString();
	tiSilver_mu.dataValue		=	 resultXml.children().child('metal_mu').toString();
	tiPlatinum_mu.dataValue		=	 resultXml.children().child('metal_mu').toString();
	tiPalladium_mu.dataValue	=	 resultXml.children().child('metal_mu').toString();
}

// Rashmi & Vivek D 16 Jan 2012
private function FixedCostChangedHandler():void
{
	if(cbFixedCost.dataValue.toUpperCase() == 'F')
	{
		tiTotal_cost.enabled 	=	true;
		tiDiscount_per.enabled	=	false;
		tiDiscount_amt.enabled	=	false;
	}
	else
	{
		tiTotal_cost.enabled 	=	false;
		tiDiscount_per.enabled	=	true;
		tiDiscount_amt.enabled	=	true;
	}
}

private function recalculateDiscount():void
{
	var _vendor_fixed_cost:Number	=	Number(tiVendor_fixed_cost.dataValue);
	var _subtotal_cost:Number		=	Number(tiSubTotal_cost.dataValue);
	var _surcharge_amt:Number		=	Number(tiSurcharge_amt.dataValue);
	var _duty_amt:Number			=	Number(tiDuty_amt.dataValue);
	var _fixed_total_cost:Number	=	0;
	var _total_cost:Number			=	Number(tiTotal_cost.dataValue);;
	
	_fixed_total_cost 		 = Number(numericFormatter2.format(_subtotal_cost + _vendor_fixed_cost + _surcharge_amt + _duty_amt));
	tiDiscount_amt.dataValue = Number(numericFormatter2.format(_fixed_total_cost - _total_cost)).toString();
	tiDiscount_per.dataValue = Number(numericFormatter2.format(( Number(tiDiscount_amt.dataValue)*100)/_fixed_total_cost)).toString();
}
// End