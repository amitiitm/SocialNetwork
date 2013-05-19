import com.generic.events.DetailEvent;
import com.generic.events.GenTextInputEvent;

private function handleFindingUpdateComplete(event:DetailEvent):void
{
	updateFindings();
	updateAllTotal();
}

private function handleFindingMarkupItemChanged(event:GenTextInputEvent):void
{
	var _markup_per:Number		=	Number(tiFinding_mu.dataValue);
	var _finding_cost:Number	=	Number(tiFinding_cost.dataValue);
	var _amount:Number			=	0;	
	
	if(__localModel.margin_calculation_flag == 'N')
	{
		_amount	=	Number(numericFormatter2.format(_finding_cost * (100 + _markup_per) / 100));
	}	
	else
	{
		_amount	=	Number(numericFormatter2.format((100 * _finding_cost) / (100 - _markup_per)));
	}

	tiFinding_amt.dataValue	= numericFormatter2.format(_amount.toString());
	updateAllTotal();
}

private function handleFindingAmtItemChanged(event:GenTextInputEvent):void
{
	var _finding_amt:Number		=	Number(tiFinding_amt.dataValue);
	var _finding_cost:Number	=	Number(tiFinding_cost.dataValue);
	var _markup_per:Number		=	0;
			
	if(isNaN(_finding_cost))
	{
		_finding_cost = 0;		
	}

	if(_finding_cost > 0)
	{
		if(__localModel.margin_calculation_flag == 'N')
		{
			_markup_per	=	Number(numericFormatter2.format(100 * (_finding_amt - _finding_cost) / _finding_cost));	
		}
		else
		{
			_markup_per	=	Number(numericFormatter2.format(100 * (_finding_amt - _finding_cost) / _finding_amt));
		}		
	}

	tiFinding_mu.dataValue	=	numericFormatter2.format(_markup_per.toString());
	updateAllTotal();
}

private function handleFindingMarkupRetail(event:GenTextInputEvent):void
{
	var _markup:Number				=	Number(tiFinding_mu_retail.dataValue);
	var _wholesale_amount:Number	=	Number(tiFinding_amt.dataValue);
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
	
	tiFinding_amt_retail.dataValue	=	numericFormatter2.format(_retail_amount.toString());
	updateAllTotal();
}

private function handleFindingAmtRetailItemChanged(event:GenTextInputEvent):void
{
	var _retail_amount:Number		=	Number(tiFinding_amt_retail.dataValue);
	var _wholesale_amount:Number	=	Number(tiFinding_amt.dataValue);
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

	tiFinding_amt_retail.dataValue	=	numericFormatter2.format(_markup_per.toString());
	updateAllTotal();	
}

private function getFindingDutyCost():Number
{
	var _finding_value:Number 	= 0;
	var gridlength:int 		= dtlFinding.dgDtl.dataProvider.length;
	var column_name:String 	= 'total_cost';

	for(var i:int = 0; i < gridlength; i++)
	{
		if(dtlFinding.dgDtl.dataProvider[i].duty_flag == 'Y')	
		{
			_finding_value = _finding_value + (Number)(dtlFinding.dgDtl.dataProvider[i][column_name]);
		}
	}
	
	return _finding_value;
}

private function setFindingType():void 
{
	if(dtlFinding.dgDtl.dataProvider.length > 0)
	{
		tiFinding_type.dataValue 	= dtlFinding.dgDtl.dataProvider[0].metal_type;
		tiFinding_color.dataValue 	= dtlFinding.dgDtl.dataProvider[0].metal_color;
		tiFinding_unit.dataValue 	= dtlFinding.dgDtl.dataProvider[0].unit;
	}
}

private function setFindingWholesaleAndRetailPrice():void
{
	setFindingWholesalePrice();
	setFindingRetailPrice();
}

private function setFindingWholesalePrice(): void
{ 
	var _finding_cost:Number = Number(tiFinding_cost.dataValue);
	var _finding_mu:Number   = Number(tiFinding_mu.dataValue);
	var _finding_amount:Number = 0;
	
	if(_finding_mu >= 100 && __localModel.margin_calculation_flag == 'Y')
	{
		_finding_mu = 99;
	}

	if(__localModel.margin_calculation_flag == 'N')
	{
		_finding_amount = _finding_cost + Number(numericFormatter2.format(_finding_cost * _finding_mu / 100));
	}
	else
	{
		_finding_amount = Number(numericFormatter2.format((100 * _finding_cost)/(100 - _finding_mu)));
	}
		
	tiFinding_amt.dataValue = numericFormatter2.format(_finding_amount.toString());
}

private function setFindingRetailPrice():void
{
	var _finding_mu_retail:Number 	= Number(tiFinding_mu_retail.dataValue);
	var _finding_amt:Number 		= Number(tiFinding_amt.dataValue);
	var _finding_amt_retail:Number;

	if(_finding_mu_retail >= 100 && __localModel.margin_calculation_flag == 'Y')
	{
		_finding_mu_retail = 99
	} 

	if(__localModel.margin_calculation_flag == 'N')
	{
		_finding_amt_retail = _finding_amt + Number(numericFormatter2.format(_finding_amt * _finding_mu_retail / 100));
	}
	else
	{
		_finding_amt_retail = Number(numericFormatter2.format((100 * _finding_amt) / (100 - _finding_mu_retail)));
	}
	
	tiFinding_amt_retail.dataValue = numericFormatter2.format(_finding_amt_retail.toString());
}

private function getFindingSetterValue():Number
{
	var _finding_value:Number 	= 0;
	var gridlength:int		= dtlFinding.dgDtl.dataProvider.length;
	var _setter:String;

	for(var i:int = 0; i < gridlength; i++)
	{
		if(dtlFinding.dgDtl.dataProvider[i].setter == 'V')	
		{
			_finding_value = _finding_value + (Number)(dtlFinding.dgDtl.dataProvider[i]['total_cost']);
		}
	}
	
	return _finding_value;
}

private function calculateGoldPrice_finding():void // PB wf_cal_goldprice  
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
	var _gridLength:int = dtlFinding.dgDtl.dataProvider.length;
	
	for(var i:int=0; i < _gridLength; i++)
	{
		_wt				=	Number(dtlFinding.dgDtl.dataProvider[i].wt);
		_total_wt		= 	Number(dtlFinding.dgDtl.dataProvider[i].total_wt);
		_labor			= 	Number(dtlFinding.dgDtl.dataProvider[i].labor);
		_qty			= 	Number(dtlFinding.dgDtl.dataProvider[i].qty);
		_cost			= 	Number(dtlFinding.dgDtl.dataProvider[i].cost);
		_markup			=	Number(dtlFinding.dgDtl.dataProvider[i].markup_per);
		_labor_wt		= 	Number(dtlFinding.dgDtl.dataProvider[i].labor_wt);
		_gold_surcharge = 	Number(dtlFinding.dgDtl.dataProvider[i].gold_surcharge);
		
		_metal_type		=	dtlFinding.dgDtl.dataProvider[i].metal_type;
		_unit			=	dtlFinding.dgDtl.dataProvider[i].unit;
		_supplier 		= 	dtlFinding.dgDtl.dataProvider[i].supplier;

		if(_labor_wt > 0)
		{
			_labor = Number(numericFormatter2.format(_labor_wt * _total_wt));
			dtlFinding.dgDtl.dataProvider[i].labor	= _labor.toString();
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
		dtlFinding.dgDtl.dataProvider[i].cost = numericFormatter2.format(_cost.toString());
		
		_total_cost = Number(numericFormatter2.format(((_wt_cost + _gold_surcharge) * _total_wt) + (_labor)));
		dtlFinding.dgDtl.dataProvider[i].total_cost = _total_cost.toString();
	
		if(_vendor_fixed_cost > 0 && _supplier == 'V')
		{
			_cost = 0;
			_total_cost = 0;
			_labor = 0;
			
			dtlFinding.dgDtl.dataProvider[i].cost 		= _cost.toString();
			dtlFinding.dgDtl.dataProvider[i].total_cost = _total_cost.toString();
			dtlFinding.dgDtl.dataProvider[i].labor 		= _labor.toString();
		}
	
		_price = _total_cost * ((100 + _markup) / 100);
		dtlFinding.dgDtl.dataProvider[i].price	= numericFormatter2.format(_price.toString());
	}
}	

private function getFindingVendorValue():Number
{
	var _value:Number = 0;
	var _supplier:String;
	var _gridLength:Number = dtlFinding.dgDtl.dataProvider.length;
	
	for(var i:int = 0; i < _gridLength; i++)
	{
		_supplier = dtlFinding.dgDtl.dataProvider[i]['supplier'];
		
		if(_supplier == 'V')
		{
			_value	= _value + Number(dtlFinding.dgDtl.dataProvider[i]['total_cost']);
		}		
	}
	
	return Number(numericFormatter2.format(_value));
}

private function updateFindings():void  // PB's updateHdrMetal (finding part)
{
	var _vendor_fixed_cost:Number = Number(tiVendor_fixed_cost.dataValue);
	var _supplier:String;
	var _finding_total_wt:Number 	= 0;
	var _finding_total_cost:Number 	= 0;
	
	setFindingType();

	for(var i:int=0; i < dtlFinding.dgDtl.dataProvider.length; i++)
	{
		_finding_total_wt 	= _finding_total_wt + Number(dtlFinding.dgDtl.dataProvider[i].total_wt);
		_supplier 			= dtlFinding.dgDtl.dataProvider[i].supplier;
		
		if(_vendor_fixed_cost > 0 && _supplier == 'V')
		{
			// Do noting it is fixed cost item.	
		}
		else
		{
			_finding_total_cost = _finding_total_cost + Number(dtlFinding.dgDtl.dataProvider[i].total_cost);
		}
	}
	
	tiFinding_cost.dataValue 	= 	numericFormatter2.format(_finding_total_cost.toString());
	tiFinding_wt.dataValue 		=	numericFormatter2.format(_finding_total_wt.toString());
}
