import com.generic.events.DetailEvent;
import com.generic.events.GenTextInputEvent;

private function handleCastingUpdateComplete(event:DetailEvent):void
{
	updateCastings();
	updateAllTotal();
}

private function handleCastingMarkupItemChanged(event:GenTextInputEvent):void
{
	var _markup_per:Number		=	Number(tiCasting_mu.dataValue);
	var _casting_cost:Number	=	Number(tiCasting_cost.dataValue);
	var _amount:Number			=	0;	
	
	if(__localModel.margin_calculation_flag == 'N')
	{
		_amount	=	Number(numericFormatter2.format(_casting_cost * (100 + _markup_per) / 100));
	}	
	else
	{
		_amount	=	Number(numericFormatter2.format((100 * _casting_cost) / (100 - _markup_per)));
	}

	tiCasting_amt.dataValue	= numericFormatter2.format(_amount.toString());
	updateAllTotal();
}

private function handleCastingAmtItemChanged(event:GenTextInputEvent):void
{
	var _casting_amt:Number		=	Number(tiCasting_amt.dataValue);
	var _casting_cost:Number	=	Number(tiCasting_cost.dataValue);
	var _markup_per:Number		=	0;
			
	if(isNaN(_casting_cost))
	{
		_casting_cost = 0;		
	}

	if(_casting_cost > 0)
	{
		if(__localModel.margin_calculation_flag == 'N')
		{
			_markup_per	=	Number(numericFormatter2.format(100 * (_casting_amt - _casting_cost) / _casting_cost));	
		}
		else
		{
			_markup_per	=	Number(numericFormatter2.format(100 * (_casting_amt - _casting_cost) / _casting_amt));
		}		
	}

	tiCasting_mu.dataValue	=	numericFormatter2.format(_markup_per.toString());
	updateAllTotal();
}

private function handleCastingMarkupRetail(event:GenTextInputEvent):void
{
	var _markup:Number				=	Number(tiCasting_mu_retail.dataValue);
	var _wholesale_amount:Number	=	Number(tiCasting_amt.dataValue);
	var _retail_amount:Number		=	0;
	
	if(isNaN(_wholesale_amount))
	{
		if(__localModel.margin_calculation_flag == 'N')
		{
			_retail_amount	=	Number(numericFormatter2.format(_wholesale_amount * (100 + _markup) / 100));		
		}
		else
		{
			_retail_amount	=	Number(numericFormatter2.format((100 * _wholesale_amount) / (100 - _markup)));
		}		
	}	
	
	tiCasting_amt_retail.dataValue	=	numericFormatter2.format(_retail_amount.toString());
	updateAllTotal();
}

private function handleCastingAmtRetailItemChanged(event:GenTextInputEvent):void
{
	var _retail_amount:Number		=	Number(tiCasting_amt_retail.dataValue);
	var _wholesale_amount:Number	=	Number(tiCasting_amt.dataValue);
	var _markup_per:Number			=	0;

	if(_wholesale_amount > 0)
	{
		if(__localModel.margin_calculation_flag == 'N')
		{
			_markup_per	=	Number(numericFormatter2.format(100 * (_retail_amount - _wholesale_amount) / _wholesale_amount));
		}
		else
		{
			_markup_per	=	Number(numericFormatter2.format(100 * (_retail_amount - _wholesale_amount) / _retail_amount));
		}
	}	

	tiCasting_amt_retail.dataValue	=	numericFormatter2.format(_markup_per.toString());
	updateAllTotal();	
}

private function getCastingDutyCost():Number
{
	var _cast_value:Number 	= 0;
	var gridlength:int 		= dtlCasting.dgDtl.dataProvider.length;
	var column_name:String 	= 'total_cost';

	for(var i:int = 0; i < gridlength; i++)
	{
		if(dtlCasting.dgDtl.dataProvider[i].duty_flag == 'Y')	
		{
			_cast_value = _cast_value + (Number)(dtlCasting.dgDtl.dataProvider[i][column_name]);
		}
	}
	
	return _cast_value;
}

private function setCastingType():void 
{
	if(dtlCasting.dgDtl.dataProvider.length > 0)
	{
		tiCasting_type.dataValue 	= dtlCasting.dgDtl.dataProvider[0].metal_type;
		tiCasting_color.dataValue 	= dtlCasting.dgDtl.dataProvider[0].metal_color;
		tiCasting_unit.dataValue 	= dtlCasting.dgDtl.dataProvider[0].unit;
	}
}

private function setCastingWholesaleAndRetailPrice():void
{
	setCastingWholesalePrice();
	setCastingRetailPrice();
}

private function setCastingWholesalePrice(): void
{ 
	var _casting_cost:Number = Number(tiCasting_cost.dataValue);
	var _casting_mu:Number   = Number(tiCasting_mu.dataValue);
	var _casting_amount:Number = 0;
	
	if(_casting_mu >= 100 && __localModel.margin_calculation_flag == 'Y')
	{
		_casting_mu = 99;
	}

	if(__localModel.margin_calculation_flag == 'N')
	{
		_casting_amount = _casting_cost + Number(numericFormatter2.format(_casting_cost * _casting_mu / 100));
	}
	else
	{
		_casting_amount = Number(numericFormatter2.format((100 * _casting_cost)/(100 - _casting_mu)));
	}
		
	tiCasting_amt.dataValue = numericFormatter2.format(_casting_amount.toString());
}

private function setCastingRetailPrice():void
{
	var _casting_mu_retail:Number 	= Number(tiCasting_mu_retail.dataValue);
	var _casting_amt:Number 		= Number(tiCasting_amt.dataValue);
	var _casting_amt_retail:Number;

	if(_casting_mu_retail >= 100 && __localModel.margin_calculation_flag == 'Y')
	{
		_casting_mu_retail = 99
	} 

	if(__localModel.margin_calculation_flag == 'N')
	{
		_casting_amt_retail = _casting_amt + Number(numericFormatter2.format(_casting_amt * _casting_mu_retail / 100));
	}
	else
	{
		_casting_amt_retail = Number(numericFormatter2.format((100 * _casting_amt) / (100 - _casting_mu_retail)));
	}
	
	tiCasting_amt_retail.dataValue = numericFormatter2.format(_casting_amt_retail.toString());
}

private function getCastingSetterValue():Number
{
	var _cast_value:Number 	= 0;
	var gridlength:int		= dtlCasting.dgDtl.dataProvider.length;
	var _setter:String;

	for(var i:int = 0; i < gridlength; i++)
	{
		if(dtlCasting.dgDtl.dataProvider[i].setter == 'V')	
		{
			_cast_value = _cast_value + (Number)(dtlCasting.dgDtl.dataProvider[i]['total_cost']);
		}
	}
	
	return _cast_value;
}

private function getCastingVendorValue():Number
{
	var _value:Number = 0;
	var _supplier:String;
	var _gridLength:Number = dtlCasting.dgDtl.dataProvider.length;
	
	for(var i:int = 0; i < _gridLength; i++)
	{
		_supplier = dtlCasting.dgDtl.dataProvider[i]['supplier'];
		
		if(_supplier == 'V')
		{
			_value	= _value + Number(dtlCasting.dgDtl.dataProvider[i]['total_cost']);
		}		
	}
	
	return Number(numericFormatter2.format(_value));
}

private function calculateGoldPrice_casting():void // PB wf_cal_goldprice  
{
	var _wt:Number;
	var _total_wt:Number;
	var _labor:Number;
	var _qty:Number;
	var _cost:Number;
	var _markup:Number;
	var _labor_wt:Number;
	var _gold_surcharge:Number;
	var _factor:Number;
	var _kt_factor:Number; 	
	var _metal_type:String;
	var _unit:String;
	var _supplier:String;
	var _metal_total_rate:Number;
	var _metal_mu:Number;
	var _wt_cost:Number;
	var _total_cost:Number;
	var _price:Number;
	
	var _vendor_fixed_cost:Number	= Number(tiVendor_fixed_cost.dataValue);
	var _gridLength:int = dtlCasting.dgDtl.dataProvider.length;
	
	for(var i:int=0; i < _gridLength; i++)
	{
		_wt				=	Number(dtlCasting.dgDtl.dataProvider[i].wt);
		_total_wt		= 	Number(dtlCasting.dgDtl.dataProvider[i].total_wt);
		_labor			= 	Number(dtlCasting.dgDtl.dataProvider[i].labor);
		_qty			= 	Number(dtlCasting.dgDtl.dataProvider[i].qty);
		_cost			= 	Number(dtlCasting.dgDtl.dataProvider[i].cost);
		_markup			=	Number(dtlCasting.dgDtl.dataProvider[i].markup_per);
		_labor_wt		= 	Number(dtlCasting.dgDtl.dataProvider[i].labor_wt);
		_gold_surcharge = 	Number(dtlCasting.dgDtl.dataProvider[i].gold_surcharge);
		
		_metal_type		=	dtlCasting.dgDtl.dataProvider[i].metal_type;
		_unit			=	dtlCasting.dgDtl.dataProvider[i].unit;
		_supplier 		= 	dtlCasting.dgDtl.dataProvider[i].supplier;

		if(_labor_wt > 0)
		{
			_labor = Number(numericFormatter2.format(_labor_wt * _total_wt));
			dtlCasting.dgDtl.dataProvider[i].labor	= _labor.toString();
		}

		_factor		= Number(numericFormatter6.format(styleUnitConversion("GOLD", "WT", "OZ", _unit.toLocaleUpperCase())));
		_kt_factor 	= Number(numericFormatter6.format(styleUnitConversion("GOLD", "KT", "24KT", _metal_type)));
		
		if(_metal_type == "PLAT")
		{
			_metal_total_rate	= 	Number(tiPlatinum_total_rate.dataValue);
			_metal_mu			=	Number(tiPlatinum_mu.dataValue);	 
		}
		else if(_metal_type == "STER")
		{
			_metal_total_rate	= 	Number(tiSilver_total_rate.dataValue);
			_metal_mu			=	Number(tiSilver_mu.dataValue);	 
		}	
		else if(_metal_type == "PALD")
		{
			_metal_total_rate	= 	Number(tiPalladium_total_rate.dataValue);
			_metal_mu			=	Number(tiPalladium_mu.dataValue);	 
		}
		else
		{
			_metal_total_rate	= 	Number(tiGold_total_rate.dataValue);
			_metal_mu			=	Number(tiGold_mu.dataValue);	 
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
	
		_cost = _wt_cost;
		dtlCasting.dgDtl.dataProvider[i].cost = numericFormatter2.format(_cost.toString());
		
		_total_cost = Number(numericFormatter2.format(((_wt_cost + _gold_surcharge) * _total_wt) + (_labor)));
		dtlCasting.dgDtl.dataProvider[i].total_cost = _total_cost.toString();
	
		if(_vendor_fixed_cost > 0 && _supplier == 'V')
		{
			_cost = 0;
			_total_cost = 0;
			_labor = 0;
			
			dtlCasting.dgDtl.dataProvider[i].cost 		= _cost.toString();
			dtlCasting.dgDtl.dataProvider[i].total_cost = _total_cost.toString();
			dtlCasting.dgDtl.dataProvider[i].labor 		= _labor.toString();
		}
	
		_price = _total_cost * ((100 + _markup) / 100);
		dtlCasting.dgDtl.dataProvider[i].price	= numericFormatter2.format(_price.toString());
	}
}	

private function updateCastings():void  // PB's updateHdrMetal (casting part)
{
	var _vendor_fixed_cost:Number = Number(tiVendor_fixed_cost.dataValue);
	var _supplier:String;
	var _casting_total_wt:Number 	= 0;
	var _casting_total_cost:Number 	= 0;
	
	setCastingType();

	for(var i:int=0; i < dtlCasting.dgDtl.dataProvider.length; i++)
	{
		_casting_total_wt 	= _casting_total_wt + Number(dtlCasting.dgDtl.dataProvider[i].total_wt);
		_supplier 			= dtlCasting.dgDtl.dataProvider[i].supplier;
		
		if(_vendor_fixed_cost > 0 && _supplier == 'V')
		{
			// Do noting it is fixed cost item.	
		}
		else
		{
			_casting_total_cost = _casting_total_cost + Number(dtlCasting.dgDtl.dataProvider[i].total_cost);
		}
	}
	
	tiCasting_cost.dataValue 	= 	numericFormatter2.format(_casting_total_cost.toString());
	tiCasting_wt.dataValue 		=	numericFormatter2.format(_casting_total_wt.toString());
}
