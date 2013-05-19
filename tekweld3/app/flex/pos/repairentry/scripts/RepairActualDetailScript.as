import business.events.GetInformationEvent;

import com.generic.events.DetailAddEditEvent;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.formatters.NumberFormatter;
import mx.rpc.IResponder;

import pos.repairentry.RepairEntryModelLocator;

private var numericFormatter:NumberFormatter = new NumberFormatter();
private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __localModel:RepairEntryModelLocator = (RepairEntryModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

public function creationCompleteHandler():void 
{
	numericFormatter.precision = 2;
	numericFormatter.rounding = "nearest";
	numericFormatter.useThousandsSeparator = false;
}

private function calculateNetAmount():void
{
	tiItem_amt.dataValue = numericFormatter.format(Number(tiQty.dataValue) * Number(tiPrice.dataValue));
	
	netAmountCalculation();
}


private function netAmountCalculation():void
{
	//tiNet_amt.dataValue = numericFormatter.format(Number(tiItem_amt.dataValue) - Number(tiDiscount_amt.dataValue));
}

private function itemAmountChangeHandler():void
{
	// on changing item amount we are calculating price and net amount
	if(Number(tiQty.dataValue) > 0)
	{
		tiPrice.dataValue = numericFormatter.format(Number(tiItem_amt.dataValue)/ Number(tiQty.dataValue));
		netAmountCalculation();
	}
	else
	{
		tiQty.dataValue = tiQty.defaultValue;
		Alert.show('Item Qty cannot be 0');
	}
}

private function getItemDetails():void
{
	if(dcItemId.dataValue != '')
	{
		var callbacks:IResponder = new mx.rpc.Responder(getItemDetailsHandler, null);

		getInformationEvent	= new GetInformationEvent('iteminfo', callbacks, dcItemId.dataValue, __localModel.trans_date);
		getInformationEvent.dispatch(); 
	}
	else
	{
		resetOtherValues();

		tiPrice.dataValue = tiPrice.defaultValue;
		tiItemDescription.dataValue = tiItemDescription.defaultValue;
		
	}
}

public function getItemDetailsHandler(resultXml:XML):void
{

	resetOtherValues();
	
	tiPrice.dataValue = resultXml.children()[0].price.toString();
	tiItemDescription.dataValue = resultXml.children()[0].name.toString();

	tiQty.enabled = true;
	
	calculateNetAmount()
}


private function resetOtherValues():void
{
	tiItem_amt.dataValue = tiItem_amt.defaultValue;
//	tiNet_amt.dataValue = tiNet_amt.defaultValue;
	tiQty.dataValue = tiQty.defaultValue;
}

override protected function resetObjectEventHandler():void{}

override protected function retrieveRowEventHandler(event:DetailAddEditEvent):void{}
	