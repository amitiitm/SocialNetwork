import com.generic.events.DetailEvent;
import com.generic.events.GenTextInputEvent;
import mx.controls.Alert;

private function handleDiamondUpdateComplete(event:DetailEvent):void
{
	updateDiamonds();
	updateCenterStones();
	updateSettingCosts();
	updateAllTotal();
}

private function handleDiamondMarkupItemChanged(event:GenTextInputEvent):void
{
	var _markup_per:Number	=	Number(tiDiamond_mu.dataValue);
	var _cost:Number 		= 	Number(tiDiamond_cost.dataValue);
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
		
	tiDiamond_amt.dataValue = numericFormatter2.format(_amount.toString());
	updateAllTotal();
}

private function handleDiamondAmtItemchanged(event:GenTextInputEvent):void
{
	var _amount:Number		=	Number(tiDiamond_amt.dataValue);
	var _cost:Number 		= 	Number(tiDiamond_cost.dataValue);
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

	tiDiamond_mu.dataValue = numericFormatter2.format(_markup_per.toString());
	updateAllTotal();
}

private function handleDiamondRetailMarkupItemChanged(event:GenTextInputEvent):void
{
	var _markup_per:Number		=	Number(tiDiamond_mu_retail.dataValue);
	var _wholesale_amt:Number 	=	Number(tiDiamond_amt.dataValue);
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
	
	tiDiamond_amt_retail.dataValue = numericFormatter2.format(_retail_price.toString());
	updateAllTotal();
}

private function handleDiamondRetailPriceItemChanged(event:GenTextInputEvent):void
{
	var _retail_price:Number 	= 	Number(tiDiamond_amt_retail.dataValue);
	var _wholesale_price:Number = 	Number(tiDiamond_amt.dataValue);
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
	
	tiDiamond_mu_retail.dataValue = numericFormatter2.format(_markup_per.toString());
	updateAllTotal()
}

private function getDiamondDutyCost():Number
{
	var _diam_value:Number 	= 0.00;
	var gridlength:int 		= dtlDiamond.dgDtl.dataProvider.length;
	var column_name:String 	= 'total_cost';

	for(var i:int = 0; i < gridlength; i++)
	{
		if(dtlDiamond.dgDtl.dataProvider[i].duty_flag == 'Y')
		{
			_diam_value = _diam_value + (Number)(dtlDiamond.dgDtl.dataProvider[i][column_name]);
			_diam_value = _diam_value + (Number)(dtlDiamond.dgDtl.dataProvider[i].setting_cost);
		}
	}
	
	return _diam_value;
}

private function setDiamondWholesaleAndRetailPrice(): void
{
	setDiamondWholesalePrice();
	setDiamondRetailPrice();
}

private function setDiamondWholesalePrice(): void
{
	var _diam_cost:Number = Number(tiDiamond_cost.dataValue);
	var _diam_mu:Number   = Number(tiDiamond_mu.dataValue);
	var _diam_amount:Number = 0;
	
	if(_diam_mu >= 100 && __localModel.margin_calculation_flag == 'Y')
	{
		_diam_mu = 99;
	}
 
	if(__localModel.margin_calculation_flag == 'N')
	{
		_diam_amount = _diam_cost + Number(numericFormatter2.format(_diam_cost * _diam_mu / 100));
	}
	else
	{
		_diam_amount = Number(numericFormatter2.format((100 * _diam_cost) / (100 - _diam_mu)));
	}	

	tiDiamond_amt.dataValue = numericFormatter2.format(_diam_amount.toString());
}

private function setDiamondRetailPrice():void
{
	var _diam_mu_retail:Number 	= Number(tiDiamond_mu_retail.dataValue);
	var _diam_amt:Number 		= Number(tiDiamond_amt.dataValue);
	var _diam_amt_retail:Number;

	if(_diam_mu_retail >= 100 && __localModel.margin_calculation_flag == 'Y')
	{
		_diam_mu_retail = 99
	} 

	if(__localModel.margin_calculation_flag == 'N')
	{
		_diam_amt_retail = _diam_amt + Number(numericFormatter2.format(_diam_amt * _diam_mu_retail / 100));
	}
	else
	{
		_diam_amt_retail = Number(numericFormatter2.format((100 * _diam_amt) / (100 - _diam_mu_retail)));
	}	

	tiDiamond_amt_retail.dataValue = numericFormatter2.format(_diam_amt_retail.toString());
}

private function getDiamondSetterValue():Number
{
	var _diam_value:Number 	= 0;
	var gridlength:int		= dtlDiamond.dgDtl.dataProvider.length;
	var _setter:String;

	for(var i:int = 0; i < gridlength; i++)
	{
		if(dtlDiamond.dgDtl.dataProvider[i].setter == 'V')	
		{
			_diam_value = _diam_value + (Number)(dtlDiamond.dgDtl.dataProvider[i]['total_cost']);
			_diam_value = _diam_value + (Number)(dtlDiamond.dgDtl.dataProvider[i]['setting_cost']);
		}
	}
	
	return _diam_value;
}

private function getDiamondVendorValue():Number
{
	var _value:Number = 0;
	var _supplier:String;
	var _gridLength:Number = dtlDiamond.dgDtl.dataProvider.length;
	
	for(var i:int = 0; i < _gridLength; i++)
	{
		_supplier 	= 	dtlDiamond.dgDtl.dataProvider[i]['supplier'];
		
		if(_supplier == 'V')
		{
			_value = _value + Number(dtlDiamond.dgDtl.dataProvider[i]['total_cost']);
		}
	}
	
	return Number(numericFormatter2.format(_value));
}

private function updateDiamonds():void
{
	var _qty:Number			=	0;
	var _total_wt:Number	=	0;
	var	_total_cost:Number	=	0;
	var	_center_stone_flag:String;
	var _gridlength:int		=	dtlDiamond.dgDtl.dataProvider.length; 
	
	for(var i:int=0; i < _gridlength; i++)
	{
		_qty 		=	_qty + Number(dtlDiamond.dgDtl.dataProvider[i].qty);
		_total_wt 	=	_total_wt + Number(dtlDiamond.dgDtl.dataProvider[i].total_wt);

		_center_stone_flag	=	dtlDiamond.dgDtl.dataProvider[i].flag1
		
		if(_center_stone_flag == 'N')
		{
			_total_cost 	=	_total_cost + Number(dtlDiamond.dgDtl.dataProvider[i].total_cost);
		}
	}
		
	tiDiamond_qty.dataValue	 =	_qty.toString();
	tiDiamond_wt.dataValue	 =	numericFormatter2.format(_total_wt.toString());
	tiDiamond_cost.dataValue = 	numericFormatter2.format(_total_cost.toString());
	
	if(_gridlength > 0)
	{
		tiDiamond_qlty.dataValue	=	dtlDiamond.dgDtl.dataProvider[0].stone_quality;		
	}
}