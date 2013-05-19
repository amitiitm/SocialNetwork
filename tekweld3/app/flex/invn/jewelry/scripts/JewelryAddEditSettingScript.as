import com.generic.events.GenTextInputEvent;

private function handleSettingMarkupItemChanged(event:GenTextInputEvent):void
{
	var _markup_per:Number	=	Number(tiSettinglabor_mu.dataValue);
	var _cost:Number 		= 	Number(tiSettinglabor_cost.dataValue);
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
		
	tiSettinglabor_amt.dataValue = numericFormatter2.format(_amount.toString());
	updateAllTotal();
}

private function handleSettingAmtItemchanged(event:GenTextInputEvent):void
{
	var _amount:Number		=	Number(tiSettinglabor_amt.dataValue);
	var _cost:Number 		= 	Number(tiSettinglabor_cost.dataValue);
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

	tiSettinglabor_mu.dataValue = numericFormatter2.format(_markup_per.toString());
	updateAllTotal();
}

private function handleSettingRetailMarkupItemChanged(event:GenTextInputEvent):void
{
	var _markup_per:Number		=	Number(tiSettinglabor_mu_retail.dataValue);
	var _wholesale_amt:Number 	=	Number(tiSettinglabor_amt.dataValue);
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
	
	tiSettinglabor_amt_retail.dataValue = numericFormatter2.format(_retail_price.toString());
	updateAllTotal();
}

private function handleSettingRetailPriceItemChanged(event:GenTextInputEvent):void
{
	var _retail_price:Number 	= 	Number(tiSettinglabor_amt_retail.dataValue);
	var _wholesale_price:Number = 	Number(tiSettinglabor_amt.dataValue);
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
	
	tiSettinglabor_mu_retail.dataValue = numericFormatter2.format(_markup_per.toString());
	updateAllTotal()
}

private function setSettingWholesaleAndRetailPrice(): void
{
	setSettingWholesalePrice();
	setSettingRetailPrice();
}

private function setSettingWholesalePrice(): void
{
	var _setting_labor_cost:Number		= Number(tiSettinglabor_cost.dataValue);
    var _setting_labor_mu:Number 		= Number(tiSettinglabor_mu.dataValue);
    var _setting_labor_amount:Number 	= 0;
	
	if(_setting_labor_mu >= 100 && __localModel.margin_calculation_flag == 'Y')
	{
		_setting_labor_mu = 99;
	}

	if(__localModel.margin_calculation_flag == 'N')
	{
		_setting_labor_amount = _setting_labor_cost + Number(numericFormatter2.format(_setting_labor_cost * _setting_labor_mu / 100));
	}
	else
	{
		_setting_labor_amount = Number(numericFormatter2.format((100 * _setting_labor_cost)/(100 - _setting_labor_mu)));
	}	
	
	tiSettinglabor_amt.dataValue = numericFormatter2.format(_setting_labor_amount.toString());
}

private function setSettingRetailPrice():void
{
	var _setting_amt:Number 		= Number(tiSettinglabor_amt.dataValue);
	var _setting_mu_retail:Number 	= Number(tiSettinglabor_mu_retail.dataValue);
	var _setting_amt_retail:Number;

	if(_setting_mu_retail >= 100 && __localModel.margin_calculation_flag == 'Y')
	{
		_setting_mu_retail = 99
	} 

	if(__localModel.margin_calculation_flag == 'N')
	{
		_setting_amt_retail = _setting_amt + Number(numericFormatter2.format(_setting_amt * _setting_mu_retail / 100));
	}
	else
	{
		_setting_amt_retail = Number(numericFormatter2.format((100 * _setting_amt) / (100 - _setting_mu_retail)));
	}	
	
	tiSettinglabor_amt_retail.dataValue = numericFormatter2.format(_setting_amt_retail.toString());
}

private function getSettingVendorValue():Number
{
	var _value:Number = 0;
	var _setter:String;
	var _stoneGridLength:Number 	= 	dtlStone.dgDtl.dataProvider.length;
	var _diamondGridLength:Number 	=	dtlDiamond.dgDtl.dataProvider.length;
	
	for(var i:int = 0; i < _diamondGridLength; i++)
	{
		_setter	=	dtlDiamond.dgDtl.dataProvider[i]['setter'];
		
		if(_setter == 'V')
		{
			_value = _value + Number(dtlDiamond.dgDtl.dataProvider[i]['setting_cost']);
		}
	}

	for(var j:int = 0; j < _stoneGridLength; j++)
	{
		_setter	=	dtlStone.dgDtl.dataProvider[j]['setter'];
		
		if(_setter == 'V')
		{
			_value = _value + Number(dtlStone.dgDtl.dataProvider[j]['setting_cost']);
		}
	}
	
	return Number(numericFormatter2.format(_value));
}

private function updateSettingCosts():void
{
	var	_setting_cost:Number	=	0;
	
	for(var i:int=0; i < dtlDiamond.dgDtl.dataProvider.length; i++)
	{
		_setting_cost	=	_setting_cost + Number(dtlDiamond.dgDtl.dataProvider[i].setting_cost);
	}

	for(var j:int=0; j < dtlStone.dgDtl.dataProvider.length; j++)
	{
		_setting_cost	=	_setting_cost + Number(dtlStone.dgDtl.dataProvider[j].setting_cost);
	}
		
	tiSettinglabor_cost.dataValue =	numericFormatter2.format(_setting_cost.toString());
}
