import business.events.GetInformationEvent;
import invn.transactionBOM.components.TransactionBOM;
import com.generic.customcomponents.GenDataGrid;
import com.generic.events.AddEditEvent;
import com.generic.genclass.GenNumberFormatter;
import com.generic.events.ButtonControlDetailEvent;
import com.generic.events.EditableDetailEvent;
import com.generic.events.FetchRecordEvent;
import mx.controls.dataGridClasses.DataGridColumn;

import model.GenModelLocator;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.rpc.IResponder;

import puoi.purchaseorder.PurchaseOrderModelLocator;

private var numericFormatter:GenNumberFormatter 				= 	new GenNumberFormatter();
private var numericFormatterFourPrecesion:GenNumberFormatter	=	new GenNumberFormatter();
private var numericFormatterThreePrecesion:GenNumberFormatter	=	new GenNumberFormatter();
private var numericFormatterWithoutPrecesion:GenNumberFormatter	=	new GenNumberFormatter();
private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __localModel:PurchaseOrderModelLocator = (PurchaseOrderModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
private var image_name:String;
private var isSerial_no_pk:String = 'Y';

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

	btnGetData.enabled = false ;
	
	__localModel.trans_date = dfTrans_date.text	
	getAccountPeriod();
	tnDetail.selectedChild = vbDetail;
}

private function orderTypeChangeEvent():void//rashmi
{
	vsDtl.selectedChild = hbNonEditable
	dtlLineNonEditable.btnImportVisible = true
		
		
	dtlLineNonEditable.dgDtl.rows = new XML('<' + dtlLineNonEditable.rootNode + '/>');
	tiRef_trans_no.dataValue	=	'';
	//updateRecordSummary()
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
	setShippingAddress(resultXml);
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
	tiAccount_period_code.dataValue		=	resultXml.child('code');
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
	 dfDue_date.text	=	resultXml.children()[0].pay1_date.toString();
}

private function getVendorDetails():void
{
	__localModel.account_id	=	dcVendor_id.dataValue;
	if(dcVendor_id.text != "" && dcVendor_id.text != null)
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(vendorDetailsHandler, null);
		getInformationEvent			=	new GetInformationEvent('vendorinfo', callbacks, dcVendor_id.dataValue);
		getInformationEvent.dispatch();   
	}
}

private function vendorDetailsHandler(resultXml:XML):void
{
	dcTerm_code.dataValue	=	 resultXml.children().child('invoice_term_code').toString();
	dcTerm_code.labelValue	=	 resultXml.children().child('invoice_term_code').toString();
	tiVendor_code.dataValue	=	 resultXml.children().child('code').toString();
	dcVendor_id.labelValue	=	 resultXml.children().child('code').toString();
	dcVendor_id.dataValue	=	 resultXml.children().child('id').toString();
	tiBill_code.dataValue	=	 resultXml.children().child('code').toString();
	setBilliingAddress(resultXml);
	getDueDate(); 
}

private function setShippingAddress(resultXml:XML):void
{
	tiShip_nm.text = resultXml.children().child('name').toString();
	tiShip_address1.text = resultXml.children().child('address1').toString();
	tiShip_address2.text = resultXml.children().child('address2').toString();
	tiShip_city.text = resultXml.children().child('city').toString();
	tiShip_fax1.text = resultXml.children().child('fax').toString();
	tiShip_phone1.text = resultXml.children().child('phone').toString();
	tiShip_state.text = resultXml.children().child('state').toString();
	tiShip_zip.text = resultXml.children().child('zip').toString();	
	tiShip_country.text = resultXml.children().child('country').toString();
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

private function setGrossAmount():void
{
	var _grossAmount:Number = 0;
	var _taxableAmount:Number = 0;
	var _item_qty:Number = 0;
	var _clear_qty:Number = 0;
	
	var tempGrid:GenDataGrid = getDtlComponentGrid()
	
	//numericFormatter.precision = 2;
	
	if(tempGrid.dataProvider != null)
	{
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
	trFooter.setTotalTaxableAmt(_taxableAmount)
	trFooter.setTotalItemAmt(_grossAmount)
	
	trFooter.calculateFooters();

}

//--------------------------------------------------------------------------------
override protected function retrieveRecordEventHandler(event:AddEditEvent):void  //after save and prev,next,.....
{
	var recordXml:XML	= event.recordXml;
	
	dcVendor_id.enabled	=	false;
	cbOrder_type.enabled=	false;
	
	__localModel.trans_date = dfTrans_date.text;
	__localModel.account_id	=	dcVendor_id.dataValue;

	var tempGrid:GenDataGrid = getDtlComponentGrid()
		
	if(tempGrid.dataProvider.length > 0)
	{
		tempGrid.selectedIndex = 0
	}
	
	
	changeImage()
	setGrossAmount()
	
	tiBill_code.dataValue	=	 dcVendor_id.labelValue
	
	
}

override protected function resetObjectEventHandler():void   //on add buttton press,
{
//	dcStore_id.dataValue = __genModel.user.default_company_id.toString() //to set default store
	getStoreInfo(__genModel.user.default_company_id.toString());//get default store info
	getAccountPeriod();
	
	dcVendor_id.enabled	=	true;
	cbOrder_type.enabled=	true;
	
	__localModel.trans_date = dfTrans_date.text;
	__localModel.account_id	=	'';

	changeImage()
	setGrossAmount()
		
	orderTypeChangeEvent()
	
	if(__genModel.objectFromDrilldown.children().length()>0)
	{
		dtlLineNonEditable.dgDtl.rows  = __genModel.objectFromDrilldown.copy();
	}
	__genModel.objectFromDrilldown     = new XML(<rows></rows>);
	
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


private function getDtlComponentGrid(isFromRetrieve:Boolean = false):GenDataGrid
{
	var tempGrid:GenDataGrid;

		tempGrid = dtlLineNonEditable.dgDtl;
		tiRef_trans_no.dataValue		=	'';
	return tempGrid;	
}



