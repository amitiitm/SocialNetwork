import com.generic.events.GenComboBoxEvent;
import com.generic.events.GenTextInputEvent;
import com.generic.genclass.GenNumberFormatter;
import com.generic.events.DetailAddEditEvent;
import invn.jewelry.JewelryModelLocator;
import model.GenModelLocator;
import mx.controls.Alert;

private var numericFormatter2:GenNumberFormatter = new GenNumberFormatter();
private var numericFormatter3:GenNumberFormatter = new GenNumberFormatter();
private var numericFormatter4:GenNumberFormatter = new GenNumberFormatter();
private var numericFormatter6:GenNumberFormatter = new GenNumberFormatter();

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
protected var __localModel:JewelryModelLocator = (JewelryModelLocator)(GenModelLocator.getInstance().activeModelLocator);

private function init():void
{
	numericFormatter2.precision = 2;
	numericFormatter2.rounding = "nearest";
	numericFormatter2.useThousandsSeparator = false;

	numericFormatter3.precision = 3;
	numericFormatter3.rounding = "nearest";
	numericFormatter3.useThousandsSeparator = false;

	numericFormatter4.precision = 4;
	numericFormatter4.rounding = "nearest";
	numericFormatter4.useThousandsSeparator = false;

	numericFormatter6.precision = 6;
	numericFormatter6.rounding = "nearest";
	numericFormatter6.useThousandsSeparator = false;

}

private function handleLaborWtItemChanged(event:GenTextInputEvent):void
{
	calculateGoldPrice();
}

private function handleSupplierItemChanged(event:GenComboBoxEvent):void
{
	var _billed_wt_flag:String;
	var _wt:Number = 0;
	var _qty:Number = 0;
	var _total_wt:Number = 0;
	
	if(cbSupplier.dataValue == 'V')
	{
		_billed_wt_flag	= 'F';
		_wt = Number(tiFinished_wt.dataValue);
	}
	else
	{
		_billed_wt_flag	= 'C';
		_wt = Number(tiWt.dataValue);
	}
	
	cbBilled_wt_flag.dataValue = _billed_wt_flag;
		
	_qty 		= 	Number(tiQty.dataValue);
	_total_wt 	=	_wt * _qty;

	tiTotal_weight.dataValue = numericFormatter4.format(_total_wt.toString());
	
	calculateGoldPrice();
}

private function handleQtyItemChanged(event:GenTextInputEvent):void
{
	var _qty:Number				=	Number(tiQty.dataValue);
	var _billed_wt_flag:String	=	cbBilled_wt_flag.dataValue;
	var _total_wt:Number		=	0;
	var _cost:Number			=	Number(tiCost.dataValue);
	var _markup_per:Number		=	Number(tiMarkup_per.dataValue);
	var _gold_surcharge:Number	=	Number(tiGold_surcharge.dataValue);
	var _total_cost:Number		=	0;
	var _price:Number			=	0;
	var _wt:Number				=	0;
	var _labor:Number			=	Number(tiLabor.dataValue);
	var _casting_cost:Number	=	0;
		
	if(_billed_wt_flag == 'C')
	{
		_wt	= Number(tiWt.dataValue); 
	}
	else
	{
		_wt	= Number(tiFinished_wt.dataValue);
	}
	
	_total_wt	=	_qty * _wt;

	if(isNaN(_markup_per))
	{
		_markup_per	= 0;
	}

	_cost		=	_cost +	(_cost * _markup_per) / 100;
			
	if(isNaN(_gold_surcharge))
	{
		_gold_surcharge = 0;
	}
	
	_cost			=	_cost + _gold_surcharge;
	_total_cost		=	_total_wt * _cost + (_labor * _qty);
	_price			=	_total_cost;
	_casting_cost	=	_total_cost - _labor;

	tiTotal_weight.dataValue	=	numericFormatter4.format(_total_wt.toString());
	tiCasting_cost.dataValue	=	numericFormatter2.format(_casting_cost.toString());
	tiTotal_cost.dataValue		=	numericFormatter2.format(_total_cost.toString());
	tiPrice.dataValue			=	numericFormatter2.format(_price.toString());
}

private function handleMetalTypeItemChanged(event:GenComboBoxEvent):void
{
	var _metal_type_old:String	=	cbMetal_type.oldValue;
	var _metal_type_new:String	=	cbMetal_type.dataValue;
	
	calculateMetalType(_metal_type_old, _metal_type_new);
	calculateGoldPrice();
}

private function handleMetalColorItemChanged(event:GenComboBoxEvent):void
{
	calculateGoldPrice();
}

private function handleWtItemChanged(event:GenTextInputEvent):void
{
	var _wt:Number				=	0;
	var _qty:Number				=	Number(tiQty.dataValue);
	var _billed_wt_flag:String	=	cbBilled_wt_flag.dataValue;
	var _total_wt:Number		=	0;	
	var _cost:Number			=	Number(tiCost.dataValue);
	var _markup_per:Number		=	Number(tiMarkup_per.dataValue);	
	var _gold_surcharge:Number	=	Number(tiGold_surcharge.dataValue);
	var _labor:Number			=	Number(tiLabor.dataValue);
	var _total_cost:Number		=	0;
	var _casting_cost:Number	=	0;
		
	if(_billed_wt_flag == 'C')
	{
		_wt	=	Number(tiWt.dataValue);
	}
	else
	{
		_wt	= 	Number(tiFinished_wt.dataValue);
	}

	_total_wt	=	_qty * _wt;
	
	if(isNaN(_markup_per))
	{
		_markup_per = 0;
	}

	_cost = _cost + (_cost * _markup_per) / 100;
	
	if(isNaN(_gold_surcharge))
	{
		_gold_surcharge = 0;
	}	

	_cost 		= 	_cost + _gold_surcharge;
	_total_wt	=	_wt * _qty;
	
	tiTotal_weight.dataValue = numericFormatter4.format(_total_wt.toString());

	_total_cost		= (_cost * _total_wt) + (_labor * _qty);
	_casting_cost	= _total_cost - _labor;

	tiCasting_cost.dataValue	=	numericFormatter2.format(_casting_cost.toString());
	tiTotal_cost.dataValue 		= 	numericFormatter2.format(_total_cost.toString());
	
	calculateGoldPrice();
}

private function handleFinishedWtItemChanged(event:GenTextInputEvent):void
{
	var _wt:Number				=	Number(tiFinished_wt.dataValue);
	var _qty:Number				=	Number(tiQty.dataValue);
	var _billed_wt_flag:String	=	cbBilled_wt_flag.dataValue;
	var _total_wt:Number		=	0;
	
	if(_billed_wt_flag == 'F')
	{
		_total_wt = _wt * _qty;
		tiTotal_weight.dataValue = numericFormatter4.format(_total_wt.toString());
	}

	_total_wt = Number(tiTotal_weight.dataValue);

	if(_total_wt == 0)
	{
		_total_wt	= _wt * _qty;
		tiTotal_weight.dataValue = numericFormatter4.format(_total_wt.toString());		
	}	

	calculateGoldPrice();
}

private function handleUnitItemChanged(event:GenComboBoxEvent):void
{
	calculateGoldPrice();
	calculateUnit();
}

private function handleLaborItemChanged(event:GenTextInputEvent):void
{
	var _labor:Number			=	Number(tiLabor.dataValue);
	var _cost:Number			=	Number(tiCost.dataValue);
	var _markup_per:Number		=	Number(tiMarkup_per.dataValue);
	var _gold_surcharge:Number	=	Number(tiGold_surcharge.dataValue);
	var _qty:Number				=	Number(tiQty.dataValue);	
	var _total_wt:Number		=	Number(tiTotal_weight.dataValue);
	var _total_cost:Number		=	0;
	var _casting_cost:Number	=	0;
		
	if(isNaN(_markup_per))
	{
		_markup_per = 0
	}

	_cost	=	_cost + (_cost * _markup_per) / 100;
	
	if(isNaN(_gold_surcharge))
	{
		_gold_surcharge = 0;
	}	

	_cost			=	_cost + _gold_surcharge;
	_total_cost		=	(_cost * _total_wt) + (_labor * _qty);
	_casting_cost	=	_total_cost - _labor;

	tiCasting_cost.dataValue	= numericFormatter2.format(_casting_cost.toString());
	tiTotal_cost.dataValue		= numericFormatter2.format(_total_cost.toString());
}

private function handleBilledWtFlagItemChanged(event:GenComboBoxEvent):void
{
	var _billed_wt_flag:String	=	cbBilled_wt_flag.dataValue;
	var _wt:Number				=	0;
	var _qty:Number				=	Number(tiQty.dataValue);
	var _total_wt:Number		=	Number(tiTotal_weight.dataValue);
	
	if(_billed_wt_flag == 'C')
	{
		_wt	= Number(tiWt.dataValue);
	}
	else
	{
		_wt = Number(tiFinished_wt.dataValue);	
	}

	_total_wt =	_wt * _qty;
	tiTotal_weight.dataValue = numericFormatter4.format(_total_wt.toString());

	calculateGoldPrice()
}

private function handleCostItemChanged(event:GenTextInputEvent):void
{
	var _cost:Number			=	Number(tiCost.dataValue);
	var _gold_surcharge:Number	=	Number(tiGold_surcharge.dataValue);
	var _markup_per:Number		=	Number(tiMarkup_per.dataValue);
	var _qty:Number				=	Number(tiQty.dataValue);
	var _labor:Number			=	Number(tiLabor.dataValue);
	var _total_wt:Number		=	Number(tiTotal_weight.dataValue);
	var _total_cost:Number		=	0;
	var _casting_cost:Number	=	0;
	
	if(isNaN(_gold_surcharge))
	{
		_gold_surcharge	= 0;
	}

	if(isNaN(_markup_per))
	{
		_markup_per	=	0;
	}

	_cost	=	_cost + (_cost * _markup_per) / 100;
	_cost	=	_cost + _gold_surcharge;
	
	_total_cost		=	(_cost * _total_wt) + (_labor * _qty);
	_casting_cost	=	_total_cost - _labor;

	tiCasting_cost.dataValue	=	numericFormatter2.format(_casting_cost.toString());
	tiTotal_cost.dataValue		=	numericFormatter2.format(_total_cost.toString());
}

private function handleGoldSurchangeItemChanged(event:GenTextInputEvent):void
{
	var _gold_surchange:Number	=	Number(tiGold_surcharge.dataValue);
	var _cost:Number			=	Number(tiCost.dataValue);
	var _markup_per:Number		= 	Number(tiMarkup_per.dataValue);
	var _qty:Number				=	Number(tiQty.dataValue);
	var _labor:Number			=	Number(tiLabor.dataValue);
	var _total_cost:Number		=	0;
	var _total_wt:Number		=	Number(tiTotal_weight.dataValue);
	var _casting_cost:Number	=	0;	

	if(isNaN(_markup_per))
	{
		_markup_per	= 0;
	}	
		
	_cost	=	Number(numericFormatter2.format(_cost + (_cost * _markup_per) / 100));

	if(isNaN(_gold_surchange))
	{
		_gold_surchange = 0;		
	}	

	_cost			= 	_cost + _gold_surchange;
	_total_cost		=	(_cost * _total_wt) + (_labor * _qty);
	_casting_cost	=	_total_cost - _labor;
			
	tiCasting_cost.dataValue	=	numericFormatter2.format(_casting_cost.toString());
	tiTotal_cost.dataValue		=	numericFormatter2.format(_total_cost.toString());
}

private function calculateGoldPrice():void // PB wf_cal_goldprice
{
	var _wt:Number					=	Number(tiWt.dataValue);
	var _total_wt:Number			=	Number(tiTotal_weight.dataValue);
	var _labor:Number				=	Number(tiLabor.dataValue);
	var _qty:Number					=	Number(tiQty.dataValue);
	var _cost:Number				=	Number(tiCost.dataValue);
	var _markup_per:Number			=	Number(tiMarkup_per.dataValue);
	var _labor_wt:Number			=	Number(tiLabor_wt.dataValue);
	var _gold_surcharge:Number		=	Number(tiGold_surcharge.dataValue);	
	var _factor:Number				=	0;
	var _kt_factor:Number			=	0; 	
	var _metal_type:String			=	cbMetal_type.dataValue;
	var _unit:String				=	cbUnit.dataValue;
	var _supplier:String			=	cbSupplier.dataValue;
	var _metal_total_rate:Number	=	0;
	var _metal_mu:Number			=	0;
	var _wt_cost:Number				=	0;
	var _total_cost:Number			=	0;
	var _price:Number				=	0;
	var _casting_cost:Number		=	0;
	
	var _vendor_fixed_cost:Number	= __localModel.vendor_fixed_cost;
	
	if(_labor_wt > 0)
	{
		_labor = Number(numericFormatter2.format(_labor_wt * _total_wt));
		tiLabor.dataValue = _labor.toString();
	}

	_factor		=	Number(numericFormatter6.format(styleUnitConversion("GOLD", "WT", "OZ", _unit.toLocaleUpperCase())));
	_kt_factor 	= 	Number(numericFormatter6.format(styleUnitConversion("GOLD", "KT", "24KT", _metal_type)));

	if(_metal_type == "PLAT")
	{
		_metal_total_rate	= 	__localModel.platinum_total_rate;
		_metal_mu			=	__localModel.platinum_mu;	 
	}
	else if(_metal_type == "STER")
	{
		_metal_total_rate	= 	__localModel.silver_total_rate;
		_metal_mu			=	__localModel.silver_mu;	 
	}	
	else if(_metal_type == "PALD")
	{
		_metal_total_rate	= 	__localModel.palladium_total_rate;
		_metal_mu			=	__localModel.palladium_mu;	 
	}
	else
	{
		_metal_total_rate	= 	__localModel.gold_total_rate;
		_metal_mu			=	__localModel.gold_mu;	 
	}	
	
	if(isNaN(_metal_mu))
	{
		_metal_mu = 0;
	}
	
	if(_metal_mu > 0)
	{
		_metal_total_rate = Number(numericFormatter2.format(_metal_total_rate + (_metal_total_rate * _metal_mu / 100)));
	}
		
	if(_factor != 0)
	{
		_wt_cost = Number(numericFormatter2.format((_metal_total_rate / _factor) * _kt_factor));		
	}
	else
	{
		_wt_cost = Number(numericFormatter2.format(_metal_total_rate));		
	}
	
	_cost 		= 	_wt_cost;
	//VD 08 Nov 2011
	tiCost.dataValue = numericFormatter2.format(_cost.toString());
	
	_total_cost 	= Number(numericFormatter2.format(((_wt_cost + _gold_surcharge) * _total_wt) + (_labor)));
	_casting_cost 	= Number(numericFormatter2.format(_total_cost - _labor));

	tiTotal_cost.dataValue 		= _total_cost.toString();
	tiCasting_cost.dataValue 	= _casting_cost.toString();
	
	if(_vendor_fixed_cost > 0 && _supplier == 'V')
	{
		_cost = 0;
		_total_cost = 0;
		_labor = 0;
		
		tiCost.dataValue		= _cost.toString();
		tiTotal_cost.dataValue 	= _total_cost.toString();
		tiLabor.dataValue 		= _labor.toString();
	}

	_price = _total_cost * ((100 + _markup_per) / 100);
	tiPrice.dataValue = numericFormatter2.format(_price.toString());
}	

private function calculateUnit():void
{
	var _wt:Number				=	Number(tiWt.dataValue);
	var	_finished_wt:Number		=	Number(tiFinished_wt.dataValue);
	var _total_wt:Number		=	Number(tiTotal_weight.dataValue);
	var _unit:String			=	cbUnit.dataValue;
	var _cost:Number			=	Number(tiCost.dataValue);
	var _labor:Number			=	Number(tiLabor.dataValue);
	var _total_cost:Number		=	0;
	var _casting_cost:Number	=	0;
		
	if(_unit == 'GM')
	{
		_wt				=	Number(numericFormatter4.format(_wt * 1.555));
		_finished_wt	=	Number(numericFormatter4.format(_finished_wt * 1.555));
		_total_wt		=	Number(numericFormatter4.format(_total_wt * 1.555));	
	}
	else if(_unit == 'DWT')
	{
		_wt 			=	Number(numericFormatter4.format(_wt / 1.555));
		_finished_wt	=	Number(numericFormatter4.format(_finished_wt / 1.555));
		_total_wt		=	Number(numericFormatter4.format(_total_wt / 1.555));
	}
	
	
	tiWt.dataValue				=	_wt.toString();
	tiFinished_wt.dataValue		=	_finished_wt.toString();
	tiTotal_weight.dataValue	=	_total_wt.toString();

	_total_cost		=	_total_wt * _cost;
	_casting_cost	=	_total_cost - _labor;

	tiCasting_cost.dataValue	=	numericFormatter2.format(_casting_cost.toString());
	tiTotal_cost.dataValue		=	numericFormatter2.format(_total_cost.toString());
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

private function calculateMetalType(oldType:String, newType:String):void
{
	var _wt:Number				=	Number(numericFormatter2.format(tiWt.dataValue));
	var _finish_wt:Number		=	Number(numericFormatter2.format(tiFinished_wt.dataValue));
	var _total_wt:Number		=	Number(numericFormatter2.format(tiTotal_weight.dataValue));
	var _labor:Number			=	Number(numericFormatter2.format(tiLabor.dataValue));
	var _cost:Number			=	Number(numericFormatter2.format(tiCost.dataValue));		
	var _total_cost:Number		=	0;		
	var _casting_cost:Number	=	0;
	var _flag:Boolean			=	false;
	var _factor:Number			=	0;				
	
	if(oldType == '14KT')
	{
		if(newType == '10KT')
		{
			_wt			= 	Number(numericFormatter2.format(_wt * 0.89));
			_finish_wt	=	Number(numericFormatter2.format(_finish_wt * 0.89));
			_total_wt	=	Number(numericFormatter2.format(_total_wt * 0.89));
			
			_flag		=	true;
		}
		else if(newType == '18KT')
		{
			_wt 		= 	Number(numericFormatter2.format(_wt / 0.85));
			_finish_wt	= 	Number(numericFormatter2.format(_finish_wt / 0.85));
			_total_wt 	=	Number(numericFormatter2.format(_total_wt / 0.85));

			_flag		=	true;
		}
	}
	else if(oldType == '10KT' || oldType == '9KT')
	{
		if(newType == '14KT')
		{
			_wt			= 	Number(numericFormatter2.format(_wt / 0.89));
			_finish_wt	=	Number(numericFormatter2.format(_finish_wt / 0.89));
			_total_wt	=	Number(numericFormatter2.format(_total_wt / 0.89));

			_flag		=	true;
		}
		else if(newType == '18KT')
		{
			_wt 		= 	Number(numericFormatter2.format(_wt / 0.76));
			_finish_wt	= 	Number(numericFormatter2.format(_finish_wt / 0.76));
			_total_wt 	=	Number(numericFormatter2.format(_total_wt / 0.76));

			_flag		=	true;
		}
	}
	else if(oldType == '18KT')
	{
		if(newType == '10KT')
		{
			_wt			= 	Number(numericFormatter2.format(_wt * 0.76));
			_finish_wt	=	Number(numericFormatter2.format(_finish_wt * 0.76));
			_total_wt	=	Number(numericFormatter2.format(_total_wt * 0.76));

			_flag		=	true;
		}
		else if(newType == '14KT')
		{
			_wt 		= 	Number(numericFormatter2.format(_wt * 0.85));
			_finish_wt	= 	Number(numericFormatter2.format(_finish_wt * 0.85));
			_total_wt 	=	Number(numericFormatter2.format(_total_wt * 0.85));

			_flag		=	true;
		}
	}

	// PB search : vk 101106)
	if(_flag == false)
	{
		_factor		=	Number(numericFormatter4.format(styleUnitConversion('GOLD', 'KTWT', oldType, newType)));

		if(_factor != 0)
		{
			_wt 		= 	Number(numericFormatter2.format(_wt * _factor));
			_finish_wt	= 	Number(numericFormatter2.format(_finish_wt * _factor));
			_total_wt 	=	Number(numericFormatter2.format(_total_wt * _factor));
		}
	}
	// End
	
	tiWt.dataValue				=	_wt.toString();
	tiFinished_wt.dataValue		=	_finish_wt.toString();
	tiTotal_weight.dataValue	=	_total_wt.toString();

	_total_cost					=	Number(numericFormatter2.format(_total_wt * _cost));
	_casting_cost				=	Number(numericFormatter2.format(_total_cost - _labor));

	tiCasting_cost.dataValue	= 	_casting_cost.toString();
	tiTotal_cost.dataValue		= 	_total_cost.toString();	
}
