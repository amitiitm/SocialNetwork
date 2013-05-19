import business.events.GetInformationEvent;
import com.generic.events.AddEditEvent;
import model.GenModelLocator;

import mx.rpc.IResponder;
import puoi.purchaseindent.PurchaseIndentModelLocator;

private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __localModel:PurchaseIndentModelLocator = (PurchaseIndentModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
private var image_name:String;

private function init():void
{
	__localModel.trans_date = dfTrans_date.text	
	getAccountPeriod();
	tnDetail.selectedChild = vbDetail;
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
	 dfDue_date.text	=	resultXml.children()[0].pay1_date.toString();
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

private function setTotalItem():void
{
	var _item_qty:Number = 0;
	var _clear_qty:Number = 0;
	
		
	if(dtlLine.dgDtl.dataProvider != null)
	{
		for(var i:int = 0; i < dtlLine.dgDtl.dataProvider.length; i++)
		{
			_item_qty = _item_qty + (Number)(dtlLine.dgDtl.dataProvider[i].item_qty);
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
	
}

//--------------------------------------------------------------------------------	
override protected function retrieveRecordEventHandler(event:AddEditEvent):void  //after save and prev,next,.....
{
	var recordXml:XML	= event.recordXml;
	
	dcVendor_id.enabled	=	false;
	//cbOrder_type.enabled=	false;
	
	__localModel.trans_date = dfTrans_date.text

	if(dtlLine.dgDtl.dataProvider.length > 0)
	{
		dtlLine.dgDtl.selectedIndex = 0
	}

	changeImage()
	setTotalItem()
}

override protected function resetObjectEventHandler():void   //on add buttton press,
{
	//dcStore_id.dataValue = __genModel.user.default_company_id.toString() //to set default store
	getStoreInfo(__genModel.user.default_company_id.toString());//get default store info
	getAccountPeriod();
	
	dcVendor_id.enabled	=	true;

	
	__localModel.trans_date = dfTrans_date.text

	changeImage()
	setTotalItem()
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
