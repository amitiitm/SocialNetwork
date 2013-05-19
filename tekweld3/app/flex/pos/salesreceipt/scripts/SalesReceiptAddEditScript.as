import business.events.GetInformationEvent;
import business.events.PreSaveEvent;

import com.generic.components.SimilarItems;
import com.generic.events.AddEditEvent;
import com.generic.events.ButtonControlDetailEvent;
import com.generic.events.EditableDetailEvent;
import com.generic.events.FetchRecordEvent;
import com.generic.genclass.GenNumberFormatter;

import flash.events.Event;

import model.GenModelLocator;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.managers.PopUpManager;
import mx.rpc.IResponder;

import pos.salesreceipt.SalesReceiptModelLocator;
import pos.salesreceipt.components.SalesHeldReceipts;

[Bindable]
public var isPaymentComplete:Boolean =	false;
[Bindable]
public var __genModel:GenModelLocator = GenModelLocator.getInstance();

private var __localModel:SalesReceiptModelLocator = (SalesReceiptModelLocator)(GenModelLocator.getInstance().activeModelLocator);

private var getInformationEvent:GetInformationEvent;
private var childGridTag:String;
private var numericFormatter:GenNumberFormatter 				= 	new GenNumberFormatter();
private var numericFormatterFourPrecesion:GenNumberFormatter	=	new GenNumberFormatter();
private var numericFormatterThreePrecesion:GenNumberFormatter	=	new GenNumberFormatter();
private var numericFormatterWithoutPrecesion:GenNumberFormatter	=	new GenNumberFormatter();
private var totalPayment:Number = 0.00
private var totalReturn:Number = 0.00
private var totalAmtToTake:Number = 0.00
private var isHoldButtonClicked:Boolean = false;
private var isFindAllButtonClicked:Boolean = false;
private var isFindByReceiptButtonClicked:Boolean = false;
private var isFindByRepairButtonClicked:Boolean = false;
private var isFindByOrderButtonClicked:Boolean = false;
private var preSaveEvent:PreSaveEvent;

private var findAllMappingArrCol:ArrayCollection;
private var findByReceiptMappingArrCol:ArrayCollection;
private var findByRepairMappingArrCol:ArrayCollection;
private var findByOrderMappingArrCol:ArrayCollection;

[Bindable]
private var image_name:String;

private var dtlLineRowIndex:int;
private var searchFlag:String;
private var gridContains:String = 'NOTHING';
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
	
	childGridTag = dtlLine.rootNode.slice(0, dtlLine.rootNode.length -1)
	dtlLine.bcdp.btnFetch.visible = false;	
	
	getAccountPeriod()
	
	createMapping();
	createMappingForReceiptItems();
	createMappingForRepairItems();
	createMappingForOrderItems();		
}

private function HoldReceiptClickHandler(event:Event):void
{
	if(String(event.target.label).toUpperCase()	==	'HOLD RECEIPT')
	{
		isHoldButtonClicked	= true;
				
		cbTrans_flag.dataValue = 'H'
		
		preSaveEvent = new PreSaveEvent();
		preSaveEvent.dispatch();
	}
	else//means click on Held Receipt
	{
		var heldReceiptComponent:SalesHeldReceipts
		heldReceiptComponent = SalesHeldReceipts(PopUpManager.createPopUp(this, SalesHeldReceipts, true));
	}	
}

private function calculatePayment():void
{
	totalPayment = 0;
	totalReturn = 0;
	totalAmtToTake = 0; 
	
	totalPayment = Number(tiCashPayment.text) + Number(tiAccountPayment.text) + Number(tiCheckPayment.text) + Number(tiCreditPayment.text);
	totalReturn = Number(tiCashReturn.text) + Number(tiAccountRefund.text) + Number(tiCheckReturn.text) + Number(tiCreditRefund.text);
	
	if(tiDeposit.text	==	'' ||	tiDeposit.text	==	'NaN')
	{
		tiDeposit.text	=	'0.00';
	}
	totalAmtToTake = Number(tiNet_amt.text) - Number(tiDeposit.text);
		
	tiTotalPayment.text = numericFormatter.format(totalPayment.toString());
	tiTotalRefund.text = numericFormatter.format(totalReturn.toString());
	
	if((totalPayment - totalReturn) == totalAmtToTake)  // it means payment complete
	{
		// Alert.show('complete');
		isPaymentComplete = true;
		tiDueAmt.text = '0.00'
		tiChangeDue.text = '0.00'
	}
	else if((totalAmtToTake + totalReturn) > totalPayment ) //it means payment is due
	{
		// Alert.show('payment due');
		isPaymentComplete = false;
		tiDueAmt.text = numericFormatter.format((String((totalAmtToTake + totalReturn) - totalPayment)))	
		tiChangeDue.text = '0.00'
	}
	else if((totalAmtToTake + totalReturn) < totalPayment ) //it means change is due
	{
		// Alert.show('change due');
		isPaymentComplete = false;
		tiChangeDue.text = numericFormatter.format((String(totalPayment - (totalAmtToTake + totalReturn))))
		tiDueAmt.text = '0.00'
	}
	else
	{
		Alert.show('something is going wrong');
	}
}

private function findSearchClickHandler():void
{
	isFindByRepairButtonClicked = false;
	isFindByReceiptButtonClicked = false;
	isFindByOrderButtonClicked	=	false;
	isFindAllButtonClicked = true;

	dtlLine.fetchMapingArrCol = findAllMappingArrCol;
	dtlLine.title = "Find Items"
	dtlLine.dc_id = tiFetchItems
	dtlLine.fetchDetailFormatServiceID = "fetchRecordFormat"
	dtlLine.fetchDetailDataServiceID = "fetch_all_items"
	
	dtlLine.bcdp.dispatchEvent(new ButtonControlDetailEvent('fetchRecordsEvent'));
	changeToItemMode();
}
private function cbRefTypeChangeEvent():void
{
	switch(cbRefType.dataValue)
	{
		case 'ORD' : 
				tiReceiptNo.text	=	''
				tiReceiptNo.enabled	=	false;
				break;
		case 'RPR':
				tiReceiptNo.text	=	''
				tiReceiptNo.enabled	=	false;
				break;
		case 'REC':
				tiReceiptNo.text	=	''
				tiReceiptNo.enabled	=	true;
				break;
	}	
}
private function btnFindClickHandler():void
{
	switch(cbRefType.dataValue)
	{
		case 'ORD' : 
				if(isFindValid('SPECIALORDERITEMS'))
				{
					findOrderClickHandler();	
				}
				else
				{
					Alert.show('You have already selected other type of items.');
				}
				
				break;
		case 'RPR':
				if(isFindValid('REPAIRITEMS'))
				{
					findRepairClickHandler();	
				}
				else
				{
					Alert.show('You have already selected other type of items.');
				}
				
				break;
		case 'REC':
				if(isFindValid('RECEIPTITEMS'))
				{
					findReceiptClickHandler();	
				}
				else
				{
					Alert.show('You have already selected other type of items.');
				}
				
				break;
	}	
}
private function findReceiptClickHandler():void
{
	isFindByRepairButtonClicked = false;
	isFindByReceiptButtonClicked = true;
	isFindByOrderButtonClicked	=	false;
	isFindAllButtonClicked = false;
	
	dtlLine.fetchMapingArrCol = findByReceiptMappingArrCol;
	dtlLine.title = "Receipt #" + tiReceiptNo.text
	dtlLine.dc_id = tiReceiptNo
	dtlLine.fetchDetailFormatServiceID = "fetchReceiptItemsFormat"
	dtlLine.fetchDetailDataServiceID = "fetch_receipt_items"
	dtlLine.isFetchMultipalSelected	 = true;	
	dtlLine.bcdp.dispatchEvent(new ButtonControlDetailEvent('fetchRecordsEvent'));	
}
private function findRepairClickHandler():void
{
	isFindByRepairButtonClicked = true;
	isFindByReceiptButtonClicked = false;
	isFindByOrderButtonClicked	=	false;
	isFindAllButtonClicked = false;
	
	dtlLine.fetchMapingArrCol = findByRepairMappingArrCol;
	dtlLine.title = "Repair Items of " + dcCustomer_id.text
	dtlLine.dc_id = dcCustomer_id//tiReceiptNo
	dtlLine.fetchDetailFormatServiceID = "fetchRepairItemsFormat"
	dtlLine.fetchDetailDataServiceID = "fetch_repair_items"
	dtlLine.isFetchMultipalSelected	 = true;
	dtlLine.bcdp.dispatchEvent(new ButtonControlDetailEvent('fetchRecordsEvent'));	
}
private function findOrderClickHandler():void
{
	isFindByRepairButtonClicked = false;
	isFindByReceiptButtonClicked = false;
	isFindByOrderButtonClicked	=	true;
	isFindAllButtonClicked = false;
	
	dtlLine.fetchMapingArrCol = findByOrderMappingArrCol;
	dtlLine.title = "Order of " + dcCustomer_id.text
	dtlLine.dc_id = dcCustomer_id//tiReceiptNo
	dtlLine.fetchDetailFormatServiceID = "fetchOrderItemsFormat"
	dtlLine.fetchDetailDataServiceID = "fetch_order_items"
	dtlLine.isFetchMultipalSelected	 = true;
	dtlLine.bcdp.dispatchEvent(new ButtonControlDetailEvent('fetchRecordsEvent'));		
}

private function changeToItemMode():void
{
	tnDetail.selectedIndex = 0;
}

private function changeToPaymentMode():void
{
	tnDetail.selectedIndex = 2;	
}

private function changeToAddressMode():void
{
	tnDetail.selectedIndex = 1;	
}

private function createMapping():void
{
 	findAllMappingArrCol = new ArrayCollection();
	
	findAllMappingArrCol.addItem({source: 'id',					target: 'catalog_item_id',	isPrimaryKey:'N',	updatable:'N'})
	findAllMappingArrCol.addItem({source: 'store_code',			target: 'catalog_item_code',isPrimaryKey:'N',	updatable:'N'})
	findAllMappingArrCol.addItem({source: 'name',				target: 'item_name',		isPrimaryKey:'N',	updatable:'N'})
	findAllMappingArrCol.addItem({source: 'sale_description',	target: 'item_description' ,isPrimaryKey:'N',	updatable:'N'})
	findAllMappingArrCol.addItem({source: 'taxable',			target: 'taxable' ,			isPrimaryKey:'N',	updatable:'N'})
	findAllMappingArrCol.addItem({source: 'price',				target: 'item_price' ,		isPrimaryKey:'N',	updatable:'N'})
	findAllMappingArrCol.addItem({source: 'B',					target: 'item_qty',			isPrimaryKey:'N',	updatable:'N'})
	findAllMappingArrCol.addItem({source: 'B',					target: 'clear_qty',		isPrimaryKey:'N',	updatable:'N'})
	findAllMappingArrCol.addItem({source: 'B',					target: 'item_amt',			isPrimaryKey:'N',	updatable:'N'})
	findAllMappingArrCol.addItem({source: 'B',					target: 'discount_per',		isPrimaryKey:'N',	updatable:'N'})
	findAllMappingArrCol.addItem({source: 'B',					target: 'discount_amt',		isPrimaryKey:'N',	updatable:'N'})
	findAllMappingArrCol.addItem({source: 'B',					target: 'tax_per',			isPrimaryKey:'N',	updatable:'N'})
	findAllMappingArrCol.addItem({source: 'B',					target: 'tax_amt',			isPrimaryKey:'N',	updatable:'N'})
	findAllMappingArrCol.addItem({source: 'B',					target: 'net_amt',			isPrimaryKey:'N',	updatable:'N'})
	findAllMappingArrCol.addItem({source: 'B',					target: 'pos_invoice_id',	isPrimaryKey:'N',	updatable:'N'})
	findAllMappingArrCol.addItem({source: 'B',					target: 'ref_trans_id',isPrimaryKey:'N',	updatable:'N'})
	findAllMappingArrCol.addItem({source: 'B',					target: 'trans_type',		isPrimaryKey:'N',	updatable:'N'})
	findAllMappingArrCol.addItem({source: 'image_thumnail',		target: 'image_thumnail',	isPrimaryKey:'N',	updatable:'N'})

	// VD 20100804
	findAllMappingArrCol.addItem({source: 'packet_require_yn',	target: 'packet_require_yn', 		isPrimaryKey:'N',	updatable:'N'})
	findAllMappingArrCol.addItem({source: 'item_type',			target: 'item_type', 				isPrimaryKey:'N',	updatable:'N'})
	findAllMappingArrCol.addItem({source: 'B',					target: 'catalog_item_packet_code', isPrimaryKey:'N',	updatable:'N'})
	findAllMappingArrCol.addItem({source: 'B', 					target: 'catalog_item_packet_id', 	isPrimaryKey:'N',	updatable:'N'})
	
	//id, transFlag , serialNo will be added in FetchRecordSelectCommand because it is commmon in all screens
	//we will assign mappingArrayCollection at the time of button click.
}

private function createMappingForRepairItems():void
{
	findByRepairMappingArrCol = new ArrayCollection();
	
	findByRepairMappingArrCol.addItem({source: 'trans_no',				target: 'ref_trans_no',		isPrimaryKey:'Y',	updatable:'N'})
	findByRepairMappingArrCol.addItem({source: 'serial_no',				target: 'ref_serial_no',	isPrimaryKey:'Y',	updatable:'N'})	
	findByRepairMappingArrCol.addItem({source: 'trans_type',			target: 'ref_type',			isPrimaryKey:'N',	updatable:'N'})
	findByRepairMappingArrCol.addItem({source: 'trans_bk',				target: 'ref_trans_bk',		isPrimaryKey:'N',	updatable:'N'})
	findByRepairMappingArrCol.addItem({source: 'trans_id',				target: 'ref_trans_id',		isPrimaryKey:'N',	updatable:'N'})
	findByRepairMappingArrCol.addItem({source: 'trans_date',			target: 'ref_trans_date',			isPrimaryKey:'N',	updatable:'N'})


	findByRepairMappingArrCol.addItem({source: 'catalog_item_id',			target: 'catalog_item_id',	isPrimaryKey:'N',	updatable:'N'})
	findByRepairMappingArrCol.addItem({source: 'catalog_item_code',			target: 'catalog_item_code',isPrimaryKey:'N',	updatable:'N'})
	findByRepairMappingArrCol.addItem({source: 'item_name',					target: 'item_name',		isPrimaryKey:'N',	updatable:'N'})
	findByRepairMappingArrCol.addItem({source: 'item_description',			target: 'item_description' ,isPrimaryKey:'N',	updatable:'N'})
	findByRepairMappingArrCol.addItem({source: 'taxable',					target: 'taxable' ,			isPrimaryKey:'N',	updatable:'N'})
	findByRepairMappingArrCol.addItem({source: 'item_price',				target: 'item_price' ,		isPrimaryKey:'N',	updatable:'N'})
	findByRepairMappingArrCol.addItem({source: 'item_qty',					target: 'item_qty',			isPrimaryKey:'N',	updatable:'N'})
	findByRepairMappingArrCol.addItem({source: 'item_amt',					target: 'item_amt',			isPrimaryKey:'N',	updatable:'N'})
	findByRepairMappingArrCol.addItem({source: 'discount_per',				target: 'discount_per',		isPrimaryKey:'N',	updatable:'N'})
	findByRepairMappingArrCol.addItem({source: 'discount_amt',				target: 'discount_amt',		isPrimaryKey:'N',	updatable:'N'})
	findByRepairMappingArrCol.addItem({source: 'tax_per',					target: 'tax_per',			isPrimaryKey:'N',	updatable:'N'})
	findByRepairMappingArrCol.addItem({source: 'tax_amt',					target: 'tax_amt',			isPrimaryKey:'N',	updatable:'N'})
	findByRepairMappingArrCol.addItem({source: 'net_amt',					target: 'net_amt',			isPrimaryKey:'N',	updatable:'N'})
	findByRepairMappingArrCol.addItem({source: 'deposit_amt',				target: 'deposit_amt',			isPrimaryKey:'N',	updatable:'N'})


			
	findByRepairMappingArrCol.addItem({source: 'B',							target: 'pos_invoice_id',	isPrimaryKey:'N',	updatable:'N'})
	findByRepairMappingArrCol.addItem({source: 'B',							target: 'trans_type',		isPrimaryKey:'N',	updatable:'N'})
	findByRepairMappingArrCol.addItem({source: 'B',							target: 'clear_qty',		isPrimaryKey:'N',	updatable:'N'})
	findByRepairMappingArrCol.addItem({source: 'image_thumnail',			target: 'image_thumnail',	isPrimaryKey:'N',	updatable:'N'})	


	findByRepairMappingArrCol.addItem({source: 'packet_require_yn',			target: 'packet_require_yn', 		isPrimaryKey:'N',	updatable:'N'})
	findByRepairMappingArrCol.addItem({source: 'item_type',					target: 'item_type', 				isPrimaryKey:'N',	updatable:'N'})
	findByRepairMappingArrCol.addItem({source: 'catalog_item_packet_code',	target: 'catalog_item_packet_code', isPrimaryKey:'N',	updatable:'N'})
	findByRepairMappingArrCol.addItem({source: 'catalog_item_packet_id', 	target: 'catalog_item_packet_id', 	isPrimaryKey:'N',	updatable:'N'})

	//id, transFlag , serialNo will be added in FetchRecordSelectCommand because it is commmon in all screens
	//we will assign mappingArrayCollection at the time of button click.	
	//ref_trans_no is the receipt# for this returning item 
}
private function createMappingForOrderItems():void
{
	findByOrderMappingArrCol = new ArrayCollection();
	
	findByOrderMappingArrCol.addItem({source: 'trans_no',					target: 'ref_trans_no',		isPrimaryKey:'Y',	updatable:'N'})
	findByOrderMappingArrCol.addItem({source: 'serial_no',					target: 'ref_serial_no',	isPrimaryKey:'Y',	updatable:'N'})	
	findByOrderMappingArrCol.addItem({source: 'trans_type',					target: 'ref_type',			isPrimaryKey:'N',	updatable:'N'})
	findByOrderMappingArrCol.addItem({source: 'trans_bk',					target: 'ref_trans_bk',		isPrimaryKey:'N',	updatable:'N'})
	findByOrderMappingArrCol.addItem({source: 'trans_id',					target: 'ref_trans_id',		isPrimaryKey:'N',	updatable:'N'})
	findByOrderMappingArrCol.addItem({source: 'trans_date',					target: 'ref_trans_date',			isPrimaryKey:'N',	updatable:'N'})
	
	findByOrderMappingArrCol.addItem({source: 'catalog_item_id',			target: 'catalog_item_id',	isPrimaryKey:'N',	updatable:'N'})
	findByOrderMappingArrCol.addItem({source: 'catalog_item_code',			target: 'catalog_item_code',isPrimaryKey:'N',	updatable:'N'})
	findByOrderMappingArrCol.addItem({source: 'item_name',					target: 'item_name',		isPrimaryKey:'N',	updatable:'N'})
	findByOrderMappingArrCol.addItem({source: 'item_description',			target: 'item_description' ,isPrimaryKey:'N',	updatable:'N'})
	findByOrderMappingArrCol.addItem({source: 'taxable',					target: 'taxable' ,			isPrimaryKey:'N',	updatable:'N'})
	findByOrderMappingArrCol.addItem({source: 'item_price',					target: 'item_price' ,		isPrimaryKey:'N',	updatable:'N'})
	findByOrderMappingArrCol.addItem({source: 'item_qty',					target: 'item_qty',			isPrimaryKey:'N',	updatable:'N'})
	findByOrderMappingArrCol.addItem({source: 'item_amt',					target: 'item_amt',			isPrimaryKey:'N',	updatable:'N'})
	findByOrderMappingArrCol.addItem({source: 'discount_per',				target: 'discount_per',		isPrimaryKey:'N',	updatable:'N'})
	findByOrderMappingArrCol.addItem({source: 'discount_amt',				target: 'discount_amt',		isPrimaryKey:'N',	updatable:'N'})
	findByOrderMappingArrCol.addItem({source: 'tax_per',					target: 'tax_per',			isPrimaryKey:'N',	updatable:'N'})
	findByOrderMappingArrCol.addItem({source: 'tax_amt',					target: 'tax_amt',			isPrimaryKey:'N',	updatable:'N'})
	findByOrderMappingArrCol.addItem({source: 'net_amt',					target: 'net_amt',			isPrimaryKey:'N',	updatable:'N'})
	findByOrderMappingArrCol.addItem({source: 'deposit_amt',				target: 'deposit_amt',			isPrimaryKey:'N',	updatable:'N'})
				
	findByOrderMappingArrCol.addItem({source: 'B',							target: 'pos_invoice_id',	isPrimaryKey:'N',	updatable:'N'})
	findByOrderMappingArrCol.addItem({source: 'B',							target: 'trans_type',		isPrimaryKey:'N',	updatable:'N'})
	findByOrderMappingArrCol.addItem({source: 'B',							target: 'clear_qty',		isPrimaryKey:'N',	updatable:'N'})
	findByOrderMappingArrCol.addItem({source: 'image_thumnail',				target: 'image_thumnail',	isPrimaryKey:'N',	updatable:'N'})	

	
	findByOrderMappingArrCol.addItem({source: 'packet_require_yn',			target: 'packet_require_yn', 		isPrimaryKey:'N',	updatable:'N'})
	findByOrderMappingArrCol.addItem({source: 'item_type',					target: 'item_type', 				isPrimaryKey:'N',	updatable:'N'})
	findByOrderMappingArrCol.addItem({source: 'catalog_item_packet_code',	target: 'catalog_item_packet_code', isPrimaryKey:'N',	updatable:'N'})
	findByOrderMappingArrCol.addItem({source: 'catalog_item_packet_id', 	target: 'catalog_item_packet_id', 	isPrimaryKey:'N',	updatable:'N'})

	//id, transFlag , serialNo will be added in FetchRecordSelectCommand because it is commmon in all screens
	//we will assign mappingArrayCollection at the time of button click.	
	//ref_trans_no is the receipt# for this returning item 
}
private function createMappingForReceiptItems():void
{
	findByReceiptMappingArrCol = new ArrayCollection();
	
	findByReceiptMappingArrCol.addItem({source: 'trans_no',				target: 'ref_trans_no',			isPrimaryKey:'Y',	updatable:'N'})
	findByReceiptMappingArrCol.addItem({source: 'serial_no',			target: 'ref_serial_no',	isPrimaryKey:'Y',	updatable:'N'})
	
	findByReceiptMappingArrCol.addItem({source: 'pos_invoice_id',		target: 'ref_trans_id',isPrimaryKey:'N',	updatable:'N'})
	findByReceiptMappingArrCol.addItem({source: 'catalog_item_id',		target: 'catalog_item_id',	isPrimaryKey:'N',	updatable:'N'})
	findByReceiptMappingArrCol.addItem({source: 'catalog_item_code',	target: 'catalog_item_code',isPrimaryKey:'N',	updatable:'N'})
	findByReceiptMappingArrCol.addItem({source: 'item_name',			target: 'item_name',		isPrimaryKey:'N',	updatable:'N'})
	findByReceiptMappingArrCol.addItem({source: 'item_description',		target: 'item_description' ,isPrimaryKey:'N',	updatable:'N'})
	findByReceiptMappingArrCol.addItem({source: 'taxable',				target: 'taxable' ,			isPrimaryKey:'N',	updatable:'N'})
	findByReceiptMappingArrCol.addItem({source: 'item_price',			target: 'item_price' ,		isPrimaryKey:'N',	updatable:'N'})
	findByReceiptMappingArrCol.addItem({source: 'return_qty',			target: 'item_qty',			isPrimaryKey:'N',	updatable:'N'})
	findByReceiptMappingArrCol.addItem({source: 'return_amt',			target: 'item_amt',			isPrimaryKey:'N',	updatable:'N'})
	findByReceiptMappingArrCol.addItem({source: 'discount_per',			target: 'discount_per',		isPrimaryKey:'N',	updatable:'N'})
	findByReceiptMappingArrCol.addItem({source: 'return_discount',		target: 'discount_amt',		isPrimaryKey:'N',	updatable:'N'})
	findByReceiptMappingArrCol.addItem({source: 'tax_per',				target: 'tax_per',			isPrimaryKey:'N',	updatable:'N'})
	findByReceiptMappingArrCol.addItem({source: 'return_tax',			target: 'tax_amt',			isPrimaryKey:'N',	updatable:'N'})
	findByReceiptMappingArrCol.addItem({source: 'return_net_amt',		target: 'net_amt',			isPrimaryKey:'N',	updatable:'N'})

		
	findByReceiptMappingArrCol.addItem({source: 'B',					target: 'pos_invoice_id',	isPrimaryKey:'N',	updatable:'N'})
	findByReceiptMappingArrCol.addItem({source: 'B',					target: 'trans_type',		isPrimaryKey:'N',	updatable:'N'})
	findByReceiptMappingArrCol.addItem({source: 'B',					target: 'clear_qty',		isPrimaryKey:'N',	updatable:'N'})
	findByReceiptMappingArrCol.addItem({source: 'image_thumnail',		target: 'image_thumnail',	isPrimaryKey:'N',	updatable:'N'})	

	// VD 20100804
	findByReceiptMappingArrCol.addItem({source: 'packet_require_yn',		target: 'packet_require_yn', 		isPrimaryKey:'N',	updatable:'N'})
	findByReceiptMappingArrCol.addItem({source: 'item_type',				target: 'item_type', 				isPrimaryKey:'N',	updatable:'N'})
	findByReceiptMappingArrCol.addItem({source: 'catalog_item_packet_code',	target: 'catalog_item_packet_code', isPrimaryKey:'N',	updatable:'N'})
	findByReceiptMappingArrCol.addItem({source: 'catalog_item_packet_id', 	target: 'catalog_item_packet_id', 	isPrimaryKey:'N',	updatable:'N'})

	//id, transFlag , serialNo will be added in FetchRecordSelectCommand because it is commmon in all screens
	//we will assign mappingArrayCollection at the time of button click.	
	//ref_trans_no is the receipt# for this returning item 
}
private function removeOrderRepairOrder():void
{
	var rows:XML	=	dtlLine.dgDtl.rows.copy();
	var isDeleteAnyRow:Boolean	=	false;
	for(var i:int = 0 ;i < rows.children().length() ; i++)
	{
		if(rows.children()[i].child('ref_type').toString().toUpperCase() == "ORD" ||  rows.children()[i].child('ref_type').toString().toUpperCase() == "RPR")
		{
			delete rows.children()[i];
			i = i - 1;		
			isDeleteAnyRow	=	true;	
		}
	
	}
	
	if(isDeleteAnyRow)
	{
		dtlLine.dgDtl.rows	=	rows;
		calculateGrossAmount();
	}
}
private function getCustomerDetails():void
{
	//dcShipping_Id.filterKeyValue = dcCustomer_id.dataValue
	
	//delete all orders or repair orders  from grid
	removeOrderRepairOrder();
	
	if(dcCustomer_id.dataValue.toString() == '0' ||  dcCustomer_id.text == '')
	{
		tiAccountPayment.enabled = false;
		tiAccountPayment.text	=	tiAccountPayment.defaultValue;
		tiAccountRefund.text	=	tiAccountRefund.defaultValue;
	}
	else
	{
		tiAccountPayment.enabled	=	true;
	}
	if(dcCustomer_id.text != "" && dcCustomer_id.text != null)
	{
		var callbacks:IResponder = new mx.rpc.Responder(customerDetailsHandler, null);
		
		getInformationEvent	= new GetInformationEvent('customerdetail', callbacks, dcCustomer_id.dataValue, "I");
		getInformationEvent.dispatch();  
	}
	else
	{
		resetShippingAddress();
		resetBillingAddress();
	}
}

private function customerDetailsHandler(resultXml:XML):void
{
	setValue(resultXml);
}

private function handlePacket_codeItemChanged():void
{
	var packet_code:String = tiPacket_code.dataValue;

	changeToItemMode();

	if(packet_code != '')
	{
		var callbacks:IResponder = new mx.rpc.Responder(getPacketDetailsHandlerForTI, null);
		getInformationEvent	= new GetInformationEvent('packetinfo', callbacks, packet_code, dfTrans_date.text, 'Y');
		getInformationEvent.dispatch();
	}
}

private function handleDtlLinePacket_code():void
{
	var packet_code:String = dtlLine.dgDtl.dataProvider[dtlLineRowIndex].catalog_item_packet_code;
	var item_code:String = dtlLine.dgDtl.dataProvider[dtlLineRowIndex].catalog_item_code;

	if(packet_code != '')
	{
		var callbacks:IResponder = new mx.rpc.Responder(getPacketDetailsHandlerForGrid, null);
		getInformationEvent	= new GetInformationEvent('packetinfo', callbacks, packet_code, dfTrans_date.text, 'Y');
		getInformationEvent.dispatch();
	}
	else
	{
		dtlLine.dgDtl.dataProvider[dtlLineRowIndex].catalog_item_packet_id = "";
	}
}

public function getPacketDetailsHandlerForTI(resultXml:XML):void
{
	if(resultXml.children().length() > 0)
	{
		var updatedXml:XML
		searchFlag = 'P'
		dtlLine.dgDtl.rows.appendChild(convertInRequiredFormat(resultXml));
		updatedXml = dtlLine.dgDtl.rows.copy()
		dtlLine.dgDtl.rows = updatedXml
		dcItemId.dataValue = '';
		
		updateRecordSummary();
		calculateGrossAmount();
		setGridItemsStatus('DIRECTITEMS');
	}
}

public function getPacketDetailsHandlerForGrid(resultXml:XML):void
{
	if(resultXml.children().length() > 0)
	{
		dtlLine.dgDtl.dataProvider[dtlLineRowIndex].catalog_item_packet_id = resultXml.children()[0].catalog_item_packet_id.toString();
		dtlLine.dgDtl.dataProvider[dtlLineRowIndex].catalog_item_packet_code = resultXml.children()[0].catalog_item_packet_code.toString();
	
		dtlLine.dgDtl.dataProvider[dtlLineRowIndex].item_qty = "1";
	}
	else
	{
		dtlLine.dgDtl.dataProvider[dtlLineRowIndex].catalog_item_packet_id = "";
		dtlLine.dgDtl.dataProvider[dtlLineRowIndex].catalog_item_packet_code = "";
	}
	updateRecordSummary()
	itemNetAmountCalculation(dtlLineRowIndex)
}

private function getItemDetails():void
{
	changeToItemMode();

	if(dcItemId.dataValue != '')
	{
		var callbacks:IResponder = new mx.rpc.Responder(getItemDetailsHandler, null);

		getInformationEvent	= new GetInformationEvent('iteminfo', callbacks, dcItemId.dataValue, dfTrans_date.text);
		getInformationEvent.dispatch();
	}
}

public function getItemDetailsHandler(resultXml:XML):void
{
	var updatedXml:XML

	searchFlag = 'I'
	dtlLine.dgDtl.rows.appendChild(convertInRequiredFormat(resultXml));
	updatedXml = dtlLine.dgDtl.rows.copy()
	dtlLine.dgDtl.rows = updatedXml
	dcItemId.dataValue = '';

	updateRecordSummary();
	calculateGrossAmount();
	setGridItemsStatus('DIRECTITEMS');
}

private function convertInRequiredFormat(sourceXml:XML):XML
{
	var targetXml:XML = new XML("<"+ childGridTag +"/>")
	
	if(searchFlag == 'P')
	{
		targetXml.catalog_item_id = sourceXml.children()[0].catalog_item_id.toString()
	}
	else
	{
		targetXml.catalog_item_id = dcItemId.dataValue;
	}
	
	targetXml.catalog_item_code = sourceXml.children()[0].store_code.toString()
	
	targetXml.item_name = sourceXml.children()[0].name.toString()
	targetXml.item_description = sourceXml.children()[0].sale_description.toString()
	targetXml.taxable = sourceXml.children()[0].taxable.toString()
	targetXml.item_qty = '1'
	targetXml.clear_qty = ''
	targetXml.item_price = sourceXml.children()[0].price.toString()

	// Vivek
	targetXml.image_thumnail = sourceXml.children()[0].image_thumnail.toString()
	//
		
	targetXml.item_amt = numericFormatter.format(Number(targetXml.item_qty.toString()) * Number(targetXml.item_price.toString()));
	
	targetXml.discount_per = 	sourceXml.children()[0].discount_per.toString()//tiDiscount_per.text;
	targetXml.discount_amt =	sourceXml.children()[0].discount_amt.toString()// numericFormatter.format((Number(targetXml.item_amt.toString()) * Number(tiDiscount_per.text.toString()))/ 100);
	
	/* if(String(targetXml.taxable).toUpperCase() == 'Y')
	{
		targetXml.tax_per = tiTax_per.text;
		targetXml.tax_amt = numericFormatter.format((Number(targetXml.item_amt.toString()) * Number(tiTax_per.text))/ 100);
	}
	else
	{
		targetXml.tax_per = '0.00'
		targetXml.tax_amt = '0.00'
	} */
	
	targetXml.net_amt = numericFormatter.format(Number(targetXml.item_amt.toString()) - Number(targetXml.discount_amt.toString()) + Number(targetXml.tax_amt.toString()));
	
	targetXml.pos_invoice_id = ''
	targetXml.ref_trans_id = ''
	
	targetXml.trans_flag = 'A'
	targetXml.trans_type = 'S'
	targetXml.id = ''

	// VD 20100804
	targetXml.packet_require_yn = sourceXml.children()[0].packet_require_yn.toString();
	targetXml.catalog_item_packet_code = sourceXml.children()[0].catalog_item_packet_code.toString();
	targetXml.catalog_item_packet_id = sourceXml.children()[0].catalog_item_packet_id.toString();
	targetXml.item_type = sourceXml.children()[0].item_type.toString();
	targetXml.searchFlag = searchFlag
	// 
	
	return targetXml;	
}

/* private function setAndCalculateDiscountForAllItems():void
{
	var _grossAmount:Number = 0;

	for(var i:int = 0; i < dtlLine.dgDtl.dataProvider.length; i++)
	{
		dtlLine.dgDtl.dataProvider[i].discount_per = tiDiscount_per.text
		dtlLine.dgDtl.dataProvider[i].discount_amt = numericFormatter.format((Number(dtlLine.dgDtl.dataProvider[i].item_amt.toString()) * Number(tiDiscount_per.text.toString()))/ 100);
		// no need to calculate taxper or taxamt because it will not change
		dtlLine.dgDtl.dataProvider[i].net_amt = numericFormatter.format(Number(dtlLine.dgDtl.dataProvider[i].item_amt.toString()) - Number(dtlLine.dgDtl.dataProvider[i].discount_amt.toString()) + Number(dtlLine.dgDtl.dataProvider[i].tax_amt.toString()));
	}
} */

private function setGrossAmount(event:EditableDetailEvent):void
{
	var colName:String;
	var rowIndex:int;
	
	if(event.dataGridEvent != null)
	{
		colName = DataGridColumn(event.dataGridEvent.currentTarget.columns[event.dataGridEvent.columnIndex]).dataField.toString()
		rowIndex = event.dataGridEvent.rowIndex

		if(dtlLine.dgDtl.dataProvider != null)
		{
			if(colName == "catalog_item_packet_code")
			{
				dtlLineRowIndex = rowIndex;
				handleDtlLinePacket_code();
			}
			if(colName == "discount_amt")
			{
				itemDiscountPerCalculation(rowIndex);
			}
			else if(colName == "item_amt")
			{
				itemPriceCalculation(rowIndex)
			}
			else if(colName == "item_qty" || colName == "item_price" ||  colName == "discount_per")
			{
				itemNetAmountCalculation(rowIndex);
			}
		}
	}
}

private function itemPriceCalculation(rowIndex:int):void
{
	dtlLine.dgDtl.dataProvider[rowIndex].item_amt = numericFormatter.format(dtlLine.dgDtl.dataProvider[rowIndex].item_amt);
	
	dtlLine.dgDtl.dataProvider[rowIndex].item_qty = numericFormatterWithoutPrecesion.format(dtlLine.dgDtl.dataProvider[rowIndex].item_qty);
	
	if(dtlLine.dgDtl.dataProvider[rowIndex].item_qty > 0)
	{
		dtlLine.dgDtl.dataProvider[rowIndex].item_price = numericFormatter.format(dtlLine.dgDtl.dataProvider[rowIndex].item_amt / dtlLine.dgDtl.dataProvider[rowIndex].item_qty);
	}
	
	itemNetAmountCalculation(rowIndex);
}
private function itemDiscountPerCalculation(rowIndex:int):void
{
	dtlLine.dgDtl.dataProvider[rowIndex].discount_amt	=	numericFormatter.format(dtlLine.dgDtl.dataProvider[rowIndex].discount_amt);
	dtlLine.dgDtl.dataProvider[rowIndex].item_amt		=	numericFormatter.format(dtlLine.dgDtl.dataProvider[rowIndex].item_amt);
	
	if(dtlLine.dgDtl.dataProvider[rowIndex].item_amt > 0)
	{
		dtlLine.dgDtl.dataProvider[rowIndex].discount_per 	= 	numericFormatter.format(((dtlLine.dgDtl.dataProvider[rowIndex].discount_amt * 100)/dtlLine.dgDtl.dataProvider[rowIndex].item_amt));
	}
	
	itemNetAmountCalculation(rowIndex);
}
private function itemNetAmountCalculation(rowIndex:int, isCalculateGrossAmount:Boolean = true):void
{
	dtlLine.dgDtl.dataProvider[rowIndex].item_qty = numericFormatterWithoutPrecesion.format(dtlLine.dgDtl.dataProvider[rowIndex].item_qty)
	dtlLine.dgDtl.dataProvider[rowIndex].item_price = numericFormatter.format(dtlLine.dgDtl.dataProvider[rowIndex].item_price)
	dtlLine.dgDtl.dataProvider[rowIndex].discount_per = numericFormatter.format(dtlLine.dgDtl.dataProvider[rowIndex].discount_per)	
	dtlLine.dgDtl.dataProvider[rowIndex].item_amt = numericFormatter.format((dtlLine.dgDtl.dataProvider[rowIndex].item_qty * dtlLine.dgDtl.dataProvider[rowIndex].item_price));	
	dtlLine.dgDtl.dataProvider[rowIndex].discount_amt = numericFormatter.format(((dtlLine.dgDtl.dataProvider[rowIndex].item_amt *  dtlLine.dgDtl.dataProvider[rowIndex].discount_per)/100));
	
	/* if(String(dtlLine.dgDtl.dataProvider[rowIndex].taxable).toUpperCase() == 'Y')
	{
		dtlLine.dgDtl.dataProvider[rowIndex].tax_amt = numericFormatter.format(((dtlLine.dgDtl.dataProvider[rowIndex].item_amt * Number(tiTax_per.text))/100));
	} */
	
	dtlLine.dgDtl.dataProvider[rowIndex].net_amt = numericFormatter.format((dtlLine.dgDtl.dataProvider[rowIndex].item_amt - dtlLine.dgDtl.dataProvider[rowIndex].discount_amt ));
	//numericFormatter.format((dtlLine.dgDtl.dataProvider[rowIndex].item_amt - dtlLine.dgDtl.dataProvider[rowIndex].discount_amt + Number(dtlLine.dgDtl.dataProvider[rowIndex].tax_amt)));
	
	if(isCalculateGrossAmount)//it will be false when called from fetchRecordSelectCompleteEventHandler
	{
		calculateGrossAmount();	
	}
}

private function calculateGrossAmount():void
{
	var _grossAmount:Number = 0;
	var _taxableAmount:Number = 0;
	var _depositAmount:Number=0;
	
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
		if(XML(dtlLine.dgDtl.dataProvider[i]).elements('deposit_amt').length() > 0)
		{
			if(String(dtlLine.dgDtl.dataProvider[i].deposit_amt).toString() != '' && String(dtlLine.dgDtl.dataProvider[i].deposit_amt).toString() != 'NaN')
			{
				_depositAmount = _depositAmount + (Number)(dtlLine.dgDtl.dataProvider[i].deposit_amt);
			}	
			
		}

	}
	tiDeposit.text	   =	numericFormatter.format(String(_depositAmount));
	tiTaxable_amt.text = String(_taxableAmount);
	tiitem_amt.text = String(_grossAmount);
	calculateFooterAmounts(); 
}

private function calculateFooterAmounts():void
{
/* 	var _gross_amt:Number = Number(tiitem_amt.text);
	if (tiitem_amt.text != '')
	{	
		var _dis_per:Number = parseFloat(tiDiscount_per.text);
		var _dis_amt:Number;
		var _tax_per:Number = parseFloat(tiTax_per.text);
		var _tax_amt:Number;
		
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
		
		
		
		if (_tax_per == 0 || String(_tax_per) == 'NaN' || String(_tax_per) == '')
		{
			_tax_amt = 0;
			tiTax_per.text = numericFormatterThreePrecesion.format(String(0));
		}
		else
		{
			_tax_amt = Number(numericFormatter.format(_gross_amt *_tax_per / 100));
		} 
		
		tiTax_amt.text = numericFormatter.format(String(_tax_amt));
		tiTax_per.text = numericFormatter.format(tiTax_per.text);
		
		setNetAmount(); 
		
	 }	 	
 */
	discount_perChange(); 
	//ship_perChange();
	//ins_perChange();
	tax_perChange();
	setNetAmount(); 
}

//--------------------------------------------------------------------------------	
private function setNetAmount():void
{
	var _gross_amt:Number 	= Number(tiitem_amt.text);

	/* if (_gross_amt >= 0)
	{ */
	if (tiitem_amt.text != '')
	{
		if(parseFloat(tiDiscount_amt.text) == 0 || tiDiscount_amt.text == ''|| tiDiscount_amt.text == 'NaN')
		{
			tiDiscount_amt.text = numericFormatter.format(String(0.00));
			
		}
		if(parseFloat(tiTax_amt.text) == 0 || tiTax_amt.text == ''|| tiTax_amt.text == 'NaN')
		{
			tiTax_amt.text = numericFormatter.format(String(0.00));
			
		}
		if(parseFloat(tiShipping.text) == 0 || tiShipping.text == ''|| tiShipping.text == 'NaN')
		{
			tiShipping.text = numericFormatter.format(String(0.00));
			
		}
		var _dis_amt:Number  = Number(numericFormatter.format(tiDiscount_amt.text));
		var _sal_tax:Number  = Number(numericFormatter.format(tiTax_amt.text));
		var _ship_amt:Number = parseFloat(numericFormatter.format(tiShipping.text));
		
		tiNet_amt.text = numericFormatter.format(String(_gross_amt - _dis_amt + _sal_tax + _ship_amt));
	} 
	
	// beacause after filling payment info if user add/remove or somehow changes netAmt then paymentStatus and calculation should done
	calculatePayment();  

}

//-------------------------------------------------------------------------------
private function discount_perChange():void
{
	var _gross_amt:Number = Number(tiitem_amt.text);
	/* if (_gross_amt >= 0)
	{ */
	if (tiitem_amt.text != '')
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
		//setAndCalculateDiscountForAllItems();
	}
}				

private function discount_amtChange():void
{
	var _gross_amt:Number = Number(tiitem_amt.text);
	
	if (tiitem_amt.text != '')
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
		//setAndCalculateDiscountForAllItems();
	}
}

private function tax_perChange():void
{
	var _gross_amt:Number 	= Number(tiTaxable_amt.text);
	
	if (tiTaxable_amt.text != '')
	{
		var _tax_per:Number = parseFloat(tiTax_per.text);
		var _tax_amt:Number;
		if (_tax_per == 0 || String(_tax_per) == 'NaN' || String(_tax_per) == '')
		{
			_tax_amt = 0;
			tiTax_per.text = numericFormatterThreePrecesion.format(String(0));
		}
		else
		{
			_tax_amt = Number(numericFormatter.format(_gross_amt *_tax_per / 100));
		} 
		tiTax_amt.text = numericFormatter.format(String(_tax_amt));
		//numericFormatter.precision = 2;
		tiTax_per.text = numericFormatterThreePrecesion.format(tiTax_per.text);
		setNetAmount(); 
		//setAndCalculateDiscountForAllItems();//need to calculate taxPer and taxAmt in this function when editable = true
		
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
		tiTax_per.text = numericFormatterThreePrecesion.format(String(Number(_tax_amt / _gross_amt * 100)));
	}
	tiTax_amt.text = numericFormatter.format(tiTax_amt.text);
	setNetAmount(); 
	//setAndCalculateDiscountForAllItems();//need to calculate taxPer and taxAmt in this function when editable = true
}

private function shipping_amtChange():void
{
	var _gross_amt:Number 	= Number(tiitem_amt.text);
	if (_gross_amt >= 0)
	{
		var _ship_amt:Number 	= parseFloat(tiShipping.text);
		if (String(_ship_amt) == 'NaN' || String(_ship_amt) == '') 
		{
			tiShipping.text = numericFormatter.format(String(0.00));
		}
		tiShipping.text = numericFormatter.format(tiShipping.text);
		setNetAmount(); 
	}
}

private function setValue(customerXml:XML):void
{
	//dcShipping_Id.dataValue = customerXml.children().child('customer_shipping_id').toString(); 
 	//dcShipping_code.dataValue 	= customerXml.children().child('shipping_code').toString(); 
	//dcTerm_code.dataValue	=	 customerXml.children().child('term_code').toString();
	
	setShippingAddress(customerXml);
	setBilliingAddress(customerXml);
	
	//getDueDate();
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
	tiShipFirstName.text = customerXml.children().child('first_name').toString();
	tiShipLastName.text = customerXml.children().child('last_name').toString();
	tiShipCell_no.text = customerXml.children().child('cell_no').toString();
	tiShipEmail.text = customerXml.children().child('email').toString();
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
	tiBillFirstName.text = customerXml.children().child('first_name').toString();
	tiBillLastName.text = customerXml.children().child('last_name').toString();
	tiBillCell_no.text = customerXml.children().child('cell_no').toString();
	tiBillEmail.text = customerXml.children().child('email').toString();


}
private function setPayment(paymentXml:XML):void
{
	for(var i:int=0; i < paymentXml.children().length() ; i++)
	{
		switch(String(paymentXml.children()[i].payment_method).toUpperCase())
		{
			case 'CASH':
				tiCashPayment.text	=	paymentXml.children()[i].payment_amt.toString()
				tiCashReturn.text	=	paymentXml.children()[i].return_amt.toString()

       		 	break;
			case 'CHECK':
				tiCheckPayment.text	=	paymentXml.children()[i].payment_amt.toString()
				tiCheckReturn.text	=	paymentXml.children()[i].return_amt.toString()
	            tiCheckNo.text		=	paymentXml.children()[i].reference_no.toString()

	            break;

			case 'ACCOUNT':
				tiAccountPayment.text	=	paymentXml.children()[i].payment_amt.toString()
				tiAccountRefund.text	=	paymentXml.children()[i].return_amt.toString()	

	            break;

			case 'CREDIT_CARD':
				tiCreditPayment.text	=	paymentXml.children()[i].payment_amt.toString()
				tiCreditRefund.text		=	paymentXml.children()[i].return_amt.toString()
				tiCreditCardNo.text		=	paymentXml.children()[i].reference_no.toString()
				cbCreditCard.dataValue	=	paymentXml.children()[i].card_type.toString()

	            break;
	        case 'DEPOSIT':
				tiDeposit.text			=	paymentXml.children()[i].payment_amt.toString()
				
				break;    
				            
			default:
				Alert.show('this payment type not found');
		}
	}
}

private function resetShippingAddress():void
{
	tiShip_nm.text = ''
	tiShip_address1.text = '' 
	tiShip_address2.text = ''
	tiShip_city.text = ''
	tiShip_fax1.text = ''
	tiShip_phone1.text = ''
	tiShip_state.text = ''
	tiShip_zip.text = ''	
	tiShip_country.text = ''
	tiShipFirstName.text = ''
	tiShipLastName.text = ''
	tiShipCell_no.text = ''
	tiShipEmail.text = ''

}

private function resetBillingAddress():void
{
	tiBill_nm.text = ''
	tiBill_address1.text = ''
	tiBill_address2.text = ''
	tiBill_city.text = ''
	tiBill_fax1.text = ''
	tiBill_phone1.text = ''
	tiBill_state.text = ''
	tiBill_zip.text = ''	
	tiBill_country.text = ''
	tiBillFirstName.text = ''
	tiBillLastName.text = ''
	tiBillCell_no.text = ''
	tiBillEmail.text = ''
}

override protected function preSaveEventHandler(event:AddEditEvent):int
{
	//case 1 user is saving/Holding  new receipt id==0 or id=='' or id == null

	if(tiId.text == '' || Number(tiId.text) == 0)
	{
		if(isHoldButtonClicked)  //we donot want validation for holding receipt 
		{
			isHoldButtonClicked = false;
		}
		else
		{
			if(validationBeforeSave() > 0)
			{
				return 1;    //validation failed
			}
		}
		
		dgPayment.rows = new XML(<pos_invoice_payments/>);
		getNewPaymentXml();
		
	}

	/* case 3 user has to save/Hold already heldReceipt in this case id>0 and trans flag == H
		
		user can modify all fields including payment grid
		 we should ask to mam that can we send empty id for grid otherwise we have to maintain id of existing grid item
		 
		 we are sending  blank id for payment details and address details (we send like it is a new receipt)
	*/
	else if((tiId.text != '' || Number(tiId.text) > 0) && cbTrans_flag.dataValue	==	'H')
	{
		if(isHoldButtonClicked)  //we donot want validation for holding receipt 
		{
			isHoldButtonClicked			=	false;
		}
		else
		{
			if(validationBeforeSave() > 0)
			{
				return 1;    //validation failed
			}
			else
			{
				cbTrans_flag.dataValue	=	'A'
			}
		}
		
		dgPayment.rows	=	new XML(<pos_invoice_payments/>);
		getNewPaymentXml();
	}

 	return 0;
}

private function getNewPaymentXml():void
{
	if(dgPayment.rows.children().length() == 0)
	{
		if(Number(tiCashPayment.text) > 0 || Number(tiCashReturn.text) > 0)
		{
			dgPayment.rows.appendChild(
			<pos_invoice_payment>
				<id/>
				<pos_invoice_id/>
				<serial_no/>
				<payment_method>cash</payment_method>
				<reference_no/>
				<payment_amt>{tiCashPayment.text}</payment_amt>
				<return_amt>{tiCashReturn.text}</return_amt>
			</pos_invoice_payment>);			
		}
		if(Number(tiCheckPayment.text) > 0 || Number(tiCheckReturn.text) > 0 )
		{
			dgPayment.rows.appendChild(
				<pos_invoice_payment>
					<id/>
					<pos_invoice_id/>
					<serial_no/>
					<payment_method>check</payment_method>
					<reference_no>{tiCheckNo.text}</reference_no>
					<payment_amt>{tiCheckPayment.text}</payment_amt>
					<return_amt>{tiCheckReturn.text}</return_amt>
				</pos_invoice_payment>);			
		}
		if(Number(tiCreditPayment.text) > 0 || Number(tiCreditRefund.text) > 0)
		{
			dgPayment.rows.appendChild(
				<pos_invoice_payment>
					<id/>
					<pos_invoice_id/>
					<serial_no/>
					<payment_method>credit_card</payment_method>
					<card_type>{cbCreditCard.dataValue}</card_type>
					<reference_no>{tiCreditCardNo.text}</reference_no>
					<payment_amt>{tiCreditPayment.text}</payment_amt>
					<return_amt>{tiCreditRefund.text}</return_amt>
				</pos_invoice_payment>);			
		}
		if(Number(tiAccountPayment.text) > 0)
		{
			dgPayment.rows.appendChild(
			<pos_invoice_payment>
				<id/>
				<pos_invoice_id/>
				<serial_no/>
				<payment_method>account</payment_method>
				<payment_amt>{tiAccountPayment.text}</payment_amt>
				<return_amt>{tiAccountRefund.text}</return_amt>
			</pos_invoice_payment>);			
		}
		if(Number(tiDeposit.text) > 0)
		{
			dgPayment.rows.appendChild(
			<pos_invoice_payment>
				<id/>
				<pos_invoice_id/>
				<serial_no/>
				<payment_method>deposit</payment_method>
				<payment_amt>{tiDeposit.text}</payment_amt>
				<return_amt>0.00</return_amt>
			</pos_invoice_payment>);			
		}
	}	
}


private function validationBeforeSave():int
{
	var packet_id:String;
	var packet_require_yn:String;
	var item_code:String;
	var retValue:int=0;
	var errMsg:String = "";
		
	// check for packet validation
	if(dtlLine.dgDtl.dataProvider.length > 0)
	{
		for(var i:int = 0; i < dtlLine.dgDtl.dataProvider.length; i++)
		{
			packet_id = dtlLine.dgDtl.dataProvider[i].catalog_item_packet_id.toString();
			 
			if(packet_id == null || packet_id == "")
			{
				// Uncommented as packet validation required in Item Issue. 
				packet_require_yn = dtlLine.dgDtl.dataProvider[i].packet_require_yn.toString();
				item_code = dtlLine.dgDtl.dataProvider[i].catalog_item_code.toString();
				
				if(packet_require_yn == 'Y')
				{
					errMsg = errMsg + "Row #" + (i+1).toString() + ", Item # " + item_code + ",\n"; 
					retValue = -1;
				}
			}
			else
			{
				if(Number(dtlLine.dgDtl.dataProvider[i].item_qty) > 1 || Number(dtlLine.dgDtl.dataProvider[i].item_qty) <=0)
				{
					dtlLine.dgDtl.dataProvider[i].item_qty = "1";				
					itemNetAmountCalculation(i)
				}
			}
		}
		
		if(retValue < 0)
		{
			errMsg = errMsg + "should have Packet information !";
			Alert.show(errMsg);
			return 1;
		}
	}

	if(!isPaymentComplete)
	{
		Alert.show('please complate payment');
		return 1;
	}
	if(Number(tiCreditPayment.text) > 0 || Number(tiCreditRefund.text) > 0)
	{
		if(tiCreditCardNo.text	==	'')
		{
			//validation failed
			Alert.show('for credit card payment Card # cannot be empty');
			return 1;
		}	
	}
	if(Number(tiCheckPayment.text) > 0 || Number(tiCheckReturn.text) > 0)
	{
		if(tiCheckNo.text	==	'')
		{
			//validation failed
			Alert.show('for check payment Check # cannot be empty');
			return 1;
		}	
	}
			
	return 0;
}

override protected function retrieveRecordEventHandler(event:AddEditEvent):void  //after save and prev,next,.....
{
	calculateSalesPersonTotalAmount();
	tiNetAmountPayment.text	=	tiNet_amt.text;
	
	tiFetchItems.text = 'FetchAllItems';
	changeToItemMode();
	
	var record:XML	=	event.recordXml;
	var dtlXml:XML = XML(record.children().child('pos_invoice_lines'))
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
	
	setPayment(XML(record.children()[0][dgPayment.rootNode]))		
	
	if(cbTrans_flag.dataValue	==	'A') //menas dealing with saved receipt( not hold receipt)
	{
		btnHoldFromCustomer.visible	=	false;
		btnHoldFromItem.visible		=	false;
		btnHoldFromPayment.visible	=	false;
		
		isPaymentComplete	=	true// since user can save item only if payment is complete
		calculatePayment() //to get isPaymentComplete status and total Amt, due amt, change amt
		
	}
	else if(cbTrans_flag.dataValue	==	'H')  //dealing with hold receipt
	{
		btnHoldFromCustomer.visible	=	true;
		btnHoldFromItem.visible		=	true;
		btnHoldFromPayment.visible	=	true;

		btnHoldFromCustomer.label	=	'Hold Receipt'
		btnHoldFromItem.label		=	'Hold Receipt'
		btnHoldFromPayment.label	=	'Hold Receipt'
		
		calculatePayment() //to get isPaymentComplete status and total Amt, due amt, change amt
	}

	// Vivek	
	if(dtlLine.dgDtl.dataProvider.length > 0)
	{
		dtlLine.dgDtl.selectedIndex = 0
	}

	updateRecordSummary();
	changeImage()
}

private function setSomeFieldEditableOfSavedReceipt():void
{
	//address related fields
	tiBill_nm.editable			=	true
	tiBill_address1.editable	=	true
	tiBill_address2.editable	=	true
	tiBill_phone1.editable		=	true
	tiBill_fax1.editable		=	true
	tiBill_city.editable		=	true
	tiBill_state.editable		=	true
	tiBill_zip.editable			=	true
	tiBill_country.editable		=	true
	
	tiShip_nm.editable			=	true
	tiShip_address1.editable	=	true
	tiShip_address2.editable	=	true
	tiShip_phone1.editable		=	true
	tiShip_fax1.editable		=	true
	tiShip_city.editable		=	true
	tiShip_state.editable		=	true
	tiShip_zip.editable			=	true
	tiShip_country.editable		=	true
	
	dfShipDate.enabled			=	true
	dcShipping_code.enabled		=	true
	tiTrackingNo.editable		=	true		
	
	//heade fields
	dcCashier.enabled			=	true
	tiPromo_Code.editable		=	true
	taRemarks.editable			=	true
}

override protected function resetObjectEventHandler():void   //on add buttton press,cancelButton click
{
	setGridItemsStatus();
	cbRefTypeChangeEvent();
	calculateSalesPersonTotalAmount();
	tiFetchItems.text			=	'FetchAllItems';
	
	btnHoldFromCustomer.visible	=	true;
	btnHoldFromItem.visible		=	true;
	btnHoldFromPayment.visible	=	true;

	
	btnHoldFromCustomer.label	=	'Held Receipt'
	btnHoldFromItem.label		=	'Held Receipt'
	btnHoldFromPayment.label	=	'Held Receipt'


	isHoldButtonClicked			=	false;
	isPaymentComplete			=	false;
	
	changeToItemMode();

	// Vivek
	getAccountPeriod();
	getCustomerDetails();
	
	updateRecordSummary();
	changeImage()
}

override protected function fetchRecordSelectCompleteEventHandler(event:FetchRecordEvent):void   //click on select button of fetch window
{
	if(isFindAllButtonClicked)
	{
		for(var i:int = 0; i < dtlLine.dgDtl.dataProvider.length; i++)
		{
			if(Number(dtlLine.dgDtl.dataProvider[i].item_qty.toString()) == 0  ||
			    dtlLine.dgDtl.dataProvider[i].item_qty.toString() == '' ||
			    dtlLine.dgDtl.dataProvider[i].item_qty.toString() == 'NaN')
			{
				
				dtlLine.dgDtl.dataProvider[i].item_qty	=	'1';
				
				itemNetAmountCalculation(i , false)
			}
		}
		if(dtlLine.dgDtl.dataProvider.length > 0)
		{
			calculateGrossAmount()
		}		
		setGridItemsStatus('DIRECTITEMS');
	}
	else if(isFindByReceiptButtonClicked)
	{
		tiReceiptNo.text	=	'';
		calculateGrossAmount();
		setGridItemsStatus('RECEIPTITEMS');
	}	
	else if(isFindByRepairButtonClicked)
	{
		tiReceiptNo.text	=	'';
		calculateGrossAmount();
		setGridItemsStatus('REPAIRITEMS');
	}	
	else if(isFindByOrderButtonClicked)
	{
		tiReceiptNo.text	=	'';
		calculateGrossAmount();
		setGridItemsStatus('SPECIALORDERITEMS');
	}	

	// Vivek	
	if(dtlLine.dgDtl.dataProvider.length > 0)
	{
		dtlLine.dgDtl.selectedIndex = 0
	}

	updateRecordSummary();
	changeImage()
}
private function getSimilarItems():void
{
	/* if(dtlLine.dgDtl.selectedIndex >= 0)
	{
		var callbacks:IResponder = new mx.rpc.Responder(getSimilarItemsResultHandler, null);
		
		getInformationEvent	= new GetInformationEvent('similaritems', callbacks, dtlLine.dgDtl.dataProvider[dtlLine.dgDtl.selectedIndex].catalog_item_id);
		getInformationEvent.dispatch();	
	}	  */
	getSimilarItemsResultHandler(dtlLine.dgDtl.rows)
}
private function getSimilarItemsResultHandler(resultXml:XML):void
{
	var similarItemsObj:SimilarItems 	= 		SimilarItems(PopUpManager.createPopUp(DisplayObject(this), SimilarItems, true));
	similarItemsObj.Items				=		resultXml;			
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

private function handleSearchFlagChange(event:Event):void
{
	if(event.currentTarget.selected)
	{
		changeSearchComponent('P')
	}
	else
	{
		changeSearchComponent('I')
	}
}

private function changeSearchComponent(searchType:String):void
{
	if(searchType == 'P')
	{
		btnSearch.enabled = false
		vsSearchFlag.selectedChild = hbPacket	
		tiPacket_code.setFocus()	
		cbSearchFlag.selected = true
	}
	else
	{
		btnSearch.enabled = true	
		vsSearchFlag.selectedChild = hbItem
		dcItemId.setFocus()		
		cbSearchFlag.selected = false
	}
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

private function updateRecordSummary():void
{
	var _item_qty:Number = 0;
	var _clear_qty:Number = 0;
	
	if(dtlLine.dgDtl.dataProvider.length > 0)
	{
		for(var i:int = 0; i < dtlLine.dgDtl.dataProvider.length; i++)
		{
			_item_qty = _item_qty + (Number)(dtlLine.dgDtl.dataProvider[i].item_qty);
			_clear_qty = _clear_qty + (Number)(dtlLine.dgDtl.dataProvider[i].clear_qty);
		}

		lblTotal_items.text = dtlLine.dgDtl.dataProvider.length.toString();
		lblItem_qty.text = _item_qty.toString();
		lblClear_qty.text = _clear_qty.toString(); 
	}
	else
	{
		lblTotal_items.text = '0'
		lblItem_qty.text = '0'
		lblClear_qty.text = '0'
	}
}

private function calculateSalesPersonTotalAmount():void
{
	var _totalShare:Number = 0.00;
	
		
	for(var i:int = 0; i < dtlLineSalesPerson.dgDtl.dataProvider.length; i++)
	{
		_totalShare 	= _totalShare + (Number)(dtlLineSalesPerson.dgDtl.dataProvider[i].share.toString());
		
	}
	tiTotalShare.dataValue		=	numericFormatter.format(String(_totalShare));	
			
 	__localModel.totalShare		=	tiTotalShare.dataValue	
}

/*....salesman can select only one type of items at a time........................*/
private function setGridItemsStatus(itemType:String=null):void
{
	if(dtlLine.dgDtl.dataProvider.length > 0)
	{
		switch(itemType)
		{
			case 'DIRECTITEMS' :
								gridContains	=	'DIRECTITEMS';
								btnFindReceipt.enabled	=	false;
								break;
			case 'REPAIRITEMS' :
								gridContains	=	'REPAIRITEMS';
								hbEnter_Items.enabled	=	false;
								break;
			case 'SPECIALORDERITEMS' :
								gridContains	=	'SPECIALORDERITEMS';
								hbEnter_Items.enabled	=	false;
								break;
			case 'RECEIPTITEMS' :
								gridContains	=	'RECEIPTITEMS';
								hbEnter_Items.enabled	=	false;
								break;
			default :
								break
		}
	}
	else
	{
		gridContains	=	'NOTHING';
		btnFindReceipt.enabled	=	true;
		hbEnter_Items.enabled	=	true;
	}
}
private function isFindValid(findFor:String):Boolean
{
	var isValid:Boolean	=	false;
	
	switch(findFor)
	{
		case 'DIRECTITEMS' :
									if(gridContains == 'DIRECTITEMS' ||  gridContains == 'NOTHING')
									{
										isValid	=	true
									}
									break;		
		case 'SPECIALORDERITEMS' :
									if(gridContains == 'SPECIALORDERITEMS' ||  gridContains == 'NOTHING')
									{
										isValid	=	true
									}
									break;
		case 'REPAIRITEMS' :
									if(gridContains == 'REPAIRITEMS' ||  gridContains == 'NOTHING')
									{
										isValid	=	true
									}
									break;
		
		case 'RECEIPTITEMS' :
									if(gridContains == 'RECEIPTITEMS' ||  gridContains == 'NOTHING')
									{
										isValid	=	true
									}
									break;
							
	}
	
	return isValid;
	
}

