// ActionScript file
import com.generic.genclass.GenNumberFormatter;
private var numericFormatter:GenNumberFormatter 				= 	new GenNumberFormatter();
private var numericFormatterFourPrecesion:GenNumberFormatter	=	new GenNumberFormatter();
private var numericFormatterThreePrecesion:GenNumberFormatter	=	new GenNumberFormatter();
private var numericFormatterWithoutPrecesion:GenNumberFormatter	=	new GenNumberFormatter();

[Bindable]
public var itemAmtXmlTag:String = "item_amt";

private function init():void
{
	numericFormatterWithoutPrecesion.precision	=	0;
	numericFormatterWithoutPrecesion.rounding = "nearest";
	
	numericFormatterThreePrecesion.precision	=	3;
	numericFormatterThreePrecesion.rounding = "nearest";
	
	numericFormatterFourPrecesion.precision		=	4;
	numericFormatterFourPrecesion.rounding = "nearest";

	numericFormatter.precision = 2;
	numericFormatter.rounding = "nearest";

}
public function setTotalItemAmt(_totalAmt:Number):void
{
	tiItem_amt.text 	=	String(_totalAmt);
}
public function setTotalTaxableAmt(_totalTaxableAmt:Number):void
{
	tiTaxable_amt.text 	=	String(_totalTaxableAmt);
}
public function calculateFooters():void
{
	discount_perChange(); 
	//ship_perChange();
	//ins_perChange(); 
	tax_perChange();
	setNetAmount(); 	
}
public function setDiscountPer(_discountPer:Number):void
{
	tiDiscount_per.text	=	String(_discountPer);
}
public function setTaxPer(_taxPer:Number):void
{
	tiTax_per.text	=	String(_taxPer);
}
//--------------------------------------------------------------------------------
private function setNetAmount():void
{
	var _gross_amt:Number 	= Number(tiItem_amt.text);

	if (_gross_amt >= 0)
	{
		var _dis_amt:Number  = Number(numericFormatter.format(tiDiscount_amt.text));
		var _ship_amt:Number = Number(numericFormatter.format(tiShip_amt.text));
		var _ins_amt:Number  = Number(numericFormatter.format(tiInsurance_amt.text));
		var _sal_tax:Number  = Number(numericFormatter.format(tiTax_amt.text));
		var _other_amt:Number = parseFloat(numericFormatter.format(tiOther_amt.text));
		
		if (String(_other_amt) == 'NaN' || String(_other_amt) == '') 
		{
			tiOther_amt.text = String(0.00);
		} 
		tiNet_amt.text = numericFormatter.format(String(_gross_amt + _ship_amt - _dis_amt  + _sal_tax + _other_amt + _ins_amt));
	} 

}	
//--------------------------------------------------------------------------------	
	
private function discount_perChange():void
{
	var _gross_amt:Number = Number(tiItem_amt.text);
	if (_gross_amt >= 0)
	{
		var _dis_per:Number = parseFloat(tiDiscount_per.text);
		var _dis_amt:Number;
		
		if (_dis_per == 0 || String(_dis_per) == 'NaN' || String(_dis_per) == '')
		{
			_dis_amt = 0;
			tiDiscount_per.text = numericFormatter.format(String(0.00));
		}
		else
		{
			_dis_amt = Number(numericFormatter.format(_gross_amt * _dis_per / 100));
		} 
		tiDiscount_amt.text = numericFormatter.format(String(_dis_amt));
		tiDiscount_per.text = numericFormatter.format(tiDiscount_per.text);				
		setNetAmount(); 
	}
}				

//--------------------------------------------------------------------------------	
private function discount_amtChange():void
{
	var _gross_amt:Number = Number(tiItem_amt.text);
	if (_gross_amt >= 0)
	{
		var _dis_amt:Number = parseFloat(tiDiscount_amt.text);
	 	if (_dis_amt == 0 || String(_dis_amt) == 'NaN')
		{
			tiDiscount_per.text = String(0.00);
		}
		else
		{
			tiDiscount_per.text = numericFormatter.format(String(Number(_dis_amt / _gross_amt * 100)));
		} 
		tiDiscount_amt.text	 = numericFormatter.format(tiDiscount_amt.text);
		setNetAmount(); 
	}
}

private function tax_perChange():void //tax calculation on taxable amount
{
	var _gross_amt:Number 	= Number(tiTaxable_amt.text);
	if (_gross_amt >= 0)
	{
		var _tax_per:Number = parseFloat(tiTax_per.text);
		var _tax_amt:Number;
		 if (_tax_per == 0 || String(_tax_per) == 'NaN' || String(_tax_per) == '')
		{
			_tax_amt = 0;
			tiTax_per.text = numericFormatterFourPrecesion.format(String(0));
		}
		else
		{
			_tax_amt = Number(numericFormatterFourPrecesion.format(_gross_amt *_tax_per / 100));
		} 
		tiTax_amt.text = numericFormatterFourPrecesion.format(String(_tax_amt));
		
		tiTax_per.text = numericFormatterThreePrecesion.format(tiTax_per.text);
		setNetAmount(); 
		
	}
}

private function tax_amtChange():void
{
	var _tax_amt:Number 	= parseFloat(tiTax_amt.text);
	var _gross_amt:Number 	= Number(tiTaxable_amt.text);
	if (_tax_amt == 0 || String(_tax_amt) == 'NaN')
	{
		tiTax_per.text = String(0.000);
	}
	else
	{
		tiTax_per.text = numericFormatter.format(String(Number(_tax_amt / _gross_amt * 100)));
	}
	
	tiTax_amt.text = numericFormatterFourPrecesion.format(tiTax_amt.text);
	setNetAmount(); 
}	

//--------------------------------------------------------------------------------

/* private function ship_perChange():void
{
	var _gross_amt:Number = Number(tiItem_amt.text);
	if (_gross_amt >= 0)
	{
		var _ship_per:Number = parseFloat(tiShip_per.text);
		var _ship_amt:Number;
	 	if (_ship_per == 0 || String(_ship_per) == 'NaN' || String(_ship_per) == '')
		{
			_ship_amt = 0;
			tiShip_per.text = numericFormatter.format(String(0.00));
		}
		else
		{
			_ship_amt = Number(numericFormatter.format(_gross_amt * _ship_per / 100));
		} 
		tiShip_amt.text = numericFormatter.format(String(_ship_amt));
		tiShip_per.text = numericFormatter.format(tiShip_per.text);
		setNetAmount(); 
	}
} */				

//--------------------------------------------------------------------------------

private function ship_amtChange():void
{
/* 	var _ship_amt:Number 	= parseFloat(tiShip_amt.text);
	var _gross_amt:Number 	= Number(tiItem_amt.text);

	if (_ship_amt == 0 || String(_ship_amt) == 'NaN')
	{
		tiShip_per.text = String(0.00);
	}
	else
	{
		tiShip_per.text = numericFormatter.format(String(Number(_ship_amt / _gross_amt * 100)));
	}  */
	tiShip_amt.text =  numericFormatter.format(tiShip_amt.text);
	setNetAmount(); 
}
	
//--------------------------------------------------------------------------------

/* private function ins_perChange():void
{
	var _gross_amt:Number 	= Number(tiItem_amt.text);
	if (_gross_amt >= 0)
	{
		var _ins_per:Number = parseFloat(tiInsurance_per.text);
		var _ins_amt:Number;
		 if (_ins_per == 0 || String(_ins_per) == 'NaN' || String(_ins_per) == '')
		{
			_ins_amt = 0;
			tiInsurance_per.text = numericFormatter.format(String(0));
		}
		else
		{
			_ins_amt = Number(numericFormatter.format(_gross_amt * _ins_per / 100));
		} 
		tiInsurance_amt.text = numericFormatter.format(String(_ins_amt));
		tiInsurance_per.text = numericFormatter.format(tiInsurance_per.text);
		setNetAmount(); 
	}
}	 */			
//--------------------------------------------------------------------------------
private function insurance_amtChange():void
{
/* 	var _ins_amt:Number 	= parseFloat(tiInsurance_amt.text);
	var _gross_amt:Number 	= Number(tiItem_amt.text);
	
	 if (_ins_amt == 0 || String(_ins_amt) == 'NaN')
	{
		tiInsurance_per.text = String(0.00);
	}
	else
	{
		tiInsurance_per.text = numericFormatter.format(String(Number(_ins_amt / _gross_amt * 100)));
	}  */
	tiInsurance_amt.text = numericFormatter.format( tiInsurance_amt.text);
	setNetAmount();
}


//--------------------------------------------------------------------------------
private function other_amtChange():void
{
	var _gross_amt:Number 	= Number(tiItem_amt.text);
	if (_gross_amt >= 0)
	{
		var _other_amt:Number 	= parseFloat(tiOther_amt.text);
		if (String(_other_amt) == 'NaN' || String(_other_amt) == '') 
		{
			tiOther_amt.text = numericFormatter.format(String(0.00));
		}
		tiOther_amt.text = numericFormatter.format(tiOther_amt.text);
		setNetAmount(); 
	}
}
