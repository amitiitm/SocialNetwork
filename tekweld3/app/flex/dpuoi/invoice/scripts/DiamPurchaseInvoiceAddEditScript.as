import business.events.GetInformationEvent;
import com.generic.customcomponents.GenDataGrid;
import com.generic.events.AddEditEvent;
import com.generic.events.ButtonControlDetailEvent;
import com.generic.events.DetailEvent;
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
private var isSerial_no_pk:String = 'Y';
private var dtlLineRowIndex:int;

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

	dtlLine.bcdp.btnEdit.visible = false;
	getAccountPeriod();
	tnDetail.selectedChild = vbDetail;
}

private function invoiceTypeChangeEvent():void
{
	setDtlComponent(cbInvoice_type.dataValue, 'GRID')

	dtlLine.dgDtl.rows = new XML('<' + dtlLine.rootNode + '/>');
	dtlLineNonEditable.dgDtl.rows = new XML('<' + dtlLineNonEditable.rootNode + '/>');
	updateRecordSummary() 
}

private function setDtlComponent(invoiceType:String, fetch_type:String):void
{
	if(invoiceType.toUpperCase() == 'M')
	{
		vsDtl.selectedChild = hbEditable
		dtlLine.updatableFlag = "true"
		dtlLineNonEditable.updatableFlag = "false"		
		btnGetData.enabled = true	
	}
	else if(invoiceType.toUpperCase() == 'D')
	{
		vsDtl.selectedChild = hbNonEditable
		dtlLine.updatableFlag = "false"
		dtlLineNonEditable.updatableFlag = "true"		
		btnGetData.enabled = false	
	}

	setFetchParameter(invoiceType.toUpperCase(), fetch_type)
}

private function setFetchParameter(invoice_type:String, fetch_type:String):void
{
	if(invoice_type == 'M')
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
	else if(invoice_type == 'D')
	{
		dtlLine.fetchDetailDataServiceID = '';
		dtlLine.fetchDetailFormatServiceID = '';
		dtlLine.fetchGetSelectedDetailServiceID = '';
		dtlLine.title = ""
		dtlLine.isFetchMultipalSelected = true;
		dtlLine.isDetailRequired = false;
		dtlLine.isOverrideDetail = false;
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

	mappingArrCol.addItem({source: 'diamond_purchase_memo_id',	target: 'diamond_purchase_id' ,	isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'diamond_lot_id',		target: 'diamond_lot_id' ,	isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'diamond_lot_no',		target: 'diamond_lot_no' ,	isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'diamond_packet_id',		target: 'diamond_packet_id' ,	isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'diamond_packet_no',		target: 'diamond_packet_no' ,	isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'sell_unit' ,			target: 'sell_unit' ,		isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'open_pcs',				target: 'ref_pcs' ,			isPrimaryKey:'N',	updatable:'N'} )
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
	mappingArrCol.addItem({source: 'diamond_cert_flag',		target: 'diamond_cert_flag', 	isPrimaryKey:'N',	updatable:'N'})
	
	//id, transFlag , serialNo will be added in FetchRecordSelectCommand because it is commmon in all screens
	dtlLine.fetchMapingArrCol	=	mappingArrCol;
}

private function getAccountPeriod():void
{
	if(dfTrans_date.text != '' && dfTrans_date.text != null)
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(getAccountPeriodHandler, null);
		
		getInformationEvent	=	new GetInformationEvent('accountperiod', callbacks, dfTrans_date.text);
		getInformationEvent.dispatch(); 
	}
}

private function getAccountPeriodHandler(resultXml:XML):void
{
	dcAccount_period_code.dataValue	=	resultXml.child('code');
}

private function getDueDate():void
{
	if(dcTerm_code.text != '')
	{
		 var callbacks:IResponder	=	new mx.rpc.Responder(getDueDateHandler, null);
		
		getInformationEvent	=	new GetInformationEvent('termchange', callbacks, dcTerm_code.dataValue, dfTrans_date.text);
		getInformationEvent.dispatch();
	}
}

private function getDueDateHandler(resultXml:XML):void
{
	dfDue_date.text		=	resultXml.children()[0].pay1_date.toString();
}

private function getVendorDetails():void
{
	if(dcVendor_id.text != "" && dcVendor_id.text != null)
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(vendorDetailsHandler, null);
		
		getInformationEvent	=	new GetInformationEvent('vendordetail', callbacks, dcVendor_id.dataValue, "I");
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

	if(dtlLineNonEditable.dgDtl.rows.children().length()>0)
	{
		dtlLineNonEditable.dgDtl.rows = new XML('<' + dtlLineNonEditable.rootNode + '/>');
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

private function setGrossAmountEditable(event:EditableDetailEvent):void
{
	var colName:String;
	var rowIndex:int;

	//numericFormatter.precision = 2;
	
	if(event.dataGridEvent != null)
	{
		colName = DataGridColumn(event.dataGridEvent.currentTarget.columns[event.dataGridEvent.columnIndex]).dataField.toString()
		rowIndex = event.dataGridEvent.rowIndex

		if(event.dataGridEvent.currentTarget.dataProvider != null)
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
	var tempGrid:GenDataGrid = getDtlComponentGrid();
	var diamond_packet_no:String = tempGrid.dataProvider[dtlLineRowIndex].diamond_packet_no;
	var diamond_lot_no:String = tempGrid.dataProvider[dtlLineRowIndex].diamond_lot_no;

	if(diamond_packet_no != '')
	{
		var callbacks:IResponder = new mx.rpc.Responder(getPacketDetailsHandler, null);

		getInformationEvent	= new GetInformationEvent('diamondpacketinfovalidate', callbacks, diamond_packet_no, diamond_lot_no, 'N');
		getInformationEvent.dispatch();
	}
	else
	{
		tempGrid.dataProvider[dtlLineRowIndex].diamond_packet_id = "";
	}
}

public function getPacketDetailsHandler(resultXml:XML):void
{
	var tempGrid:GenDataGrid = getDtlComponentGrid();
	
	if(resultXml.children().length() > 0)
	{
		tempGrid.dataProvider[dtlLineRowIndex].diamond_packet_id = resultXml.children()[0].diamond_packet_id.toString();
		tempGrid.dataProvider[dtlLineRowIndex].diamond_packet_no = resultXml.children()[0].diamond_packet_no.toString();
	
		tempGrid.dataProvider[dtlLineRowIndex].pcs = "1";
	}
	else
	{
		tempGrid.dataProvider[dtlLineRowIndex].diamond_packet_id = "";
		tempGrid.dataProvider[dtlLineRowIndex].diamond_packet_no = "";

		tempGrid.dataProvider[dtlLineRowIndex].pcs = tempGrid.dataProvider[dtlLineRowIndex].ref_pcs.toString();
	}
	
	itemNetAmountCalculation(dtlLineRowIndex)
}

private function setGrossAmountNonEditable(event:DetailEvent):void
{
	calculateGrossAmount()
}

private function itemNetAmountCalculation(rowIndex:int, isCalculateGrossAmount:Boolean = true):void
{
	var tempGrid:GenDataGrid = getDtlComponentGrid()
	
	tempGrid.dataProvider[rowIndex].wt 	= numericFormatterWt.format(tempGrid.dataProvider[rowIndex].wt)
	tempGrid.dataProvider[rowIndex].pcs = numericFormatterWithoutPrecesion.format(tempGrid.dataProvider[rowIndex].pcs)
	tempGrid.dataProvider[rowIndex].price = numericFormatter.format(tempGrid.dataProvider[rowIndex].price)
	
	if(String(tempGrid.dataProvider[rowIndex].sell_unit).toLowerCase()	== "wt" || String(tempGrid.dataProvider[rowIndex].sell_unit).toLowerCase()	== "c")
	{
		tempGrid.dataProvider[rowIndex].line_amt = numericFormatter.format((tempGrid.dataProvider[rowIndex].wt * tempGrid.dataProvider[rowIndex].price));
	}
	else if(String(tempGrid.dataProvider[rowIndex].sell_unit).toLowerCase()	== "pcs" || String(tempGrid.dataProvider[rowIndex].sell_unit).toLowerCase()	== "e")
	{
		tempGrid.dataProvider[rowIndex].line_amt = numericFormatter.format((tempGrid.dataProvider[rowIndex].pcs * tempGrid.dataProvider[rowIndex].price));
	}
	else
	{
		tempGrid.dataProvider[rowIndex].line_amt = numericFormatter.format((tempGrid.dataProvider[rowIndex].pcs * tempGrid.dataProvider[rowIndex].price));
	}
	
	tempGrid.dataProvider[rowIndex].discount_amt = numericFormatter.format(((tempGrid.dataProvider[rowIndex].line_amt * tempGrid.dataProvider[rowIndex].discount_per)/100));
	tempGrid.dataProvider[rowIndex].net_amt = numericFormatter.format((tempGrid.dataProvider[rowIndex].line_amt - tempGrid.dataProvider[rowIndex].discount_amt));

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
	var tempGrid:GenDataGrid = getDtlComponentGrid()
	
	if(tempGrid.dataProvider.length > 0)
	{
		for(var i:int = 0; i < tempGrid.dataProvider.length; i++)
		{
			_item_pcs = _item_pcs + (Number)(tempGrid.dataProvider[i].pcs);
			_item_wt = _item_wt + (Number)(tempGrid.dataProvider[i].wt);
			_clear_pcs = _clear_pcs + (Number)(tempGrid.dataProvider[i].clear_pcs);
		}

		lblTotal_items.text = tempGrid.dataProvider.length.toString()
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
	var tempGrid:GenDataGrid = getDtlComponentGrid();
	
	for(var i:int = 0; i < tempGrid.dataProvider.length; i++)
	{
		_grossAmount = _grossAmount + (Number)(tempGrid.dataProvider[i].net_amt);

		if(XML(tempGrid.dataProvider[i]).elements('taxable').length() > 0)
		{
			if(String(tempGrid.dataProvider[i].taxable).toUpperCase() == 'Y')
			{
				_taxableAmount = _taxableAmount + (Number)(tempGrid.dataProvider[i].net_amt);
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
	var tempGrid:GenDataGrid = getDtlComponentGrid()
		
	tempGrid.dataProvider[rowIndex].line_amt = numericFormatter.format(tempGrid.dataProvider[rowIndex].line_amt);
	tempGrid.dataProvider[rowIndex].wt = numericFormatterWt.format(tempGrid.dataProvider[rowIndex].wt);
	tempGrid.dataProvider[rowIndex].pcs = numericFormatterWithoutPrecesion.format(tempGrid.dataProvider[rowIndex].pcs);
	
	if(String(tempGrid.dataProvider[rowIndex].sell_unit).toLowerCase()	== "wt" || String(tempGrid.dataProvider[rowIndex].sell_unit).toLowerCase()	== "c")
	{
		if(tempGrid.dataProvider[rowIndex].wt > 0)
		{
			tempGrid.dataProvider[rowIndex].price = numericFormatter.format(tempGrid.dataProvider[rowIndex].line_amt / tempGrid.dataProvider[rowIndex].wt);
		}
	}
	else if(String(tempGrid.dataProvider[rowIndex].sell_unit).toLowerCase()	== "pcs" || String(tempGrid.dataProvider[rowIndex].sell_unit).toLowerCase()	== "e")
	{
		if(tempGrid.dataProvider[rowIndex].pcs > 0)
		{
			tempGrid.dataProvider[rowIndex].price = numericFormatter.format(tempGrid.dataProvider[rowIndex].line_amt / tempGrid.dataProvider[rowIndex].pcs);
		}
	}
	else
	{
		if(tempGrid.dataProvider[rowIndex].pcs > 0)
		{
			tempGrid.dataProvider[rowIndex].price = numericFormatter.format(tempGrid.dataProvider[rowIndex].line_amt/ tempGrid.dataProvider[rowIndex].pcs);
		}
	}
	
	itemNetAmountCalculation(rowIndex);
}

private function itemDiscountPerCalculation(rowIndex:int):void
{
	var tempGrid:GenDataGrid = getDtlComponentGrid()
	
	tempGrid.dataProvider[rowIndex].discount_amt = numericFormatter.format(tempGrid.dataProvider[rowIndex].discount_amt);
	tempGrid.dataProvider[rowIndex].line_amt = numericFormatter.format(tempGrid.dataProvider[rowIndex].line_amt);
	
	if(tempGrid.dataProvider[rowIndex].line_amt > 0)
	{
		tempGrid.dataProvider[rowIndex].discount_per = numericFormatter.format(((tempGrid.dataProvider[rowIndex].discount_amt * 100)/tempGrid.dataProvider[rowIndex].line_amt));
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

override protected function preSaveEventHandler(event:AddEditEvent):int
{
	var diamond_packet_id:String;
	var cert_flag:String;
	var diamond_lot_no:String;
	var retValue:int=0;
	var errMsg:String = "";
		
	var tempGrid:GenDataGrid = getDtlComponentGrid()
		
	if(tempGrid.dataProvider.length > 0)
	{
		for(var i:int = 0; i < tempGrid.dataProvider.length; i++)
		{
			diamond_packet_id = tempGrid.dataProvider[i].diamond_packet_id.toString();
			 
			if(diamond_packet_id == null || diamond_packet_id == "")
			{
				/* Commented as packet validation not required in Item Receive.
				cert_flag = tempGrid.dataProvider[i].cert_flag.toString();
				diamond_lot_no = tempGrid.dataProvider[i].diamond_lot_no.toString();
				
				if(cert_flag == 'Y')
				{
					errMsg = errMsg + "Row #" + (i+1).toString() + ", Item # " + diamond_lot_no + ",\n"; 
					retValue = -1;
				}
				*/
			}
			else
			{
				tempGrid.dataProvider[i].pcs = "1";
				
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
	
	setDtlComponent(recordXml.children().child('ref_type').toString(), 'GRID')
	
	dcVendor_id.enabled	=	false;
	cbInvoice_type.enabled = false;	

	var tempGrid:GenDataGrid = getDtlComponentGrid()

	if(tempGrid.dataProvider.length > 0)
	{
		tempGrid.selectedIndex = 0
	}

	updateRecordSummary()
}

override protected function resetObjectEventHandler():void   //on add buttton press,
{
	invoiceTypeChangeEvent()
			
	dcCompany_store_id.dataValue = __genModel.user.default_company_id.toString() //to set default store
	setShippingAddress();
	getAccountPeriod();
	
	dcVendor_id.enabled		=	true;
	cbInvoice_type.enabled	=	true;

	updateRecordSummary();
}

override protected function fetchRecordSelectCompleteEventHandler(event:FetchRecordEvent):void   //on add buttton press,
{
	var tempGrid:GenDataGrid = getDtlComponentGrid();

	if(tempGrid.dataProvider.length > 0)
	{
		tiDiscount_per.text = tempGrid.dataProvider[0]["hdr_discount_per"].toString()
		tiTax_per.text = tempGrid.dataProvider[0]["hdr_tax_per"].toString()

		tempGrid.selectedIndex = 0
		for(var i:int = 0; i < tempGrid.dataProvider.length; i++)
		{
			itemNetAmountCalculation(i, false)
		}
		if(tempGrid.dataProvider.length > 0)
		{
			calculateGrossAmount()
		}			
	}

	updateRecordSummary()
}

override protected function fetchRecordWindowCloseEventHandler(event:FetchRecordEvent):void 
{
	var invoice_type:String = cbInvoice_type.dataValue.toLocaleUpperCase();
	setFetchParameter(invoice_type, 'GRID')
}

private function getDtlComponentGrid():GenDataGrid
{
	var tempGrid:GenDataGrid;

	if(cbInvoice_type.dataValue.toUpperCase() == 'D')
	{
		dtlLine.dgDtl.rows = new XML('<' + dtlLine.rootNode + '/>');
		tempGrid = dtlLineNonEditable.dgDtl
	}
	else
	{
		dtlLineNonEditable.dgDtl.rows = new XML('<' + dtlLineNonEditable.rootNode + '/>');
		tempGrid = dtlLine.dgDtl
	}
	
	return tempGrid;	
}

private function handleBtnGetDataClick(event:Event):void
{
	var invoice_type:String = cbInvoice_type.dataValue.toLocaleUpperCase();
	setFetchParameter(invoice_type, 'BUTTON')

	dtlLine.bcdp.dispatchEvent(new ButtonControlDetailEvent(ButtonControlDetailEvent.FETCH_RECORDS_EVENT));
}
