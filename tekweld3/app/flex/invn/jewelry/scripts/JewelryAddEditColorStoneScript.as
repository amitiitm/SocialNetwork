import com.generic.events.DetailEvent;
import com.generic.events.GenTextInputEvent;

private function handleColorStoneUpdateComplete(event:DetailEvent):void
{
	updateColorStones();
	updateCenterStones();
	updateSettingCosts();
	updateAllTotal();	
}

private function handleColorStoneMarkupItemChanged(event:GenTextInputEvent):void
{
	var _markup_per:Number	=	Number(tiColor_stone_mu.dataValue);
	var _cost:Number 		= 	Number(tiColor_stone_cost.dataValue);
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
		
	tiColor_stone_amt.dataValue = numericFormatter2.format(_amount.toString());
	updateAllTotal();
}

private function handleColorStoneAmtItemchanged(event:GenTextInputEvent):void
{
	var _amount:Number		=	Number(tiColor_stone_amt.dataValue);
	var _cost:Number 		= 	Number(tiColor_stone_cost.dataValue);
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

	tiColor_stone_mu.dataValue = numericFormatter2.format(_markup_per.toString());
	updateAllTotal();
}

private function handleColorStoneRetailMarkupItemChanged(event:GenTextInputEvent):void
{
	var _markup_per:Number		=	Number(tiColor_stone_mu_retail.dataValue);
	var _wholesale_amt:Number 	=	Number(tiColor_stone_amt.dataValue);
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
	
	tiColor_stone_amt_retail.dataValue = numericFormatter2.format(_retail_price.toString());
	updateAllTotal();
}

private function handleColorStoneRetailPriceItemChanged(event:GenTextInputEvent):void
{
	var _retail_price:Number 	= 	Number(tiColor_stone_amt_retail.dataValue);
	var _wholesale_price:Number = 	Number(tiColor_stone_amt.dataValue);
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
	
	tiColor_stone_mu_retail.dataValue = numericFormatter2.format(_markup_per.toString());
	updateAllTotal()
}

private function getColorStoneDutyCost():Number
{
	var _stone_value:Number = 0.00;
	var gridlength:int = dtlStone.dgDtl.dataProvider.length;
	var column_name:String = 'total_cost';

	for(var i:int = 0; i < gridlength; i++)
	{
		if(dtlStone.dgDtl.dataProvider[i].duty_flag == 'Y')
		{
			_stone_value = _stone_value + (Number)(dtlStone.dgDtl.dataProvider[i][column_name]);
			_stone_value = _stone_value + (Number)(dtlStone.dgDtl.dataProvider[i].setting_cost);
		}
	}
	
	return _stone_value;
}

private function setColorStoneWholesaleAndRetailPrice():void
{
	setColorStoneWholesalePrice();
	setColorStoneRetailPrice();	
}

private function setColorStoneWholesalePrice():void
{
	var _color_stone_cost:Number 	= Number(tiColor_stone_cost.dataValue);
	var _color_stone_mu:Number 		= Number(tiColor_stone_mu.dataValue);
	var _color_stone_amount:Number 	= 0;
	
	if(_color_stone_mu >= 100 && __localModel.margin_calculation_flag == 'Y')
	{
		_color_stone_mu = 99;
	}

	if(__localModel.margin_calculation_flag == 'N')
	{
		_color_stone_amount = _color_stone_cost + Number(numericFormatter2.format(_color_stone_cost * _color_stone_mu / 100));
	}
	else
	{
		_color_stone_amount = Number(numericFormatter2.format((100 * _color_stone_cost) / (100 - _color_stone_mu)));
	}
			
	tiColor_stone_amt.dataValue = numericFormatter2.format(_color_stone_amount.toString());
}

private function setColorStoneRetailPrice():void
{
	var _color_stone_mu_retail:Number 	= Number(tiColor_stone_mu_retail.dataValue);
	var _color_stone_amt:Number 		= Number(tiColor_stone_amt.dataValue);
	var _color_stone_amt_retail:Number;

	if(_color_stone_mu_retail >= 100 && __localModel.margin_calculation_flag == 'Y')
	{
		_color_stone_amt_retail = 99
	} 

	if(__localModel.margin_calculation_flag == 'N')
	{
		_color_stone_amt_retail = _color_stone_amt + Number(numericFormatter2.format(_color_stone_amt * _color_stone_mu_retail / 100));
	}
	else
	{
		_color_stone_amt_retail = Number(numericFormatter2.format((100 * _color_stone_amt) / (100 - _color_stone_mu_retail)));
	}
	
	tiColor_stone_amt_retail.dataValue = numericFormatter2.format(_color_stone_amt_retail.toString());
}

private function getColorStoneSetterValue():Number
{
	var _color_stone_value:Number	= 0;
	var gridlength:int				= dtlStone.dgDtl.dataProvider.length;
	var _setter:String;

	for(var i:int = 0; i < gridlength; i++)
	{
		if(dtlStone.dgDtl.dataProvider[i].setter == 'V')	
		{
			_color_stone_value = _color_stone_value + (Number)(dtlStone.dgDtl.dataProvider[i]['total_cost']);
			_color_stone_value = _color_stone_value + (Number)(dtlStone.dgDtl.dataProvider[i]['setting_cost']);
		}
	}
	
	return _color_stone_value;	
}

private function getColorStoneVendorValue():Number
{
	var _value:Number = 0;
	var _supplier:String;
	var _gridLength:Number = dtlStone.dgDtl.dataProvider.length;
	
	for(var i:int = 0; i < _gridLength; i++)
	{
		_supplier 	= 	dtlStone.dgDtl.dataProvider[i]['supplier'];
		
		if(_supplier == 'V')
		{
			_value = _value + Number(dtlStone.dgDtl.dataProvider[i]['total_cost']);
		}
	}
	
	return Number(numericFormatter2.format(_value));
}

private function updateColorStones():void
{
	var _qty:Number			=	0;
	var _total_wt:Number	=	0;
	var	_total_cost:Number	=	0;
	var	_center_stone_flag:String;
	var _gridlength:int		=	dtlStone.dgDtl.dataProvider.length; 
	
	for(var i:int=0; i < _gridlength; i++)
	{
		_qty 		=	_qty + Number(dtlStone.dgDtl.dataProvider[i].qty);
		_total_wt 	=	_total_wt + Number(dtlStone.dgDtl.dataProvider[i].total_wt);

		_center_stone_flag	=	dtlStone.dgDtl.dataProvider[i].flag1
		
		if(_center_stone_flag == 'N')
		{
			_total_cost 	=	_total_cost + Number(dtlStone.dgDtl.dataProvider[i].total_cost);
		}
	}
		
	tiColor_stone_qty.dataValue	 =	_qty.toString();
	tiColor_stone_wt.dataValue	 =	numericFormatter2.format(_total_wt.toString());
	tiColor_stone_cost.dataValue = 	numericFormatter2.format(_total_cost.toString());
	
	if(_gridlength > 0)
	{
		tiColor_stone_type.dataValue	=	dtlStone.dgDtl.dataProvider[0].stone_type;
		tiColor_stone_shape.dataValue	=	dtlStone.dgDtl.dataProvider[0].stone_shape;	
		tiColor_stone_size.dataValue	=	dtlStone.dgDtl.dataProvider[0].stone_size;	
	}
}

