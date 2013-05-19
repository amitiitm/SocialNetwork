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

private var numericFormatter:GenNumberFormatter 				= 	new GenNumberFormatter();
private var numericFormatterFourPrecesion:GenNumberFormatter	=	new GenNumberFormatter();
private var numericFormatterThreePrecesion:GenNumberFormatter	=	new GenNumberFormatter();
private var numericFormatterWithoutPrecesion:GenNumberFormatter	=	new GenNumberFormatter();
private var getInformationEvent:GetInformationEvent;

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

	
	dtlLine.bcdp.btnEdit.visible=	false;
	
	getAccountPeriod();
	tnDetail.selectedChild = vbDetail;
}

private function createMapping():void
{
	var mappingArrCol:ArrayCollection = new ArrayCollection();
	
	mappingArrCol.addItem({source: 'trans_bk',				target: 'ref_trans_bk',		isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'trans_no',				target: 'ref_trans_no',		isPrimaryKey:'Y',	updatable:'N'})
	mappingArrCol.addItem({source: 'trans_date',			target: 'ref_trans_date',	isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'serial_no',				target: 'ref_serial_no',	isPrimaryKey:'Y',	updatable:'N'})
	
	mappingArrCol.getItemAt(3).isPrimaryKey = isSerial_no_pk;
	
	mappingArrCol.addItem({source: 'catalog_item_id',		target: 'catalog_item_id' ,	isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'catalog_item_code',		target: 'catalog_item_code' ,isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'item_description',		target: 'item_description',isPrimaryKey:'N',	updatable:'N'})
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
	
	mappingArrCol.addItem({source: 'catalog_item_packet_code',	target: 'catalog_item_packet_code',	isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'catalog_item_packet_id',	target: 'catalog_item_packet_id',	isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'packet_require_yn',			target: 'packet_require_yn',		isPrimaryKey:'N',	updatable:'N'})

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
		getInformationEvent	=	new GetInformationEvent('vendorinfo', callbacks, dcVendor_id.dataValue);
		getInformationEvent.dispatch();   
	}
}

private function vendorDetailsHandler(resultXml:XML):void
{
	dcTerm_code.dataValue	=	 resultXml.children().child('invoice_term_code').toString();
	setBilliingAddress(resultXml);
	getDueDate();
	
	if(dtlLine.dgDtl.rows.children().length()>0)
	{
		dtlLine.dgDtl.rows	=	new XML('<' + dtlLine.rootNode + '/>');
		calculateGrossAmount();
		updateRecordSummary();
		changeImage();
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

private function setGrossAmount(event:EditableDetailEvent):void
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
			if(colName == "catalog_item_packet_code")
			{
				dtlLineRowIndex = rowIndex;
				getPacketDetails();
			}
			if(colName == "discount_amt")
			{
				itemDiscountPerCalculation(rowIndex);
			}
			else if(colName == "item_amt")
			{
				itemPriceCalculation(rowIndex);
			}
			else if(colName != "catalog_item_packet_code")
			{
				itemNetAmountCalculation(rowIndex);
			}
		}
	}
}

private function getPacketDetails():void
{
	var packet_code:String = dtlLine.dgDtl.dataProvider[dtlLineRowIndex].catalog_item_packet_code;
	var item_code:String = dtlLine.dgDtl.dataProvider[dtlLineRowIndex].catalog_item_code;

	if(packet_code != '')
	{
		var callbacks:IResponder = new mx.rpc.Responder(getPacketDetailsHandler, null);

		getInformationEvent	= new GetInformationEvent('packetinfovalidate', callbacks, packet_code, item_code, 'N');
		getInformationEvent.dispatch();
	}
	else
	{
		dtlLine.dgDtl.dataProvider[dtlLineRowIndex].catalog_item_packet_id = "";
	}
}

public function getPacketDetailsHandler(resultXml:XML):void
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

		dtlLine.dgDtl.dataProvider[dtlLineRowIndex].item_qty = dtlLine.dgDtl.dataProvider[dtlLineRowIndex].ref_qty.toString();
	}
	
	itemNetAmountCalculation(dtlLineRowIndex)
}

private function itemNetAmountCalculation(rowIndex:int , isCalculateGrossAmount:Boolean = true):void
{
	dtlLine.dgDtl.dataProvider[rowIndex].item_qty 	= numericFormatterWithoutPrecesion.format(dtlLine.dgDtl.dataProvider[rowIndex].item_qty)
	dtlLine.dgDtl.dataProvider[rowIndex].item_price = numericFormatter.format(dtlLine.dgDtl.dataProvider[rowIndex].item_price)
	dtlLine.dgDtl.dataProvider[rowIndex].item_amt = numericFormatter.format((dtlLine.dgDtl.dataProvider[rowIndex].item_qty * dtlLine.dgDtl.dataProvider[rowIndex].item_price));
	dtlLine.dgDtl.dataProvider[rowIndex].discount_amt = numericFormatter.format(((dtlLine.dgDtl.dataProvider[rowIndex].item_amt * dtlLine.dgDtl.dataProvider[rowIndex].discount_per)/100));
	dtlLine.dgDtl.dataProvider[rowIndex].net_amt = numericFormatter.format((dtlLine.dgDtl.dataProvider[rowIndex].item_amt - dtlLine.dgDtl.dataProvider[rowIndex].discount_amt));

	if(isCalculateGrossAmount)//it will be false when called from fetchRecordSelectCompleteEventHandler
	{
		calculateGrossAmount();	
	}
}

private function updateRecordSummary(isFromRetrieve:Boolean = false):void
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
		if(!isFromRetrieve)
		{
			tiRef_trans_no.dataValue	=	dtlLine.dgDtl.dataProvider[0].ref_trans_no.toString();	
		}
		lblTotal_items.text = dtlLine.dgDtl.dataProvider.length.toString()
		lblItem_qty.text = _item_qty.toString()
		lblClear_qty.text = _clear_qty.toString() 
	}
	else
	{
		if(!isFromRetrieve)
		{
			tiRef_trans_no.dataValue	=	'';	
		}
		lblTotal_items.text = '0'
		lblItem_qty.text = '0'
		lblClear_qty.text = '0'
	}
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
	tiTaxable_amt.text	=	String(_taxableAmount);
	tiItem_amt.text = String(_grossAmount);
	calculateFooterAmounts(); 
}

private function calculateFooterAmounts():void
{
	discount_perChange(); 
	//ship_perChange();
	//ins_perChange();
	tax_perChange();
	setNetAmount(); 
}

private function itemPriceCalculation(rowIndex:int):void
{
	dtlLine.dgDtl.dataProvider[rowIndex].item_amt	=	numericFormatter.format(dtlLine.dgDtl.dataProvider[rowIndex].item_amt);
	dtlLine.dgDtl.dataProvider[rowIndex].item_qty 		=	numericFormatterWithoutPrecesion.format(dtlLine.dgDtl.dataProvider[rowIndex].item_qty);
	
	if(dtlLine.dgDtl.dataProvider[rowIndex].item_qty > 0)
	{
		dtlLine.dgDtl.dataProvider[rowIndex].item_price 	= numericFormatter.format(dtlLine.dgDtl.dataProvider[rowIndex].item_amt/ dtlLine.dgDtl.dataProvider[rowIndex].item_qty);
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
		var _other_amt:Number = parseFloat(numericFormatter.format(tiOther_amt.text));
		
		if (String(_other_amt) == 'NaN' || String(_other_amt) == '') 
		{
			tiOther_amt.text = String(0.00);
		} 
		/* tiNet_amt.text = numericFormatter.format(String(_gross_amt + _ship_amt - _dis_amt + _ins_amt + _sal_tax + _other_amt)); */
		tiNet_amt.text = numericFormatter.format(String(_gross_amt + _ship_amt - _dis_amt  + _sal_tax + _other_amt ));
	} 
}

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

private function tax_perChange():void
{
	//numericFormatter.precision = 4;
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
		//numericFormatter.precision = 3;
		tiTax_per.text = numericFormatterThreePrecesion.format(tiTax_per.text);
		setNetAmount(); 
		
	}
}
	
//--------------------------------------------------------------------------------
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
	//numericFormatter.precision = 4;
	tiTax_amt.text = numericFormatterFourPrecesion.format(tiTax_amt.text);
	//numericFormatter.precision = 2;
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
//--------------------------------------------------------------------------------	
override protected function preSaveEventHandler(event:AddEditEvent):int
{
	var packet_id:String;
	var packet_require_yn:String;
	var item_code:String;
	var retValue:int=0;
	var errMsg:String = "";
		
	if(dtlLine.dgDtl.dataProvider.length > 0)
	{
		for(var i:int = 0; i < dtlLine.dgDtl.dataProvider.length; i++)
		{
			packet_id = dtlLine.dgDtl.dataProvider[i].catalog_item_packet_id.toString();
			 
			if(packet_id == null || packet_id == "")
			{
				/* Commented as packet validation not required in Item Receive. 
				packet_require_yn = dtlLine.dgDtl.dataProvider[i].packet_require_yn.toString();
				item_code = dtlLine.dgDtl.dataProvider[i].catalog_item_code.toString();
				
				if(packet_require_yn == 'Y')
				{
					errMsg = errMsg + "Row #" + (i+1).toString() + ", Item # " + item_code + ",\n"; 
					retValue = -1;
				}
				*/
			}
			else
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
	}
	
	return retValue;
}

override protected function retrieveRecordEventHandler(event:AddEditEvent):void  //after save and prev,next,.....
{
	var memo_type:String = 'O';
	var recordXml:XML		= event.recordXml;
	var dtlXml:XML	=	XML(recordXml.children().child('purchase_memo_lines'))
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
	tiTaxable_amt.text	=	String(_taxableAmount);

	setFetchParameter(memo_type, 'GRID')
	
	dcVendor_id.enabled	=	false;

	if(dtlLine.dgDtl.dataProvider.length > 0)
	{
		dtlLine.dgDtl.selectedIndex = 0
	}

	updateRecordSummary(true)	 
	changeImage()
}

override protected function resetObjectEventHandler():void   //on add buttton press,
{
	var memo_type:String = 'O';
	dcStore_id.dataValue = __genModel.user.default_company_id.toString() //to set default store
	// getStoreInfo(__genModel.user.default_company_id.toString());//get default store info
	setShippingAddress();
	dcVendor_id.enabled	=	true;
	getAccountPeriod();
	
	updateRecordSummary()
	changeImage()

	setFetchParameter(memo_type, 'GRID')
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
			itemNetAmountCalculation(i , false)
		}
		if(dtlLine.dgDtl.dataProvider.length > 0)
		{
			calculateGrossAmount()
		}		
	}

	updateRecordSummary()
	changeImage()
}

override protected function fetchRecordWindowCloseEventHandler(event:FetchRecordEvent):void 
{
	var memo_type:String = 'O'
	setFetchParameter(memo_type, 'GRID')
}

private function handleBtnGetDataClick(event:Event):void
{
	var memo_type:String = 'O'
	setFetchParameter(memo_type, 'BUTTON')

	dtlLine.bcdp.dispatchEvent(new ButtonControlDetailEvent(ButtonControlDetailEvent.FETCH_RECORDS_EVENT));
}

private function setFetchParameter(memo_type:String, fetch_type:String):void
{
	if(memo_type == 'O')
	{
		if(fetch_type.toLocaleUpperCase() == 'GRID')
		{
			dtlLine.fetchDetailDataServiceID = "fetch_open_memo_orders";
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
			dtlLine.fetchDetailDataServiceID = "fetch_open_memo_orders_hdr";
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
}
