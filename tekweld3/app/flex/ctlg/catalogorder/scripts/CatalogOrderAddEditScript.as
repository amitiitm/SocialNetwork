import business.events.GetInformationEvent;
import com.generic.events.AddEditEvent;
import com.generic.genclass.GenNumberFormatter;
import model.GenModelLocator;
import mx.rpc.IResponder;
import ctlg.catalogorder.CatalogOrderModelLocator

private var numericFormatter:GenNumberFormatter 				= 	new GenNumberFormatter();
private var numericFormatterFourPrecesion:GenNumberFormatter	=	new GenNumberFormatter();
private var numericFormatterThreePrecesion:GenNumberFormatter	=	new GenNumberFormatter();
private var numericFormatterWithoutPrecesion:GenNumberFormatter	=	new GenNumberFormatter();
private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __localModel:CatalogOrderModelLocator = (CatalogOrderModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
private var image_name:String;

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

	
	__localModel.trans_date = dfTrans_date.text	
	getAccountPeriod();
	tnDetail.selectedChild = vbDetail;
}

private function getAccountPeriod():void
{
	if(dfTrans_date.text != '' && dfTrans_date.text != null)
	{
		var callbacks:IResponder = new mx.rpc.Responder(getAccountPeriodHandler, null);
		
		getInformationEvent	=	new GetInformationEvent('accountperiod', callbacks, dfTrans_date.text);
		getInformationEvent.dispatch(); 
	}
}

private function getAccountPeriodHandler(resultXml:XML):void
{
	dcAccount_period_code.dataValue	=	resultXml.child('code');
}

private function getCustomerDetails():void
{

	if(dcCustomer_id.text != "" && dcCustomer_id.text != null)
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(customerDetailsHandler, null);
		
		getInformationEvent	=	new GetInformationEvent('customerdetail', callbacks, dcCustomer_id.dataValue, "I");
		getInformationEvent.dispatch();  
	}
}

private function customerDetailsHandler(resultXml:XML):void
{
	setValue(resultXml);
	
	if(dtlLine.dgDtl.rows.children().length()>0)
	{
		dtlLine.dgDtl.rows	=	new XML('<' + dtlLine.rootNode + '/>');
	}	
}

private function setValue(customerXml:XML):void
{

	setShippingAddress(customerXml);
	setBilliingAddress(customerXml);
}

private function setShippingAddress(customerXml:XML):void
{

	tiShip_address1.text = customerXml.children().child('ship_address1').toString();
	tiShip_address2.text = customerXml.children().child('ship_address2').toString();
	tiShip_city.text = customerXml.children().child('ship_city').toString();
	tiShip_state.text = customerXml.children().child('ship_state').toString();
	tiShip_zip.text = customerXml.children().child('ship_zip').toString();	
	tiShip_country.text = customerXml.children().child('ship_country').toString();
}

private function setBilliingAddress(customerXml:XML):void
{
	tiBill_address1.text = customerXml.children().child('bill_address1').toString();
	tiBill_address2.text = customerXml.children().child('bill_address2').toString();
	tiBill_city.text = customerXml.children().child('bill_city').toString();
	tiBill_state.text = customerXml.children().child('bill_state').toString();
	tiBill_zip.text = customerXml.children().child('bill_zip').toString();	
	tiBill_country.text = customerXml.children().child('bill_country').toString();

}

private function setGrossAmount():void
{
	var _grossAmount:Number = 0;
	var _taxableAmount:Number = 0;
	var _item_qty:Number = 0;
	var _clear_qty:Number = 0;
	
	//numericFormatter.precision = 2;
	
	if(dtlLine.dgDtl.dataProvider != null)
	{
		for(var i:int = 0; i < dtlLine.dgDtl.dataProvider.length; i++)
		{
			_grossAmount = _grossAmount + (Number)(dtlLine.dgDtl.dataProvider[i].amount);
			
			if(XML(dtlLine.dgDtl.dataProvider[i]).elements('taxable').length() > 0)
			{
				if(String(dtlLine.dgDtl.dataProvider[i].taxable).toUpperCase() == 'Y')
				{
					_taxableAmount = _taxableAmount + (Number)(dtlLine.dgDtl.dataProvider[i].amount);
				}	
			}
			
			_item_qty = _item_qty + (Number)(dtlLine.dgDtl.dataProvider[i].qty);
			_clear_qty = _clear_qty + (Number)(dtlLine.dgDtl.dataProvider[i].clear_qty);
		}

		lblTotal_items.text = dtlLine.dgDtl.dataProvider.length.toString()
		lblItem_qty.text = _item_qty.toString()
		lblClear_qty.text = _clear_qty.toString() 
	}
	else
	{
		lblTotal_items.text = '0'
		lblItem_qty.text = '0'
		lblClear_qty.text = '0'
	}
	
	tiItem_amt.text 	=	String(_grossAmount);
	discount_perChange(); //need to call when user update another item in existing transaction.

	//ship_perChange();
	//ins_perChange(); 

	setNetAmount(); 

}
//--------------------------------------------------------------------------------
private function setNetAmount():void
{
	var _gross_amt:Number 	= Number(tiItem_amt.text);

	if (_gross_amt >= 0)
	{
		var _dis_amt:Number  = Number(numericFormatter.format(tiDiscount_amt.text));
		var _ship_amt:Number = Number(numericFormatter.format(tiShip_amt.text));
		//var _ins_amt:Number  = Number(numericFormatter.format(tiInsurance_amt.text));
		var _sal_tax:Number  = Number(numericFormatter.format(tiTax_amt.text));
			
		//tiNet_amt.text = numericFormatter.format(String(_gross_amt + _ship_amt - _dis_amt + _ins_amt + _sal_tax + _other_amt)); 
		tiNet_amt.text = numericFormatter.format(String(_gross_amt + _ship_amt - _dis_amt  + _sal_tax ));
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

private function tax_amtChange():void
{
	setNetAmount(); 
}	
//--------------------------------------------------------------------------------
private function ship_amtChange():void
{
	var _ship_amt:Number 	= parseFloat(tiShip_amt.text);
	var _gross_amt:Number 	= Number(tiItem_amt.text);

	/* if (_ship_amt == 0 || String(_ship_amt) == 'NaN')
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
override protected function retrieveRecordEventHandler(event:AddEditEvent):void  //after save and prev,next,.....
{
	var recordXml:XML	= event.recordXml;


	__localModel.trans_date = dfTrans_date.text

	if(dtlLine.dgDtl.dataProvider.length > 0)
	{
		dtlLine.dgDtl.selectedIndex = 0
	}

	changeImage()
	setGrossAmount()

}

override protected function resetObjectEventHandler():void   //on add buttton press,
{
	getAccountPeriod();

	
	__localModel.trans_date = dfTrans_date.text
	
	changeImage()
	//setGrossAmount()
	
}

private function changeImage():void
{
	if(dtlLine.dgDtl.selectedRow != null)
	{
		image_name = dtlLine.dgDtl.selectedRow["image_thumnail"]
	}
	else
	{
		image_name = null
	}
}
