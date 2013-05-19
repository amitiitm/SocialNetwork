import business.events.GetInformationEvent;
import com.generic.events.AddEditEvent;
import com.generic.events.ButtonControlDetailEvent;
import com.generic.events.EditableDetailEvent;
import com.generic.events.FetchRecordEvent;
import com.generic.genclass.GenNumberFormatter;
import model.GenModelLocator;
import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.rpc.IResponder;

private var numericFormatterWt:GenNumberFormatter = new GenNumberFormatter();
private var numericFormatter:GenNumberFormatter 				= 	new GenNumberFormatter();
private var numericFormatterFourPrecesion:GenNumberFormatter	=	new GenNumberFormatter();
private var numericFormatterThreePrecesion:GenNumberFormatter	=	new GenNumberFormatter();
private var numericFormatterWithoutPrecesion:GenNumberFormatter	=	new GenNumberFormatter();
private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

private var isSerial_no_pk:String = 'Y';
private var dtlLineRowIndex:int;

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

	dtlLine.bcdp.btnEdit.visible = false;
	getAccountPeriod();
	tnDetail.selectedChild = vbDetail;
}

private function setFetchParameter(fetch_type:String):void
{
	if(fetch_type.toLocaleUpperCase() == 'GRID')
	{
		dtlLine.fetchDetailDataServiceID = "fetch_open_memos";
		dtlLine.fetchDetailFormatServiceID = 'fetchRecordFormat'
		dtlLine.fetchGetSelectedDetailServiceID = ""
		dtlLine.title = "Open Memos (Lines)"
		dtlLine.isFetchMultipalSelected = true;
		dtlLine.isDetailRequired = false;
		dtlLine.isOverrideDetail = false;
		
		isSerial_no_pk = 'Y'
		createMapping()
	}
	else
	{
		dtlLine.fetchDetailDataServiceID = "fetch_open_memos_hdr";
		dtlLine.fetchDetailFormatServiceID = 'fetchMemoHdrFormat'
		dtlLine.fetchGetSelectedDetailServiceID = "fetchGetSelectedMemoServiceID"
		dtlLine.title = "Open Memos"
		dtlLine.isFetchMultipalSelected = true;
		dtlLine.isDetailRequired = true;
		dtlLine.isOverrideDetail = false;
		
		isSerial_no_pk = 'N'
		createMapping()
	}
}

private function createMapping():void
{
	var mappingArrCol:ArrayCollection = new ArrayCollection();
	
	mappingArrCol.addItem({source: 'trans_bk',				target: 'ref_trans_bk',		isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'trans_no',				target: 'ref_trans_no',		isPrimaryKey:'Y',	updatable:'N'})
	mappingArrCol.addItem({source: 'trans_date',			target: 'ref_trans_date',	isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'serial_no',				target: 'ref_serial_no',	isPrimaryKey:'Y',	updatable:'N'})

	mappingArrCol.getItemAt(3).isPrimaryKey = isSerial_no_pk

	mappingArrCol.addItem({source: 'diamond_sale_memo_id',	target: 'diamond_sale_id' ,	isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'diamond_lot_id',		target: 'diamond_lot_id' ,	isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'diamond_lot_no',		target: 'diamond_lot_no' ,	isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'diamond_packet_id',		target: 'diamond_packet_id',isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'diamond_packet_no',		target: 'diamond_packet_no',isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'sell_unit' ,			target: 'sell_unit' ,		isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'open_pcs' ,				target: 'ref_pcs' ,			isPrimaryKey:'N',	updatable:'N'} )
	mappingArrCol.addItem({source: 'open_wt',				target: 'ref_wt',			isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'price',					target: 'price',			isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'line_amt' ,				target: 'line_amt',			isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'discount_per',			target: 'discount_per',		isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'discount_amt',			target: 'discount_amt',		isPrimaryKey:'N',	updatable:'N'} )
	mappingArrCol.addItem({source: 'net_amt',				target: 'net_amt',			isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'stone_type',			target: 'stone_type',		isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'shape',					target: 'shape',			isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'color',					target: 'color',			isPrimaryKey:'N',	updatable:'N'} )
	mappingArrCol.addItem({source: 'clarity',				target: 'clarity' ,			isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'quality',				target: 'quality',			isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'location_code',			target: 'location_code',	isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'B',						target: 'pcs',				isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'B',						target: 'wt',				isPrimaryKey:'N',	updatable:'N'})

	mappingArrCol.addItem({source: 'diamond_cert_flag',		target: 'diamond_cert_flag', isPrimaryKey:'N',	updatable:'N'})
	
	//id, transFlag , serialNo will be added in FetchRecordSelectCommand because it is commmon in all screens
	dtlLine.fetchMapingArrCol	=	mappingArrCol;
	
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
		
		getInformationEvent	= new GetInformationEvent('termchange', callbacks, dcTerm_code.dataValue, dfTrans_date.text);
		getInformationEvent.dispatch();
	}
}

private function getDueDateHandler(resultXml:XML):void
{
	dfDue_date.text = resultXml.children()[0].pay1_date.toString();
}

private function getCustomerDetails():void
{
	dcCustomer_shipping_id.filterKeyValue = dcCustomer_id.dataValue
	
	if(dcCustomer_id.text != "" && dcCustomer_id.text != null)
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(customerDetailsHandler, null);
		
		getInformationEvent	=	new GetInformationEvent('customerdetail', callbacks, dcCustomer_id.dataValue,"M");
		getInformationEvent.dispatch();  
	}	
}

private function customerDetailsHandler(resultXml:XML):void
{
	setValue(resultXml);
	
	if(dtlLine.dgDtl.rows.children().length()>0)
	{
		dtlLine.dgDtl.rows = new XML('<' + dtlLine.rootNode + '/>');
		calculateGrossAmount();
		updateRecordSummary();
	}
}

private function setValue(customerXml:XML):void
{
	dcCustomer_shipping_id.dataValue = customerXml.children().child('customer_shipping_id').toString(); 
 	dcShipping_code.dataValue = customerXml.children().child('shipping_code').toString(); 
	dcTerm_code.dataValue = customerXml.children().child('term_code').toString();
	
	setShippingAddress(customerXml);
	setBilliingAddress(customerXml);
	
	getDueDate();
}

private function getShippingAddress():void
{
	if(dcCustomer_shipping_id.text != '')
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(getShippingAddressHandler, null);
		
		getInformationEvent	=	new GetInformationEvent('customershippings', callbacks, dcCustomer_shipping_id.dataValue);
		getInformationEvent.dispatch();
		
	}
}

private function getShippingAddressHandler(resultXml:XML):void
{
	setShippingAddress(resultXml);
}

private function setShippingAddress(customerXml:XML):void
{
	tiShip_nm.text = customerXml.children().child('ship_name').toString();
	tiShip_address1.text = customerXml.children().child('ship_address1').toString();
	tiShip_address2.text = customerXml.children().child('ship_address2').toString();
	tiShip_city.text = customerXml.children().child('ship_city').toString();
	tiShip_fax1.text = customerXml.children().child('ship_fax').toString();
	tiShip_phone1.text = customerXml.children().child('ship_phone').toString();
	tiShip_state.text = customerXml.children().child('ship_state').toString();
	tiShip_zip.text = customerXml.children().child('ship_zip').toString();	
	tiShip_country.text = customerXml.children().child('ship_country').toString();
}

private function setBilliingAddress(customerXml:XML):void
{
	tiBill_nm.text = customerXml.children().child('name').toString();
	tiBill_address1.text = customerXml.children().child('bill_address1').toString();
	tiBill_address2.text = customerXml.children().child('bill_address2').toString();
	tiBill_city.text = customerXml.children().child('bill_city').toString();
	tiBill_fax1.text = customerXml.children().child('bill_fax').toString();
	tiBill_phone1.text = customerXml.children().child('bill_phone').toString();
	tiBill_state.text = customerXml.children().child('bill_state').toString();
	tiBill_zip.text = customerXml.children().child('bill_zip').toString();	
	tiBill_country.text = customerXml.children().child('bill_country').toString();

}

private function setGrossAmountEditable(event:EditableDetailEvent):void
{
	var colName:String;
	var rowIndex:int;
	
	//numericFormatter.precision = 2;
	
	if(event.dataGridEvent != null)
	{
		colName = DataGridColumn(event.dataGridEvent.currentTarget.columns[event.dataGridEvent.columnIndex]).dataField.toString()
		rowIndex = event.dataGridEvent.rowIndex

		if(dtlLine.dgDtl.dataProvider != null)
		{
			if(colName == "diamond_packet_no")
			{
				dtlLineRowIndex = rowIndex;
				getPacketDetails();
			}
			if(colName == "discount_amt")
			{
				itemDiscountPerCalculation(rowIndex);
			}
			else if(colName == "line_amt")
			{
				itemPriceCalculation(rowIndex);
			}
			else if(colName != "diamond_packet_no")
			{
				itemNetAmountCalculation(rowIndex);
			}
		}
	}
}

private function getPacketDetails():void
{
	var diamond_packet_no:String = dtlLine.dgDtl.dataProvider[dtlLineRowIndex].diamond_packet_no;
	var diamond_lot_no:String = dtlLine.dgDtl.dataProvider[dtlLineRowIndex].diamond_lot_no;

	if(diamond_packet_no != '')
	{
		var callbacks:IResponder = new mx.rpc.Responder(getPacketDetailsHandler, null);

		getInformationEvent	= new GetInformationEvent('diamondpacketinfovalidate', callbacks, diamond_packet_no, diamond_lot_no, 'N');
		getInformationEvent.dispatch();
	}
	else
	{
		dtlLine.dgDtl.dataProvider[dtlLineRowIndex].diamond_packet_id = "";
	}
}

public function getPacketDetailsHandler(resultXml:XML):void
{
	Alert.show(resultXml.toXMLString())
	
	if(resultXml.children().length() > 0)
	{
		dtlLine.dgDtl.dataProvider[dtlLineRowIndex].diamond_packet_id = resultXml.children()[0].diamond_packet_id.toString();
		dtlLine.dgDtl.dataProvider[dtlLineRowIndex].diamond_packet_no = resultXml.children()[0].diamond_packet_no.toString();
	
		dtlLine.dgDtl.dataProvider[dtlLineRowIndex].pcs = "1";
	}
	else
	{
		dtlLine.dgDtl.dataProvider[dtlLineRowIndex].diamond_packet_id = "";
		dtlLine.dgDtl.dataProvider[dtlLineRowIndex].diamond_packet_no = "";

		dtlLine.dgDtl.dataProvider[dtlLineRowIndex].pcs = dtlLine.dgDtl.dataProvider[dtlLineRowIndex].ref_pcs.toString();
	}
	
	itemNetAmountCalculation(dtlLineRowIndex)
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
	else if(String(dtlLine.dgDtl.dataProvider[rowIndex].sell_unit).toLowerCase()	== "pcs" || String(dtlLine.dgDtl.dataProvider[rowIndex].sell_unit).toLowerCase()	== "e")
	{
		dtlLine.dgDtl.dataProvider[rowIndex].line_amt = numericFormatter.format((dtlLine.dgDtl.dataProvider[rowIndex].pcs * dtlLine.dgDtl.dataProvider[rowIndex].price));
	}
	else
	{
		dtlLine.dgDtl.dataProvider[rowIndex].line_amt = numericFormatter.format((dtlLine.dgDtl.dataProvider[rowIndex].pcs * dtlLine.dgDtl.dataProvider[rowIndex].price));
	}
	
	dtlLine.dgDtl.dataProvider[rowIndex].discount_amt = numericFormatter.format(((dtlLine.dgDtl.dataProvider[rowIndex].line_amt * dtlLine.dgDtl.dataProvider[rowIndex].discount_per)/100));
	dtlLine.dgDtl.dataProvider[rowIndex].net_amt = numericFormatter.format((dtlLine.dgDtl.dataProvider[rowIndex].line_amt - dtlLine.dgDtl.dataProvider[rowIndex].discount_amt));

	if(isCalculateGrossAmount) //it will be false when called from fetchRecordSelectCompleteEventHandler
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
	dtlLine.dgDtl.dataProvider[rowIndex].pcs =	numericFormatterWithoutPrecesion.format(dtlLine.dgDtl.dataProvider[rowIndex].pcs);
	
	if(String(dtlLine.dgDtl.dataProvider[rowIndex].sell_unit).toLowerCase()	== "wt" || String(dtlLine.dgDtl.dataProvider[rowIndex].sell_unit).toLowerCase()	== "c")
	{
		if(dtlLine.dgDtl.dataProvider[rowIndex].wt > 0)
		{
			dtlLine.dgDtl.dataProvider[rowIndex].price 	= numericFormatter.format(dtlLine.dgDtl.dataProvider[rowIndex].line_amt / dtlLine.dgDtl.dataProvider[rowIndex].wt);
		}
	}
	else if(String(dtlLine.dgDtl.dataProvider[rowIndex].sell_unit).toLowerCase() == "pcs" || String(dtlLine.dgDtl.dataProvider[rowIndex].sell_unit).toLowerCase() == "e")
	{
		if(dtlLine.dgDtl.dataProvider[rowIndex].pcs > 0)
		{
			dtlLine.dgDtl.dataProvider[rowIndex].price 	= numericFormatter.format(dtlLine.dgDtl.dataProvider[rowIndex].line_amt / dtlLine.dgDtl.dataProvider[rowIndex].pcs);
		}
	}
	else
	{
		if(dtlLine.dgDtl.dataProvider[rowIndex].pcs > 0)
		{
			dtlLine.dgDtl.dataProvider[rowIndex].price 	= numericFormatter.format(dtlLine.dgDtl.dataProvider[rowIndex].line_amt/ dtlLine.dgDtl.dataProvider[rowIndex].pcs);
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

//--------------------------------------------------------------------------------	
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
//--------------------------------------------------------------------------------	
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

//--------------------------------------------------------------------------------	
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
	
//--------------------------------------------------------------------------------
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

//--------------------------------------------------------------------------------
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

//--------------------------------------------------------------------------------	
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

//--------------------------------------------------------------------------------	
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

//--------------------------------------------------------------------------------	
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
	}*/ 
	tiInsurance_amt.text = numericFormatter.format( tiInsurance_amt.text);
	setNetAmount();
}
	
//--------------------------------------------------------------------------------
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

override protected function preSaveEventHandler(event:AddEditEvent):int
{
	var diamond_packet_id:String;
	var cert_flag:String;
	var diamond_lot_no:String;
	var retValue:int=0;
	var errMsg:String = "";
		
	if(dtlLine.dgDtl.dataProvider.length > 0)
	{
		for(var i:int = 0; i < dtlLine.dgDtl.dataProvider.length; i++)
		{
			diamond_packet_id = dtlLine.dgDtl.dataProvider[i].diamond_packet_id.toString();
			 
			if(diamond_packet_id == null || diamond_packet_id == "")
			{
				/* Commented as packet validation not required in Item Receive.
				cert_flag = dtlLine.dgDtl.dataProvider[i].cert_flag.toString();
				diamond_lot_no = dtlLine.dgDtl.dataProvider[i].diamond_lot_no.toString();
								
				if(cert_flag == 'Y')
				{
					errMsg = errMsg + "Row #" + (i+1).toString() + ", Item # " + diamond_lot_no + ",\n"; 
					retValue = -1;
				}
				*/
			}
			else
			{
				dtlLine.dgDtl.dataProvider[i].pcs = "1";
				
				itemNetAmountCalculation(i)
			}
		}
	}

	if(retValue < 0)
	{
		errMsg = errMsg + "should have Certificate information !";
		Alert.show(errMsg);
	}
	
	return retValue;
}

override protected function retrieveRecordEventHandler(event:AddEditEvent):void  //after save and prev,next,.....
{
	var recordXml:XML = event.recordXml;
	var dtlXml:XML = XML(recordXml.children().child('diamond_sale_lines'))
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

	setFetchParameter('GRID')
	
	dcCustomer_shipping_id.filterKeyValue = dcCustomer_id.dataValue;
	dcCustomer_shipping_id.dataValue = recordXml.children()["customer_shipping_id"];
	
	dcCustomer_id.enabled = false;

	updateRecordSummary()
}

override protected function resetObjectEventHandler():void   //on add buttton press,
{
	dcCustomer_shipping_id.filterKeyValue = "" 
	dcCustomer_id.enabled = true;

	updateRecordSummary()
	
	getAccountPeriod();
}

override protected function fetchRecordSelectCompleteEventHandler(event:FetchRecordEvent):void   //on add buttton press,
{
	if(dtlLine.dgDtl.dataProvider.length > 0)
	{
		tiDiscount_per.text = dtlLine.dgDtl.dataProvider[0]["hdr_discount_per"].toString()
		tiTax_per.text = dtlLine.dgDtl.dataProvider[0]["hdr_tax_per"].toString()

		dtlLine.dgDtl.selectedIndex = 0
		for(var i:int = 0; i < dtlLine.dgDtl.dataProvider.length; i++)
		{
			itemNetAmountCalculation(i, false)
		}
		if(dtlLine.dgDtl.dataProvider.length > 0)
		{
			calculateGrossAmount()
		}			
	}

	updateRecordSummary()
}

override protected function fetchRecordWindowCloseEventHandler(event:FetchRecordEvent):void 
{
	setFetchParameter('GRID')
}

private function handleBtnGetDataClick(event:Event):void
{
	setFetchParameter('BUTTON')

	dtlLine.bcdp.dispatchEvent(new ButtonControlDetailEvent(ButtonControlDetailEvent.FETCH_RECORDS_EVENT));
}

/*
public function handleItemChangedCustomer_id():void
{
	getCustomerDetails()
}
*/

private function refreshShip(event:Event):void
{
	dcCustomer_shipping_id.btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
}