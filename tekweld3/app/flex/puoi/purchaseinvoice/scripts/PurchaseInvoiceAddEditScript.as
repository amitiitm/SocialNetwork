import business.events.GetInformationEvent;

import com.generic.customcomponents.GenDataGrid;
import com.generic.events.AddEditEvent;
import com.generic.events.ButtonControlDetailEvent;
import com.generic.events.DetailEvent;
import com.generic.events.EditableDetailEvent;
import com.generic.events.FetchRecordEvent;
import com.generic.genclass.GenNumberFormatter;

import flash.events.Event;

import model.GenModelLocator;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.rpc.IResponder;

import puoi.purchaseinvoice.PurchaseInvoiceModelLocator;

private var numericFormatter:GenNumberFormatter 				= 	new GenNumberFormatter();
private var numericFormatterFourPrecesion:GenNumberFormatter	=	new GenNumberFormatter();
private var numericFormatterThreePrecesion:GenNumberFormatter	=	new GenNumberFormatter();
private var numericFormatterWithoutPrecesion:GenNumberFormatter	=	new GenNumberFormatter();
private var getInformationEvent:GetInformationEvent;
private var __localModel:PurchaseInvoiceModelLocator = (PurchaseInvoiceModelLocator)(GenModelLocator.getInstance().activeModelLocator);


private var isSerial_no_pk:String;
private var dtlLineRowIndex:int;

[Bindable]
private var image_name:String;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

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
	
	dtlLine.bcdp.btnEdit.visible = false;

	__localModel.trans_date = dfTrans_date.text	
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
	var tempGrid:GenDataGrid = getDtlComponentGrid()

	
	if(invoiceType.toUpperCase() == 'O')
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

	setFetchParameter(invoiceType.toUpperCase(), fetch_type) // M for Multiple
}

private function setFetchParameter(invoice_type:String, fetch_type:String):void
{
	if(invoice_type == 'O')
	{
		if(fetch_type.toLocaleUpperCase() == 'GRID')
		{
			dtlLine.fetchDetailDataServiceID = "fetch_open_std_orders";
			dtlLine.fetchDetailFormatServiceID = 'fetchRecordFormat';
			dtlLine.fetchGetSelectedDetailServiceID = "";
			dtlLine.title = "Open Orders (Lines)";
			dtlLine.isFetchMultipalSelected = true;
			dtlLine.isDetailRequired = false;
			dtlLine.isOverrideDetail = false;
			
			isSerial_no_pk = 'Y'
			createMapping()
		}
		else
		{
			dtlLine.fetchDetailDataServiceID = "fetch_open_std_orders_hdr";
			dtlLine.fetchDetailFormatServiceID = 'fetchOrderHdrFormat';
			dtlLine.fetchGetSelectedDetailServiceID = "fetchGetSelectedOrderServiceID";
			dtlLine.title = "Open Orders"
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
	mappingArrCol.addItem({source: 'serial_no',				target: 'ref_serial_no',	isPrimaryKey:"N",	updatable:'N'})
	
	mappingArrCol.getItemAt(3).isPrimaryKey = isSerial_no_pk
	
	mappingArrCol.addItem({source: 'catalog_item_id',		target: 'catalog_item_id' ,	isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'catalog_item_code',		target: 'catalog_item_code',isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'item_description',		target: 'item_description',	isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'company_id',			target: 'company_id',		isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'taxable',				target: 'taxable' 			,isPrimaryKey:'N',	updatable:'N'})
	
	mappingArrCol.addItem({source: 'open_qty' ,				target: 'ref_qty' ,			isPrimaryKey:'N',	updatable:'N'} )
	mappingArrCol.addItem({source: 'open_qty',				target: 'item_qty',			isPrimaryKey:'N',	updatable:'N'})	
	mappingArrCol.addItem({source: 'item_price',			target: 'item_price',		isPrimaryKey:'N',	updatable:'N'})
	
	mappingArrCol.addItem({source: 'discount_per',			target: 'discount_per',		isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'discount_amt',			target: 'discount_amt',		isPrimaryKey:'N',	updatable:'N'} )
	mappingArrCol.addItem({source: 'net_amt',				target: 'net_amt',			isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'item_type',				target: 'item_type',		isPrimaryKey:'N',	updatable:'N'})	
	
	mappingArrCol.addItem({source: 'B',						target: 'trans_bk',			isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'B',						target: 'trans_no',			isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'B',						target: 'trans_date',		isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'B' ,					target: 'item_amt',			isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'hdr_discount_per',		target: 'hdr_discount_per',	isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'hdr_tax_per',			target: 'hdr_tax_per',		isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'image_thumnail',		target: 'image_thumnail',	isPrimaryKey:'N',	updatable:'N'})

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
	tiAccount_period_code.dataValue = resultXml.child('code');
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
		getInformationEvent = new GetInformationEvent('vendorinfo', callbacks, dcVendor_id.dataValue);
		getInformationEvent.dispatch();   
	}
}

private function vendorDetailsHandler(resultXml:XML):void
{
	dcTerm_code.dataValue 	= 	 resultXml.children().child('invoice_term_code').toString();
	dcTerm_code.labelValue	=	 resultXml.children().child('invoice_term_code').toString();
	tiVendor_code.dataValue	=	 resultXml.children().child('code').toString();
	dcVendor_id.labelValue	=	 resultXml.children().child('code').toString();
	dcVendor_id.dataValue	=	 resultXml.children().child('id').toString();
	tiBill_code.dataValue	=	 resultXml.children().child('code').toString();

	
	setBilliingAddress(resultXml);
	getDueDate();
	
	// VD 14/03/2011
	if(cbInvoice_type.dataValue.toUpperCase() == 'D')
	{
		if(dtlLine.dgDtl.rows.children().length() > 0)
		{
			dtlLine.dgDtl.rows = new XML('<' + dtlLine.rootNode + '/>');
			calculateGrossAmount();
			updateRecordSummary();
			changeImage();
		}
	}
	else
	{
		if(dtlLineNonEditable.dgDtl.rows.children().length() > 0)
		{
			dtlLineNonEditable.dgDtl.rows = new XML('<' + dtlLineNonEditable.rootNode + '/>');
			calculateGrossAmount();
			updateRecordSummary();
			changeImage();
		}
	}	
}

private function getStoreInfo(store_id:String):void
{
	if(store_id != '' && store_id != null) 
	{
		var callbacks:IResponder = new mx.rpc.Responder(getStoreInfoHandler, null);
		
		getInformationEvent = new GetInformationEvent('companystoreinfo', callbacks, store_id);
		getInformationEvent.dispatch(); 
	}
}

private function getStoreInfoHandler(resultXml:XML):void
{
	dcStore_id.dataValue	=	resultXml.children().child('id').toString()
	dcStore_id.labelValue	=	resultXml.children().child('company_cd').toString()
	tiStore_code.dataValue	=	resultXml.children().child('company_cd').toString()
	setShippingAddress();
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
			if(colName == "discount_amt")
			{
				itemDiscountPerCalculation(rowIndex);
			}
			else if(colName == "item_amt")
			{
				itemPriceCalculation(rowIndex);
			}
			
			itemNetAmountCalculation(rowIndex);
		}
	}
}

private function setGrossAmountNonEditable(event:DetailEvent):void
{
	calculateGrossAmount()
}

private function itemNetAmountCalculation(rowIndex:int , isCalculateGrossAmount:Boolean = true):void
{
	var tempGrid:GenDataGrid = getDtlComponentGrid()
	
	tempGrid.dataProvider[rowIndex].item_qty 	= numericFormatterWithoutPrecesion.format(tempGrid.dataProvider[rowIndex].item_qty)
	tempGrid.dataProvider[rowIndex].item_price = numericFormatter.format(tempGrid.dataProvider[rowIndex].item_price)
	tempGrid.dataProvider[rowIndex].item_amt = numericFormatter.format((tempGrid.dataProvider[rowIndex].item_qty * tempGrid.dataProvider[rowIndex].item_price));
	tempGrid.dataProvider[rowIndex].discount_amt = numericFormatter.format(((tempGrid.dataProvider[rowIndex].item_amt * tempGrid.dataProvider[rowIndex].discount_per)/100));
	tempGrid.dataProvider[rowIndex].net_amt = numericFormatter.format((tempGrid.dataProvider[rowIndex].item_amt - tempGrid.dataProvider[rowIndex].discount_amt));

	if(isCalculateGrossAmount)//it will be false when called from fetchRecordSelectCompleteEventHandler
	{
		calculateGrossAmount();	
	}
}

private function updateRecordSummary(isFromRetrieve:Boolean	=	false):void
{
	var _item_qty:Number = 0;
	var _clear_qty:Number = 0;
	var tempGrid:GenDataGrid = getDtlComponentGrid(isFromRetrieve)
	
	if(tempGrid.dataProvider.length > 0)
	{
		for(var i:int = 0; i < tempGrid.dataProvider.length; i++)
		{
			_item_qty = _item_qty + (Number)(tempGrid.dataProvider[i].item_qty);
			_clear_qty = _clear_qty + (Number)(tempGrid.dataProvider[i].clear_qty);
		}

		lblTotal_items.text = tempGrid.dataProvider.length.toString()
		lblItem_qty.text = _item_qty.toString()
		lblClear_qty.text = _clear_qty.toString() 
	}
	else
	{
		lblTotal_items.text = '0'
		lblItem_qty.text = '0'
		lblClear_qty.text = '0'
	}
}

private function changeImage():void
{
	var tempGrid:GenDataGrid = getDtlComponentGrid()

	if(tempGrid.selectedRow != null)
	{
		image_name = tempGrid.selectedRow["image_thumnail"]
	}
	else
	{
		image_name = null
	}
}

private function calculateGrossAmount():void
{
	var _grossAmount:Number = 0;
	var _taxableAmount:Number = 0;
	var tempGrid:GenDataGrid = getDtlComponentGrid()
	
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

	trFooter.setTotalTaxableAmt(_taxableAmount)
	trFooter.setTotalItemAmt(_grossAmount);		
	calculateFooterAmounts(); 
}

private function calculateFooterAmounts():void
{
	trFooter.calculateFooters();
}

private function itemPriceCalculation(rowIndex:int):void
{
	var tempGrid:GenDataGrid = getDtlComponentGrid()
	
	tempGrid.dataProvider[rowIndex].item_amt = numericFormatter.format(tempGrid.dataProvider[rowIndex].item_amt);
	tempGrid.dataProvider[rowIndex].item_qty = numericFormatterWithoutPrecesion.format(tempGrid.dataProvider[rowIndex].item_qty);
	
	if(tempGrid.dataProvider[rowIndex].item_qty > 0)
	{
		tempGrid.dataProvider[rowIndex].item_price 	= numericFormatter.format(tempGrid.dataProvider[rowIndex].item_amt/ tempGrid.dataProvider[rowIndex].item_qty);
	}
	
	itemNetAmountCalculation(rowIndex);
}

private function itemDiscountPerCalculation(rowIndex:int):void
{
	var tempGrid:GenDataGrid = getDtlComponentGrid()
	
	tempGrid.dataProvider[rowIndex].discount_amt	=	numericFormatter.format(tempGrid.dataProvider[rowIndex].discount_amt);
	tempGrid.dataProvider[rowIndex].item_amt		=	numericFormatter.format(tempGrid.dataProvider[rowIndex].item_amt);
	
	if(tempGrid.dataProvider[rowIndex].item_amt > 0)
	{
		tempGrid.dataProvider[rowIndex].discount_per 	= 	numericFormatter.format(((tempGrid.dataProvider[rowIndex].discount_amt * 100)/tempGrid.dataProvider[rowIndex].item_amt));
	}
	
	itemNetAmountCalculation(rowIndex);
}

override protected function retrieveRecordEventHandler(event:AddEditEvent):void  //after save and prev,next,.....
{
	var recordXml:XML = event.recordXml;
	var dtlXml:XML = XML(recordXml.children().child('purchase_invoice_lines'))
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

	setDtlComponent(recordXml.children().child('trans_type').toString(), 'GRID')

	cbInvoice_type.enabled = false;
	tiBill_code.dataValue	=	 dcVendor_id.labelValue;
	__localModel.trans_date = dfTrans_date.text
	__localModel.account_id	=	dcVendor_id.dataValue;

	var tempGrid:GenDataGrid = getDtlComponentGrid()
	
	if(tempGrid.dataProvider.length > 0)
	{
		tempGrid.selectedIndex = 0
	}
	
	updateRecordSummary(true)
	changeImage()
}

override protected function resetObjectEventHandler():void   //on add buttton press,
{
	invoiceTypeChangeEvent()
			
	//dcStore_id.dataValue = __genModel.user.default_company_id.toString() //to set default store
	 getStoreInfo(__genModel.user.default_company_id.toString());//get default store info
	 setShippingAddress();
	 getAccountPeriod();
	
	dcVendor_id.enabled		=	true;
	cbInvoice_type.enabled	=	true;

	updateRecordSummary();
	changeImage();

	__localModel.trans_date = dfTrans_date.text;
	__localModel.account_id	= '';
}

override protected function fetchRecordSelectCompleteEventHandler(event:FetchRecordEvent):void 
{
	var tempGrid:GenDataGrid = getDtlComponentGrid();

	if(tempGrid.dataProvider.length > 0)
	{
		trFooter.setDiscountPer(Number(tempGrid.dataProvider[0]["hdr_discount_per"].toString()));
		trFooter.setTaxPer(Number(tempGrid.dataProvider[0]["hdr_tax_per"].toString()));
		
		tempGrid.selectedIndex = 0
		for(var i:int = 0; i < tempGrid.dataProvider.length; i++)
		{
			itemNetAmountCalculation(i , false)
		}
		if(tempGrid.dataProvider.length > 0)
		{
			calculateGrossAmount()
		}		
	}

	updateRecordSummary()
	changeImage()
}

override protected function fetchRecordWindowCloseEventHandler(event:FetchRecordEvent):void 
{
	var invoice_type:String = cbInvoice_type.dataValue.toLocaleUpperCase();
	setFetchParameter(invoice_type, 'GRID')
}

private function getDtlComponentGrid(isFromRetrieve:Boolean = false):GenDataGrid
{
	var tempGrid:GenDataGrid;

	if(cbInvoice_type.dataValue.toUpperCase() == 'D')
	{
		dtlLine.dgDtl.rows = new XML('<' + dtlLine.rootNode + '/>');
		tempGrid = dtlLineNonEditable.dgDtl
		tiRef_trans_no.dataValue		=	'';
	}
	else
	{
		dtlLineNonEditable.dgDtl.rows = new XML('<' + dtlLineNonEditable.rootNode + '/>');
		tempGrid = dtlLine.dgDtl;
		if(!isFromRetrieve)
		{
			if(tempGrid.dataProvider.length > 0)
			{
				tiRef_trans_no.dataValue	=	tempGrid.dataProvider[0].ref_trans_no.toString();
			}
			else
			{
				tiRef_trans_no.dataValue		=	'';
			}
		}
	}
	
	return tempGrid;	
}

private function handleBtnGetDataClick(event:Event):void
{
	var invoice_type:String = cbInvoice_type.dataValue.toLocaleUpperCase();
	setFetchParameter(invoice_type, 'BUTTON')

	dtlLine.bcdp.dispatchEvent(new ButtonControlDetailEvent(ButtonControlDetailEvent.FETCH_RECORDS_EVENT));
}
