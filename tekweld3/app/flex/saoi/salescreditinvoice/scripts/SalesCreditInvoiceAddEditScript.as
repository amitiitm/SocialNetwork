import invn.transactionBOM.components.TransactionBOM;
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
import saoi.salescreditinvoice.SalesCreditInvoiceModelLocator;

private var numericFormatter:GenNumberFormatter 				= 	new GenNumberFormatter();
private var numericFormatterFourPrecesion:GenNumberFormatter	=	new GenNumberFormatter();
private var numericFormatterThreePrecesion:GenNumberFormatter	=	new GenNumberFormatter();
private var numericFormatterWithoutPrecesion:GenNumberFormatter	=	new GenNumberFormatter();
private var getInformationEvent:GetInformationEvent;
private var isSreenCreationComplete:Boolean	=	false;
private var isSerial_no_pk:String = 'Y';
private var dtlLineRowIndex:int;

[Bindable]
private var __localModel:SalesCreditInvoiceModelLocator = (SalesCreditInvoiceModelLocator)(GenModelLocator.getInstance().activeModelLocator);

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
	
	dtlLine.bcdp.btnEdit.visible = false;
	
	__localModel.trans_date = dfTrans_date.text	
	getAccountPeriod();
	isSreenCreationComplete	=	true;
	tnDetail.selectedChild = vbDetail;
}

private function invoiceTypeChangeEvent():void
{
	setDtlComponent(cbTrans_type.dataValue, 'GRID')

	dtlLine.dgDtl.rows = new XML('<' + dtlLine.rootNode + '/>');
	dtlLineNonEditable.dgDtl.rows = new XML('<' + dtlLineNonEditable.rootNode + '/>');
	updateRecordSummary()
}

private function setDtlComponent(invoiceType:String, fetch_type:String):void
{
	if(invoiceType.toUpperCase() == 'I')
	{
			dtlLine.btnFetchVisible				=	true
			dtlLine.btnFetchWithDetailVisible	=	false;
			btnGetData.enabled 					= 	true	
		
			vsDtl.selectedChild = hbEditable

		dtlLine.updatableFlag = "true"
		dtlLineNonEditable.updatableFlag = "false"		
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
	if(invoice_type == 'I')
	{
		if(fetch_type.toLocaleUpperCase() == 'GRID')
		{
			dtlLine.fetchDetailDataServiceID = "fetch_open_invoices";
			dtlLine.fetchDetailFormatServiceID = 'fetchRecordFormat'
			dtlLine.fetchGetSelectedDetailServiceID = ""
			dtlLine.title = "Invoices (Lines)"
			dtlLine.isFetchMultipalSelected = true;
			dtlLine.isDetailRequired = false;
			dtlLine.isOverrideDetail = false;
			
			dtlLine.transactionDetailServiceID="get_si_bom"
			
			isSerial_no_pk = 'Y'
			createMapping()
		}
		else
		{
			dtlLine.fetchDetailDataServiceID = "fetch_open_invoices_hdr";
			dtlLine.fetchDetailFormatServiceID = 'fetchInvoiceHdrFormat'
			dtlLine.fetchGetSelectedDetailServiceID = "fetchGetSelectedInvoiceServiceID"
			dtlLine.title = "Invoices"
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

	mappingArrCol.getItemAt(3).isPrimaryKey = isSerial_no_pk;
	
	mappingArrCol.addItem({source: 'catalog_item_id',			target: 'catalog_item_id' ,			isPrimaryKey:'Y',	updatable:'N'})
	mappingArrCol.addItem({source: 'catalog_item_code',			target: 'catalog_item_code' ,		isPrimaryKey:'Y',	updatable:'N'})

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

	if(__genModel.masterData.child('jewelry_default').bom_in_transaction.value.toString() == 'Y')
	{
							
	}
	else
	{
		mappingArrCol.addItem({source: 'image_thumnail',		target: 'image_thumnail',	isPrimaryKey:'N',	updatable:'N'})	
	}

	
	mappingArrCol.addItem({source: 'customer_sku_no',			target: 'customer_sku_no',		isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'vendor_sku_no',				target: 'vendor_sku_no',		isPrimaryKey:'N',	updatable:'N'})
	
	//id, transFlag , serialNo will be added in FetchRecordSelectCommand because it is commmon in all screens
	dtlLine.fetchMapingArrCol	=	mappingArrCol;
}

private function getAccountPeriod():void
{
	if(dfTrans_date.text != '' && dfTrans_date.text != null)
	{
		var callbacks:IResponder = new mx.rpc.Responder(getAccountPeriodHandler, null);
		
		getInformationEvent = new GetInformationEvent('accountperiod', callbacks, dfTrans_date.text);
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

private function getCustomerDetails():void
{
	dcCustomer_shipping_id.filterKeyValue = dcCustomer_id.dataValue
	
	__localModel.account_id	=	dcCustomer_id.dataValue;

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
	dcCustomer_id.dataValue		=	 resultXml.children().child('id').toString()
	dcCustomer_id.labelValue	=	 resultXml.children().child('code').toString()
	tiCustomer_code.dataValue	=	 resultXml.children().child('code').toString()
	
	if(dtlLine.dgDtl.rows.children().length() > 0)
	{
		dtlLine.dgDtl.rows = new XML('<' + dtlLine.rootNode + '/>');
		calculateGrossAmount();
		updateRecordSummary();
		changeImage();
	}	

	if(dtlLineNonEditable.dgDtl.rows.children().length()>0)
	{
		dtlLineNonEditable.dgDtl.rows = new XML('<' + dtlLineNonEditable.rootNode + '/>');
		calculateGrossAmount();
		updateRecordSummary();
		changeImage();
	}	
}

private function setValue(customerXml:XML):void
{
	dcCustomer_shipping_id.dataValue = customerXml.children().child('customer_shipping_id').toString();
	dcCustomer_shipping_id.labelValue= customerXml.children().child('customer_shipping_code').toString();
	tiCustomer_shipping_code.dataValue	= customerXml.children().child('customer_shipping_code').toString(); 
 	dcShipping_code.dataValue = customerXml.children().child('shipping_code').toString();
 	dcShipping_code.labelValue = customerXml.children().child('shipping_code').toString();  
	dcTerm_code.dataValue = customerXml.children().child('term_code').toString();
	dcTerm_code.labelValue= customerXml.children().child('term_code').toString();
	
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
	tiShip_nm.text = customerXml.children().child('name').toString();
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
	tiBill_nm.text = customerXml.children().child('bill_name').toString();
	tiBill_address1.text = customerXml.children().child('bill_address1').toString();
	tiBill_address2.text = customerXml.children().child('bill_address2').toString();
	tiBill_city.text = customerXml.children().child('bill_city').toString();
	tiBill_fax1.text = customerXml.children().child('bill_fax').toString();
	tiBill_phone1.text = customerXml.children().child('bill_phone').toString();
	tiBill_state.text = customerXml.children().child('bill_state').toString();
	tiBill_zip.text = customerXml.children().child('bill_zip').toString();	
	tiBill_country.text = customerXml.children().child('bill_country').toString();

}

private function setGrossAmount(event:EditableDetailEvent):void
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
	
	tempGrid.dataProvider[rowIndex].discount_amt = numericFormatter.format(tempGrid.dataProvider[rowIndex].discount_amt);
	tempGrid.dataProvider[rowIndex].item_amt = numericFormatter.format(tempGrid.dataProvider[rowIndex].item_amt);
	
	if(tempGrid.dataProvider[rowIndex].item_amt > 0)
	{
		tempGrid.dataProvider[rowIndex].discount_per = numericFormatter.format(((tempGrid.dataProvider[rowIndex].discount_amt * 100)/tempGrid.dataProvider[rowIndex].item_amt));
	}
	
	itemNetAmountCalculation(rowIndex);
}	
//------------------------------------------------------------------------------------

override protected function retrieveRecordEventHandler(event:AddEditEvent):void  //after save and prev,next,.....
{
	var recordXml:XML = event.recordXml;
	var dtlXml:XML = XML(recordXml.children().child('sales_credit_invoice_lines'))
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
	
	trFooter.setTotalTaxableAmt(_taxableAmount);
	
	setDtlComponent(recordXml.children().child('trans_type').toString(), 'GRID')

	dcCustomer_shipping_id.filterKeyValue = dcCustomer_id.dataValue;
	dcCustomer_shipping_id.dataValue = recordXml.children()["customer_shipping_id"];
	tiBill_code.dataValue			 = dcCustomer_id.labelValue
	
	dcCustomer_id.enabled = false;
	cbTrans_type.enabled = false;

	__localModel.trans_date = dfTrans_date.text
	__localModel.account_id	=	dcCustomer_id.dataValue;

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

	getAccountPeriod();

	dcCustomer_shipping_id.filterKeyValue = "" // BECAUSE LOOKUP SHOULD EMPTY NOW
	dcCustomer_id.enabled = true;
	cbTrans_type.enabled = true;

	updateRecordSummary()
	changeImage()

	__localModel.trans_date = dfTrans_date.text;
	__localModel.account_id	=	'';
}

override protected function fetchRecordSelectCompleteEventHandler(event:FetchRecordEvent):void   //on add buttton press,
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
	var invoice_type:String = cbTrans_type.dataValue.toLocaleUpperCase();
	setFetchParameter(invoice_type, 'GRID')
}

private function getDtlComponentGrid(isFromRetrieve:Boolean	=	false):GenDataGrid
{
	var tempGrid:GenDataGrid;

	if(cbTrans_type.dataValue.toUpperCase() == 'D')
	{
		dtlLine.dgDtl.rows = new XML('<' + dtlLine.rootNode + '/>');
		tempGrid = dtlLineNonEditable.dgDtl;
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
	var invoice_type:String = cbTrans_type.dataValue.toLocaleUpperCase();
	setFetchParameter(invoice_type, 'BUTTON')

	dtlLine.bcdp.dispatchEvent(new ButtonControlDetailEvent(ButtonControlDetailEvent.FETCH_RECORDS_EVENT));
}

private function refreshShip(event:Event):void
{
	//dcCustomer_shipping_id.btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
}