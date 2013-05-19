import com.generic.events.DetailEvent;
import com.generic.events.GenTextInputEvent;

private function handleLaborUpdateComplete(event:DetailEvent):void
{
	updateLabors();
	updateAllTotal();
}

private function handleOtherMarkupItemChanged(event:GenTextInputEvent):void
{
	var _markup_per:Number	=	Number(tiOther_mu.dataValue);
	var _cost:Number 		= 	Number(tiOther_cost.dataValue);
	var _amount:Number 		= 	0;

	if(isNaN(_cost))
	{
		_cost = 0;
	}	

	if(__localModel.margin_calculation_flag == 'N')
	{
		_amount = Number(numericFormatter2.format((_cost * (100 + _markup_per) / 100))); 
	}
	else
	{
		_amount = Number(numericFormatter2.format((100 * _cost) / (100 - _markup_per))); 
	}
		
	tiOther_amt.dataValue = numericFormatter2.format(_amount.toString());
	updateAllTotal();
}

private function handleOtherAmtItemchanged(event:GenTextInputEvent):void
{
	var _amount:Number		=	Number(tiOther_amt.dataValue);
	var _cost:Number 		= 	Number(tiOther_cost.dataValue);
	var _markup_per:Number	=	0;
	
	if(isNaN(_cost))
	{
		_cost = 0;
	}	

	if(_cost > 0)
	{
		if(__localModel.margin_calculation_flag == 'N')
		{
			_markup_per	=	Number(numericFormatter2.format(100 * (_amount - _cost) / _cost)); 
		}
		else
		{
			_markup_per	=	Number(numericFormatter2.format(100 * (_amount - _cost) / _amount));
		}
	}

	tiOther_mu.dataValue = numericFormatter2.format(_markup_per.toString());
	updateAllTotal();
}

private function handleOtherRetailMarkupItemChanged(event:GenTextInputEvent):void
{
	var _markup_per:Number		=	Number(tiOther_mu_retail.dataValue);
	var _wholesale_amt:Number 	=	Number(tiOther_amt.dataValue);
	var _retail_price:Number	=	0;
	
	if(isNaN(_wholesale_amt))
	{
		_wholesale_amt = 0;
	} 	

	if(__localModel.margin_calculation_flag == 'N')
	{
		_retail_price	=	Number(numericFormatter2.format(_wholesale_amt * (100 + _markup_per) / 100));		
	}
	else
	{
		_retail_price	=	Number(numericFormatter2.format((100 + _wholesale_amt) / (100 - _markup_per)));
	}
	
	tiOther_amt_retail.dataValue = numericFormatter2.format(_retail_price.toString());
	updateAllTotal();
}

private function handleOtherRetailPriceItemChanged(event:GenTextInputEvent):void
{
	var _retail_price:Number 	= 	Number(tiOther_amt_retail.dataValue);
	var _wholesale_price:Number = 	Number(tiOther_amt.dataValue);
	var _markup_per:Number		=	0;
	
	if(_wholesale_price > 0)
	{
		if(__localModel.margin_calculation_flag == 'N')
		{
			_markup_per	=	Number(numericFormatter2.format(100 * (_retail_price - _wholesale_price) / _wholesale_price));			
		}
		else
		{
			_markup_per	=	Number(numericFormatter2.format(100 * (_retail_price - _wholesale_price) / _retail_price));
		}
	}
	
	tiOther_mu_retail.dataValue = numericFormatter2.format(_markup_per.toString());
	updateAllTotal()
}

private function handleFinishingMarkupItemChanged(event:GenTextInputEvent):void
{
	var _markup_per:Number	=	Number(tiFinishing_labor_mu.dataValue);
	var _cost:Number 		= 	Number(tiFinishing_labor_cost.dataValue);
	var _amount:Number 		= 	0;

	if(isNaN(_cost))
	{
		_cost = 0;
	}	

	if(__localModel.margin_calculation_flag == 'N')
	{
		_amount = Number(numericFormatter2.format((_cost * (100 + _markup_per) / 100))); 
	}
	else
	{
		_amount = Number(numericFormatter2.format((100 * _cost) / (100 - _markup_per))); 
	}
		
	tiFinishing_labor_amt.dataValue = numericFormatter2.format(_amount.toString());
	updateAllTotal();
}

private function handleFinishingAmtItemchanged(event:GenTextInputEvent):void
{
	var _amount:Number		=	Number(tiFinishing_labor_amt.dataValue);
	var _cost:Number 		= 	Number(tiFinishing_labor_cost.dataValue);
	var _markup_per:Number	=	0;
	
	if(isNaN(_cost))
	{
		_cost = 0;
	}	

	if(_cost > 0)
	{
		if(__localModel.margin_calculation_flag == 'N')
		{
			_markup_per	=	Number(numericFormatter2.format(100 * (_amount - _cost) / _cost)); 
		}
		else
		{
			_markup_per	=	Number(numericFormatter2.format(100 * (_amount - _cost) / _amount));
		}
	}

	tiFinishing_labor_mu.dataValue = numericFormatter2.format(_markup_per.toString());
	updateAllTotal();
}

private function handleFinishingRetailMarkupItemChanged(event:GenTextInputEvent):void
{
	var _markup_per:Number		=	Number(tiFinishinglabor_mu_retail.dataValue);
	var _wholesale_amt:Number 	=	Number(tiFinishing_labor_amt.dataValue);
	var _retail_price:Number	=	0;
	
	if(isNaN(_wholesale_amt))
	{
		_wholesale_amt = 0;
	} 	

	if(__localModel.margin_calculation_flag == 'N')
	{
		_retail_price	=	Number(numericFormatter2.format(_wholesale_amt * (100 + _markup_per) / 100));		
	}
	else
	{
		_retail_price	=	Number(numericFormatter2.format((100 + _wholesale_amt) / (100 - _markup_per)));
	}
	
	tiFinishinglabor_amt_retail.dataValue = numericFormatter2.format(_retail_price.toString());
	updateAllTotal();
}

private function handleFinishingRetailPriceItemChanged(event:GenTextInputEvent):void
{
	var _retail_price:Number 	= 	Number(tiFinishinglabor_amt_retail.dataValue);
	var _wholesale_price:Number = 	Number(tiFinishing_labor_amt.dataValue);
	var _markup_per:Number		=	0;
	
	if(_wholesale_price > 0)
	{
		if(__localModel.margin_calculation_flag == 'N')
		{
			_markup_per	=	Number(numericFormatter2.format(100 * (_retail_price - _wholesale_price) / _wholesale_price));			
		}
		else
		{
			_markup_per	=	Number(numericFormatter2.format(100 * (_retail_price - _wholesale_price) / _retail_price));
		}
	}
	
	tiFinishinglabor_mu_retail.dataValue = numericFormatter2.format(_markup_per.toString());
	updateAllTotal()
}

private function getLaborDutyCost():Number
{
	var _labor_value:Number = 0;
	var gridlength:int = dtlLabor.dgDtl.dataProvider.length;
	var column_name:String = 'total_cost';

	for(var i:int = 0; i < gridlength; i++)
	{
		if(dtlLabor.dgDtl.dataProvider[i].duty_flag == 'Y')	
		{
			_labor_value = _labor_value + (Number)(dtlLabor.dgDtl.dataProvider[i][column_name]);
		}
	}
	
	return _labor_value;
}

private function setFinishWholesaleAndRetailPrice(): void
{
	setFinishWholesalePrice();
	setFinishRetailPrice();
}

private function setFinishWholesalePrice(): void
{
	var _finishing_labor_cost:Number 	= Number(tiFinishing_labor_cost.dataValue);
    var _finishing_labor_mu:Number 		= Number(tiFinishing_labor_mu.dataValue);
    var _finishing_labor_amount:Number 	= 0;
	
	if(_finishing_labor_mu >= 100 && __localModel.margin_calculation_flag == 'Y')
	{
		_finishing_labor_mu = 99;
	}

	if(__localModel.margin_calculation_flag == 'N')
	{
		_finishing_labor_amount = _finishing_labor_cost + Number(numericFormatter2.format(_finishing_labor_cost * _finishing_labor_mu / 100));
	}
	else
	{
		_finishing_labor_amount = Number(numericFormatter2.format((100 * _finishing_labor_cost)/(100 - _finishing_labor_mu)));
	}	
	
	tiFinishing_labor_amt.dataValue = numericFormatter2.format(_finishing_labor_amount.toString());
}

private function setFinishRetailPrice():void
{
	var _finishing_amt:Number 		= Number(tiFinishing_labor_amt.dataValue);
	var _finishing_mu_retail:Number = Number(tiFinishinglabor_mu_retail.dataValue);
	var _finishing_amt_retail:Number;

	if(_finishing_mu_retail >= 100 && __localModel.margin_calculation_flag == 'Y')
	{
		_finishing_mu_retail = 99
	} 

	if(__localModel.margin_calculation_flag == 'N')
	{
		_finishing_amt_retail = _finishing_amt + Number(numericFormatter2.format(_finishing_amt * _finishing_mu_retail / 100));
	}	
	else
	{
		_finishing_amt_retail = Number(numericFormatter2.format((100 * _finishing_amt) / (100 - _finishing_mu_retail)));
	}
	
	tiFinishinglabor_amt_retail.dataValue = numericFormatter2.format(_finishing_amt_retail.toString());
}

// *-*-*-*-*-*-*-*-*-*-*-*-*-*-* Other Labor Functions *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
private function setOtherWholesaleAndRetailPrice(): void
{
	setOtherWholesalePrice();
	setOtherRetailPrice();
}

private function setOtherWholesalePrice(): void
{
	var _other_cost:Number 		= Number(tiOther_cost.dataValue);
    var _other_mu:Number 		= Number(tiOther_mu.dataValue);
    var _other_amount:Number 	= 0;
	
	if(_other_mu >= 100 && __localModel.margin_calculation_flag == 'Y')
	{
		_other_mu = 99;
	}

	if(__localModel.margin_calculation_flag == 'N')
	{
		_other_amount = _other_cost + Number(numericFormatter2.format(_other_cost * _other_mu / 100));
	}
	else
	{
		_other_amount = Number(numericFormatter2.format((100 * _other_cost)/(100 - _other_mu)));
	}	
	
	tiOther_amt.dataValue = numericFormatter2.format(_other_amount.toString());
}

private function setOtherRetailPrice():void
{
	var _other_amt:Number 		= Number(tiOther_amt.dataValue);
	var _other_mu_retail:Number = Number(tiOther_mu_retail.dataValue);
	var _other_amt_retail:Number;

	if(_other_mu_retail >= 100 && __localModel.margin_calculation_flag == 'Y')
	{
		_other_mu_retail = 99;
	} 

	if(__localModel.margin_calculation_flag == 'N')
	{
		_other_amt_retail = _other_amt + Number(numericFormatter2.format(_other_amt * _other_mu_retail / 100));
	}
	else
	{
		_other_amt_retail = Number(numericFormatter2.format((100 * _other_amt) / (100 - _other_mu_retail)));
	}
	
	tiOther_amt_retail.dataValue = numericFormatter2.format(_other_amt_retail.toString());
}

private function getLaborSetterValue():Number
{
	var _labor_value:Number	= 0;
	var gridlength:int		= dtlLabor.dgDtl.dataProvider.length;
	var _setter:String;

	for(var i:int = 0; i < gridlength; i++)
	{
		if(dtlLabor.dgDtl.dataProvider[i].setter == 'V')	
		{
			_labor_value = _labor_value + (Number)(dtlLabor.dgDtl.dataProvider[i]['total_cost']);
		}
	}
	
	return _labor_value;
}

private function getLaborVendorValue():Number
{
	var _value:Number = 0;
	var _supplier:String;
	var _gridLength:Number = dtlLabor.dgDtl.dataProvider.length;
	
	for(var i:int = 0; i < _gridLength; i++)
	{
		_supplier 	= 	dtlLabor.dgDtl.dataProvider[i]['supplier'];
		
		if(_supplier == 'V')
		{
			_value = _value + Number(dtlLabor.dgDtl.dataProvider[i]['total_cost']);
		}
	}
	
	return Number(numericFormatter2.format(_value));
}

private function updateLabors():void
{
	var _qty:Number			=	0;
	var _cost:Number		=	0;;
	var _labor_cost:Number	=	0;;
	var _other_cost:Number	=	0;;
	var _other_type:String;
		
	for(var i:int=0; i < dtlLabor.dgDtl.dataProvider.length; i++)
	{
		_other_type	=	dtlLabor.dgDtl.dataProvider[i].other_type;
		_qty		=	Number(dtlLabor.dgDtl.dataProvider[i].qty);
		
		if(_other_type == 'LAB')
		{
			_labor_cost	=	_labor_cost + Number(dtlLabor.dgDtl.dataProvider[i].cost) * _qty;
		}
		else
		{
			_other_cost	=	_other_cost + Number(dtlLabor.dgDtl.dataProvider[i].cost) * _qty;
		}			
	}
	
	tiFinishing_labor_cost.dataValue	=	numericFormatter2.format(_labor_cost.toString()); 
	tiOther_cost.dataValue				=	numericFormatter2.format(_other_cost.toString());
}