import com.generic.events.GenTextInputEvent;

private function handleCenterStoneMarkupItemChanged(event:GenTextInputEvent):void
{
	var _markup_per:Number	=	Number(tiCenter_stone_mu.dataValue);
	var _cost:Number 		= 	Number(tiCenter_stone_cost.dataValue);
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
		
	tiCenter_stone_amt.dataValue = numericFormatter2.format(_amount.toString());
	updateAllTotal();
}

private function handleCreateStoneAmtItemchanged(event:GenTextInputEvent):void
{
	var _amount:Number		=	Number(tiCenter_stone_amt.dataValue);
	var _cost:Number 		= 	Number(tiCenter_stone_cost.dataValue);
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

	tiCenter_stone_mu.dataValue = numericFormatter2.format(_markup_per.toString());
	updateAllTotal();
}

private function handleCenterStoneRetailMarkupItemChanged(event:GenTextInputEvent):void
{
	var _markup_per:Number		=	Number(tiCenter_stone_retail_mu.dataValue);
	var _wholesale_amt:Number 	=	Number(tiCenter_stone_amt.dataValue);
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
	
	tiCenter_stone_retail_price.dataValue = numericFormatter2.format(_retail_price.toString());
	updateAllTotal();
}

private function handleCenterStoneRetailPriceItemChanged(event:GenTextInputEvent):void
{
	var _retail_price:Number 	= 	Number(tiCenter_stone_retail_price.dataValue);
	var _wholesale_price:Number = 	Number(tiCenter_stone_amt.dataValue);
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
	
	tiCenter_stone_retail_mu.dataValue = numericFormatter2.format(_markup_per.toString());
	updateAllTotal()
}

private function setCenterStoneWholesaleAndRetailPrice():void
{
	setCenterStoneWholesalePrice();
	setCenterStoneRetailPrice();
}

private function setCenterStoneWholesalePrice():void
{
	var _center_stone_cost:Number 	= Number(tiCenter_stone_cost.dataValue);
    var _center_stone_mu:Number 	= Number(tiCenter_stone_mu.dataValue);
    var _center_stone_amount:Number	= 0;
	
	if(_center_stone_mu >= 100 && __localModel.margin_calculation_flag == 'Y')
	{
		_center_stone_mu = 99;
	}

	if(__localModel.margin_calculation_flag == 'N')
	{
		_center_stone_amount = _center_stone_cost + Number(numericFormatter2.format(_center_stone_cost * _center_stone_mu / 100));
	}
	else
	{
		_center_stone_amount = Number(numericFormatter2.format((100 * _center_stone_cost)/(100 - _center_stone_mu)));
	}
			
	tiCenter_stone_amt.dataValue = numericFormatter2.format(_center_stone_amount.toString());
}

private function setCenterStoneRetailPrice():void
{
	var _center_stone_amt:Number 		= Number(tiCenter_stone_amt.dataValue);
	var _center_stone_retail_mu:Number 	= Number(tiCenter_stone_retail_mu.dataValue);
	var _center_stone_amt_retail:Number;

	if(_center_stone_retail_mu >= 100 && __localModel.margin_calculation_flag == 'Y')
	{
		_center_stone_retail_mu = 99
	} 

	if(__localModel.margin_calculation_flag == 'N')
	{
		_center_stone_amt_retail = _center_stone_amt + Number(numericFormatter2.format(_center_stone_amt * _center_stone_retail_mu / 100));	
	}
	else
	{
		_center_stone_amt_retail = Number(numericFormatter2.format((100 * _center_stone_amt) / (100 - _center_stone_retail_mu)));
	}

	tiCenter_stone_retail_price.dataValue = numericFormatter2.format(_center_stone_amt_retail.toString());
}

private function updateCenterStones():void
{
	var	_total_cost:Number	=	0;
	var	_center_stone_flag:String;
	var _diamondGrid:int	=	dtlDiamond.dgDtl.dataProvider.length;
	var _stoneGrid:int		=	dtlStone.dgDtl.dataProvider.length;

	tiCenter_stone_type.dataValue	=	"";
	tiCenter_stone_shape.dataValue	=	"";
	tiCenter_stone_qlty.dataValue	=	"";
	
	for(var i:int=0; i < _diamondGrid; i++)
	{
		_center_stone_flag	=	dtlDiamond.dgDtl.dataProvider[i].flag1
		
		if(_center_stone_flag == 'Y')
		{
			_total_cost 	=	_total_cost + Number(dtlDiamond.dgDtl.dataProvider[i].total_cost);

			tiCenter_stone_type.dataValue	=	'DIAM';
			tiCenter_stone_shape.dataValue	=	dtlDiamond.dgDtl.dataProvider[i].stone_shape;
			tiCenter_stone_qlty.dataValue	=	dtlDiamond.dgDtl.dataProvider[i].stone_quality;
		}
	}

	for(var j:int=0; j < _stoneGrid; j++)
	{
		_center_stone_flag	=	dtlStone.dgDtl.dataProvider[j].flag1
		
		if(_center_stone_flag == 'Y')
		{
			_total_cost 	=	_total_cost + Number(dtlStone.dgDtl.dataProvider[j].total_cost);

			tiCenter_stone_type.dataValue	=	dtlStone.dgDtl.dataProvider[j].stone_type;
			tiCenter_stone_shape.dataValue	=	dtlStone.dgDtl.dataProvider[j].stone_shape;
			tiCenter_stone_qlty.dataValue	=	dtlStone.dgDtl.dataProvider[j].stone_quality;
		}
	}
		
	tiCenter_stone_cost.dataValue =	numericFormatter2.format(_total_cost.toString());
}
