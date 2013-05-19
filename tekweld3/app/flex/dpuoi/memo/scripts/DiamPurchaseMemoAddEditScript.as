import business.events.GetInformationEvent;
import com.generic.events.AddEditEvent;
import com.generic.events.DetailEvent;
import com.generic.genclass.GenNumberFormatter;
import model.GenModelLocator;
import mx.rpc.IResponder;

private var numericFormatterWt:GenNumberFormatter = new GenNumberFormatter();
private var numericFormatter:GenNumberFormatter 				= 	new GenNumberFormatter();
private var numericFormatterFourPrecesion:GenNumberFormatter	=	new GenNumberFormatter();
private var numericFormatterThreePrecesion:GenNumberFormatter	=	new GenNumberFormatter();
private var numericFormatterWithoutPrecesion:GenNumberFormatter	=	new GenNumberFormatter();
private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

private function init():void
{
	numericFormatterWt.precision = 3;
	numericFormatterWt.rounding	= "nearest";

	numericFormatterWithoutPrecesion.precision	=	0;
	numericFormatterWithoutPrecesion.rounding = "nearest";
	
	numericFormatterThreePrecesion.precision	=	3;
	numericFormatterThreePrecesion.rounding = "nearest";
	
	numericFormatterFourPrecesion.precision		=	4;
	numericFormatterFourPrecesion.rounding = "nearest";

	numericFormatter.precision = 2;
	numericFormatter.rounding = "nearest";

	getAccountPeriod();
	tnDetail.selectedChild = vbDetail;
}

private function getAccountPeriod():void
{
	if(dfTrans_date.text != '' && dfTrans_date.text != null)
	{
		var callbacks:IResponder = new mx.rpc.Responder(getAccountPeriodHandler, null);
		
		getInformationEvent	= new GetInformationEvent('accountperiod', callbacks, dfTrans_date.text);
		getInformationEvent.dispatch();
	}
}

private function getAccountPeriodHandler(resultXml:XML):void
{
	dcAccount_period_code.dataValue = resultXml.child('code');
}

private function getDueDate():void
{
	if(dcTerm_code.text != '')
	{
		var callbacks:IResponder = new mx.rpc.Responder(getDueDateHandler, null);
		
		getInformationEvent = new GetInformationEvent('termchange', callbacks, dcTerm_code.dataValue, dfTrans_date.text);
		getInformationEvent.dispatch();
	}
}

private function getDueDateHandler(resultXml:XML):void
{
	dfDue_date.text = resultXml.children()[0].pay1_date.toString();
}

private function getVendorDetails():void
{
	if(dcVendor_id.text != "" && dcVendor_id.text != null)
	{
		var callbacks:IResponder = new mx.rpc.Responder(vendorDetailsHandler, null);
		
		getInformationEvent = new GetInformationEvent('vendordetail', callbacks, dcVendor_id.dataValue,"M");
		getInformationEvent.dispatch();  
	}
}

private function vendorDetailsHandler(resultXml:XML):void
{
	dcTerm_code.dataValue = resultXml.children().child('invoice_term_code').toString();
	setBilliingAddress(resultXml);
	getDueDate();
	
	if(dtlLine.dgDtl.rows.children().length()>0)
	{
		dtlLine.dgDtl.rows = new XML('<' + dtlLine.rootNode + '/>');
		calculateGrossAmount();
		updateRecordSummary();
	}
}

private function setShippingAddress():void
{
	tiShip_nm.text = __genModel.user.company_name.toString();
	tiShip_address1.text = __genModel.user.complc_address1.toString();
	tiShip_address2.text = __genModel.user.complc_address2.toString();
	tiShip_city.text = __genModel.user.complc_city.toString();
	tiShip_fax1.text = __genModel.user.complc_fax.toString();
	tiShip_phone1.text = __genModel.user.complc_phone.toString();
	tiShip_state.text = __genModel.user.complc_state.toString();
	tiShip_zip.text = __genModel.user.complc_pin.toString();	
	tiShip_country.text = __genModel.user.company_country.toString(); 
}

private function setBilliingAddress(resultXml:XML):void
{
	tiBill_nm.text = resultXml.children().child('name').toString();
	tiBill_address1.text = resultXml.children().child('address1').toString();
	tiBill_address2.text = resultXml.children().child('address2').toString();
	tiBill_city.text = resultXml.children().child('city').toString();
	tiBill_fax1.text = resultXml.children().child('fax').toString();
	tiBill_phone1.text = resultXml.children().child('phone').toString();
	tiBill_state.text = resultXml.children().child('state').toString();
	tiBill_zip.text = resultXml.children().child('zip').toString();	
	tiBill_country.text = resultXml.children().child('country').toString();
}

private function setGrossAmountNonEditable(event:DetailEvent):void
{
	calculateGrossAmount()
}

private function itemNetAmountCalculation(rowIndex:int, isCalculateGrossAmount:Boolean = true):void
{
	dtlLine.dgDtl.dataProvider[rowIndex].wt = numericFormatterWt.format(dtlLine.dgDtl.dataProvider[rowIndex].wt)
	dtlLine.dgDtl.dataProvider[rowIndex].pcs = numericFormatterWithoutPrecesion.format(dtlLine.dgDtl.dataProvider[rowIndex].pcs)
	dtlLine.dgDtl.dataProvider[rowIndex].price = numericFormatter.format(dtlLine.dgDtl.dataProvider[rowIndex].price)
	
	if(String(dtlLine.dgDtl.dataProvider[rowIndex].sell_unit).toLowerCase()	== "wt" || String(dtlLine.dgDtl.dataProvider[rowIndex].sell_unit).toLowerCase()	== "c")
	{
		dtlLine.dgDtl.dataProvider[rowIndex].line_amt = numericFormatter.format((dtlLine.dgDtl.dataProvider[rowIndex].wt * dtlLine.dgDtl.dataProvider[rowIndex].price));
	}
	else if(String(dtlLine.dgDtl.dataProvider[rowIndex].sell_unit).toLowerCase() == "pcs" || String(dtlLine.dgDtl.dataProvider[rowIndex].sell_unit).toLowerCase() == "e")
	{
		dtlLine.dgDtl.dataProvider[rowIndex].line_amt = numericFormatter.format((dtlLine.dgDtl.dataProvider[rowIndex].pcs * dtlLine.dgDtl.dataProvider[rowIndex].price));
	}
	else
	{
		dtlLine.dgDtl.dataProvider[rowIndex].line_amt = numericFormatter.format((dtlLine.dgDtl.dataProvider[rowIndex].pcs * dtlLine.dgDtl.dataProvider[rowIndex].price));
	}
	
	dtlLine.dgDtl.dataProvider[rowIndex].discount_amt = numericFormatter.format(((dtlLine.dgDtl.dataProvider[rowIndex].line_amt * dtlLine.dgDtl.dataProvider[rowIndex].discount_per)/100));
	dtlLine.dgDtl.dataProvider[rowIndex].net_amt = numericFormatter.format((dtlLine.dgDtl.dataProvider[rowIndex].line_amt - dtlLine.dgDtl.dataProvider[rowIndex].discount_amt));

	if(isCalculateGrossAmount)//it will be false when called from fetchRecordSelectCompleteEventHandler
	{
		calculateGrossAmount();	
	}	
}

private function updateRecordSummary():void
{
	var _item_pcs:Number = 0;
	var _item_wt:Number = 0;
	var _clear_pcs:Number = 0;
	
	if(dtlLine.dgDtl.dataProvider.length > 0)
	{
		for(var i:int = 0; i < dtlLine.dgDtl.dataProvider.length; i++)
		{
			_item_pcs = _item_pcs + (Number)(dtlLine.dgDtl.dataProvider[i].pcs);
			_item_wt = _item_wt + (Number)(dtlLine.dgDtl.dataProvider[i].wt);
			_clear_pcs = _clear_pcs + (Number)(dtlLine.dgDtl.dataProvider[i].clear_pcs);
		}

		lblTotal_items.text = dtlLine.dgDtl.dataProvider.length.toString()
		lblItem_pcs.text = _item_pcs.toString()
		lblItem_wt.text = numericFormatterWt.format(_item_wt)
		lblClear_pcs.text = _clear_pcs.toString() 
	}
	else
	{
		lblTotal_items.text = '0'
		lblItem_pcs.text = '0'
		lblItem_wt.text = '0'
		lblClear_pcs.text = '0'
	}
}

private function calculateGrossAmount():void
{
	var _grossAmount:Number = 0;
	var _taxableAmount:Number = 0;	
	
	for(var i:int = 0; i < dtlLine.dgDtl.dataProvider.length; i++)
	{
		_grossAmount = _grossAmount + (Number)(dtlLine.dgDtl.dataProvider[i].net_amt);

		if(XML(dtlLine.dgDtl.dataProvider[i]).elements('taxable').length() > 0)
		{
			if(String(dtlLine.dgDtl.dataProvider[i].taxable).toUpperCase() == 'Y')
			{
				_taxableAmount = _taxableAmount + (Number)(dtlLine.dgDtl.dataProvider[i].net_amt);
			}	
		}
	}

	tiTaxable_amt.text = String(_taxableAmount);
	tiLine_amt.text = String(_grossAmount);
	calculateFooterAmounts();
}

private function calculateFooterAmounts():void
{
	discount_perChange(); 
	ship_perChange();
	ins_perChange();
	tax_perChange();
	setNetAmount(); 
}

private function itemPriceCalculation(rowIndex:int):void
{
	dtlLine.dgDtl.dataProvider[rowIndex].line_amt = numericFormatter.format(dtlLine.dgDtl.dataProvider[rowIndex].line_amt);
	dtlLine.dgDtl.dataProvider[rowIndex].wt = numericFormatterWt.format(dtlLine.dgDtl.dataProvider[rowIndex].wt);
	dtlLine.dgDtl.dataProvider[rowIndex].pcs = numericFormatterWithoutPrecesion.format(dtlLine.dgDtl.dataProvider[rowIndex].pcs);
	
	if(String(dtlLine.dgDtl.dataProvider[rowIndex].sell_unit).toLowerCase()	== "wt" || String(dtlLine.dgDtl.dataProvider[rowIndex].sell_unit).toLowerCase()	== "c")
	{
		if(dtlLine.dgDtl.dataProvider[rowIndex].wt > 0)
		{
			dtlLine.dgDtl.dataProvider[rowIndex].price = numericFormatter.format(dtlLine.dgDtl.dataProvider[rowIndex].line_amt / dtlLine.dgDtl.dataProvider[rowIndex].wt);
		}
	}
	else if(String(dtlLine.dgDtl.dataProvider[rowIndex].sell_unit).toLowerCase() == "pcs" || String(dtlLine.dgDtl.dataProvider[rowIndex].sell_unit).toLowerCase() == "e")
	{
		if(dtlLine.dgDtl.dataProvider[rowIndex].pcs > 0)
		{
			dtlLine.dgDtl.dataProvider[rowIndex].price = numericFormatter.format(dtlLine.dgDtl.dataProvider[rowIndex].line_amt / dtlLine.dgDtl.dataProvider[rowIndex].pcs);
		}
	}
	else
	{
		if(dtlLine.dgDtl.dataProvider[rowIndex].pcs > 0)
		{
			dtlLine.dgDtl.dataProvider[rowIndex].price = numericFormatter.format(dtlLine.dgDtl.dataProvider[rowIndex].line_amt/ dtlLine.dgDtl.dataProvider[rowIndex].pcs);
		}
	}
	
	itemNetAmountCalculation(rowIndex);
}

private function itemDiscountPerCalculation(rowIndex:int):void
{
	dtlLine.dgDtl.dataProvider[rowIndex].discount_amt = numericFormatter.format(dtlLine.dgDtl.dataProvider[rowIndex].discount_amt);
	dtlLine.dgDtl.dataProvider[rowIndex].line_amt = numericFormatter.format(dtlLine.dgDtl.dataProvider[rowIndex].line_amt);
	
	if(dtlLine.dgDtl.dataProvider[rowIndex].line_amt > 0)
	{
		dtlLine.dgDtl.dataProvider[rowIndex].discount_per = numericFormatter.format(((dtlLine.dgDtl.dataProvider[rowIndex].discount_amt * 100)/dtlLine.dgDtl.dataProvider[rowIndex].line_amt));
	}
	
	itemNetAmountCalculation(rowIndex);
}

private function setNetAmount():void
{
	var _gross_amt:Number 	= Number(tiLine_amt.text);
	
	if(_gross_amt == 0)
	{
		tiOther_amt.text = '0.00';
	}

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
		tiNet_amt.text = numericFormatter.format(String(_gross_amt + _ship_amt - _dis_amt + _ins_amt + _sal_tax + _other_amt));
	} 

}	

private function discount_perChange():void
{
	var _gross_amt:Number = Number(tiLine_amt.text);
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
	
private function discount_amtChange():void
{
	var _gross_amt:Number = Number(tiLine_amt.text);
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

private function tax_perChange():void
{
	//numericFormatter.precision = 4;
	var _gross_amt:Number 	= Number(tiLine_amt.text); // May be we need to set tiTaxable_amt Vivek 2010 Jul 2 
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
		//numericFormatter.precision = 3;
		tiTax_per.text = numericFormatterThreePrecesion.format(tiTax_per.text);
		setNetAmount(); 
	}
}

private function tax_amtChange():void
{
	var _tax_amt:Number 	= parseFloat(tiTax_amt.text);
	var _gross_amt:Number 	= Number(tiLine_amt.text);	// May be we need to set tiTaxable_amt Vivek 2010 Jul 2
	 
	if (_tax_amt == 0 || String(_tax_amt) == 'NaN')
	{
		tiTax_per.text = String(0.000);
	}
	else
	{
		tiTax_per.text = numericFormatter.format(String(Number(_tax_amt / _gross_amt * 100)));
	}
	//numericFormatter.precision = 4;
	tiTax_amt.text = numericFormatterFourPrecesion.format(tiTax_amt.text);
	//numericFormatter.precision = 2;
	setNetAmount(); 
}
	
private function ship_perChange():void
{
	var _gross_amt:Number = Number(tiLine_amt.text);
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
}				

private function ship_amtChange():void
{
	var _ship_amt:Number 	= parseFloat(tiShip_amt.text);
	var _gross_amt:Number 	= Number(tiLine_amt.text);

	/* if (_ship_amt == 0 || String(_ship_amt) == 'NaN')
	{
		tiShip_per.text = String(0.00);
	}
	else
	{
		tiShip_per.text = numericFormatter.format(String(Number(_ship_amt / _gross_amt * 100)));
	} */
	tiShip_amt.text =  numericFormatter.format(tiShip_amt.text);
	setNetAmount(); 
}

private function ins_perChange():void
{
	var _gross_amt:Number 	= Number(tiLine_amt.text);
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
}				

private function insurance_amtChange():void
{
	var _ins_amt:Number 	= parseFloat(tiInsurance_amt.text);
	var _gross_amt:Number 	= Number(tiLine_amt.text);
	
	/* if (_ins_amt == 0 || String(_ins_amt) == 'NaN')
	{
		tiInsurance_per.text = String(0.00);
	}
	else
	{
		tiInsurance_per.text = numericFormatter.format(String(Number(_ins_amt / _gross_amt * 100)));
	} */
	tiInsurance_amt.text = numericFormatter.format( tiInsurance_amt.text);
	setNetAmount();
}

private function other_amtChange():void
{
	var _gross_amt:Number 	= Number(tiLine_amt.text);
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

override protected function retrieveRecordEventHandler(event:AddEditEvent):void  //after save and prev,next,.....
{
	var recordXml:XML = event.recordXml;
	var dtlXml:XML = XML(recordXml.children().child('diamond_purchase_lines'))
	var _taxableAmount:Number = 0;
	
	for(var i:int = 0; i < dtlXml.children().length(); i++)
	{
		if(XML(dtlXml.children()[i]).elements('taxable').length() > 0)
		{
			if(String(dtlXml.children()[i].taxable).toUpperCase() == 'Y')
			{
				_taxableAmount = _taxableAmount + (Number)(dtlXml.children()[i].net_amt);
			}	
		}
	}

	tiTaxable_amt.text = String(_taxableAmount);
	
	dcVendor_id.enabled = false;

	updateRecordSummary()
}

override protected function resetObjectEventHandler():void   //on add buttton press,
{
	dcVendor_id.enabled	= true;

	updateRecordSummary()
	
	getAccountPeriod();
}

