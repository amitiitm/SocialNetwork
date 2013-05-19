import business.events.GetInformationEvent;

import com.generic.events.DetailAddEditEvent;
import com.generic.events.GenComponentEvent;
import com.generic.genclass.GenObject;
import com.generic.genclass.GenValidator;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.formatters.NumberFormatter;
import mx.rpc.IResponder;

import puoi.purchaseorder.PurchaseOrderModelLocator;

private var numericFormatter:NumberFormatter 	= new NumberFormatter();
private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __localModel:PurchaseOrderModelLocator = (PurchaseOrderModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var retrieveFlag:Boolean = false;

public function creationCompleteHandler():void 
{
	numericFormatter.precision = 2;
	numericFormatter.rounding = "nearest";
	numericFormatter.useThousandsSeparator = false;
}

private function calculateNetAmount():void
{
	tiItem_amt.dataValue = numericFormatter.format(Number(tiQty.dataValue) * Number(tiPrice.dataValue));
		
	discountAmtCalculation();
	netAmountCalculation();
}

private function discountAmtCalculation():void
{
	tiDiscount_amt.dataValue	= numericFormatter.format((Number(tiItem_amt.dataValue) * Number(tiDiscount_per.dataValue))/ 100);
}

private function netAmountCalculation():void
{
	tiNet_amt.dataValue = numericFormatter.format(Number(tiItem_amt.dataValue) - Number(tiDiscount_amt.dataValue));
}

private function itemAmountChangeHandler():void
{
	// on changing item amount we are calculating price and net amount
	if(Number(tiQty.dataValue) > 0)
	{
		tiPrice.dataValue = numericFormatter.format(Number(tiItem_amt.dataValue)/ Number(tiQty.dataValue));
		discountAmtCalculation();
		netAmountCalculation();
	}
	else
	{
		tiQty.dataValue	=	tiQty.defaultValue;
		Alert.show('Item Qty cannot be 0');
	}
}

private function discPerCalculation():void
{
	tiDiscount_per.dataValue	=	numericFormatter.format((Number(tiDiscount_amt.dataValue) * 100)/ Number(tiItem_amt.dataValue));
	calculateNetAmount();
}

private function getItemDetails():void
{
	if(dcItemId.text != '' && dcItemId.text != null)
	{
		var callbacks:IResponder = new mx.rpc.Responder(getItemDetailsHandler, null);

		getInformationEvent	=	new GetInformationEvent('iteminfo', callbacks, dcItemId.dataValue, __localModel.trans_date,'V',__localModel.account_id);
		getInformationEvent.dispatch(); 
	}
	else
	{
		resetOtherValues();
		
		tiPrice.dataValue = tiPrice.defaultValue;
		tiDiscount_per.dataValue = tiDiscount_per.defaultValue;
		tiDiscount_amt.dataValue = tiDiscount_amt.defaultValue;
		cbItem_type.dataValue = cbItem_type.defaultValue;
		tiItemDescription.dataValue = tiItemDescription.defaultValue;
		tiImage_thumnail.dataValue = tiImage_thumnail.defaultValue;
		tiTaxable.dataValue = tiTaxable.defaultValue;
	}
}

public function getItemDetailsHandler(resultXml:XML):void
{
	resetOtherValues();
	
	tiItemCode.dataValue = resultXml.children()[0].store_code.toString();
	dcItemId.labelValue	= resultXml.children()[0].store_code.toString();
	dcItemId.dataValue	= resultXml.children()[0].catalog_item_id.toString();
	tiPrice.dataValue = resultXml.children()[0].cost.toString();
	tiDiscount_per.dataValue = resultXml.children()[0].discount_per.toString();
	tiDiscount_amt.dataValue = resultXml.children()[0].discount_amt.toString();
	cbItem_type.dataValue = resultXml.children()[0].item_type.toString();
	tiItemDescription.dataValue = resultXml.children()[0].name.toString();
	tiImage_thumnail.dataValue = resultXml.children()[0].image_thumnail.toString();
	tiTaxable.dataValue = resultXml.children()[0].taxable.toString();

	tiQty.enabled = true;

	calculateNetAmount()
}

private function resetOtherValues():void
{
	tiClearQty.dataValue = tiClearQty.defaultValue;
	tiItem_amt.dataValue = tiItem_amt.defaultValue;
	tiNet_amt.dataValue = tiNet_amt.defaultValue;
	tiQty.dataValue = tiQty.defaultValue;
	tiRef_Qty.dataValue = tiRef_Qty.defaultValue;
}

override protected function resetObjectEventHandler():void
{
	tiQty.enabled = true;
}	

override protected function retrieveRowEventHandler(event:DetailAddEditEvent):void
{
	var xml:XML = new XML(<catalog_items></catalog_items>);
	
	retrieveFlag = true 
	
}
