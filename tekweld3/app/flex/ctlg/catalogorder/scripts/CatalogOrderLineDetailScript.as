import business.events.GetInformationEvent;

import com.generic.events.DetailAddEditEvent;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.formatters.NumberFormatter;
import mx.rpc.IResponder;

import ctlg.catalogorder.CatalogOrderModelLocator;

private var numericFormatter:NumberFormatter = new NumberFormatter();
private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __localModel:CatalogOrderModelLocator = (CatalogOrderModelLocator)(GenModelLocator.getInstance().activeModelLocator);
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
		tiQty.dataValue = tiQty.defaultValue;
		Alert.show('Item Qty cannot be 0');
	}
}

private function discPerCalculation():void
{
	tiDiscount_per.dataValue	= numericFormatter.format((Number(tiDiscount_amt.dataValue) * 100)/ Number(tiItem_amt.dataValue));
	calculateNetAmount();
}

private function getPacketDetails():void
{
	if(tiCatalog_item_packet_code.dataValue != '')
	{
		var callbacks:IResponder = new mx.rpc.Responder(getPacketDetailsHandler, null);

		getInformationEvent	= new GetInformationEvent('packetinfo', callbacks, tiCatalog_item_packet_code.dataValue, __localModel.trans_date, 'N');
		getInformationEvent.dispatch();
	}
	else
	{
		tiCatalog_item_packet_id.dataValue = ""	
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
		tiDiscount_per.dataValue = tiDiscount_per.defaultValue;
		tiDiscount_amt.dataValue = tiDiscount_amt.defaultValue;
		tiItemDescription.dataValue = tiItemDescription.defaultValue;
		tiImage_thumnail.dataValue = tiImage_thumnail.defaultValue;
		tiCatalog_item_packet_code.dataValue = "";
		tiCatalog_item_packet_id.dataValue = "";
	}
}

public function getItemDetailsHandler(resultXml:XML):void
{
	var packet_require_yn:String;
	
	resetOtherValues();
	
	tiPrice.dataValue = resultXml.children()[0].price.toString();
	tiDiscount_per.dataValue = resultXml.children()[0].discount_per.toString();
	tiDiscount_amt.dataValue = resultXml.children()[0].discount_amt.toString();
	tiItemDescription.dataValue = resultXml.children()[0].name.toString();
	tiImage_thumnail.dataValue = resultXml.children()[0].image_thumnail.toString();

	packet_require_yn = resultXml.children()[0].packet_require_yn.toString();

	tiCatalog_item_packet_code.dataValue = "";
	tiCatalog_item_packet_id.dataValue = "";

	if(packet_require_yn=='N')
	{
		tiCatalog_item_packet_code.enabled = false;
	}
	else
	{
		tiCatalog_item_packet_code.enabled = true;
	}	

	tiQty.enabled = true;
	tiPacket_require_yn.dataValue = packet_require_yn;
	
	calculateNetAmount()
}

public function getPacketDetailsHandler(resultXml:XML):void
{
	if(resultXml.children().length() > 0)
	{
		resetOtherValues();

		tiCatalog_item_packet_id.dataValue = resultXml.children()[0].catalog_item_packet_id.toString();
		tiCatalog_item_packet_code.dataValue = resultXml.children()[0].catalog_item_packet_code.toString();
	
		dcItemId.dataValue = resultXml.children()[0].catalog_item_id.toString();
		tiPrice.dataValue = resultXml.children()[0].tag_price.toString();
		tiDiscount_per.dataValue = resultXml.children()[0].discount_per.toString();
		tiDiscount_amt.dataValue = resultXml.children()[0].discount_amt.toString();
		tiItemDescription.dataValue = resultXml.children()[0].name.toString();
		tiImage_thumnail.dataValue = resultXml.children()[0].image_thumnail.toString();
		tiPacket_require_yn.dataValue = resultXml.children()[0].packet_require_yn.toString();

		tiQty.dataValue = "1";
	}
	else
	{
		tiCatalog_item_packet_id.dataValue = tiCatalog_item_packet_id.defaultValue;
		tiCatalog_item_packet_code.dataValue = tiCatalog_item_packet_code.defaultValue;
	
		
	}

	calculateNetAmount()	
}

private function resetOtherValues():void
{
	tiClearQty.dataValue = tiClearQty.defaultValue;
	tiItem_amt.dataValue = tiItem_amt.defaultValue;
	tiNet_amt.dataValue = tiNet_amt.defaultValue;
	tiQty.dataValue = tiQty.defaultValue;
}

override protected function resetObjectEventHandler():void
{
	tiCatalog_item_packet_code.enabled = true;
}

override protected function retrieveRowEventHandler(event:DetailAddEditEvent):void
{
	var packet_require_yn:String = tiPacket_require_yn.dataValue;
	var catalog_item_packet_code:String = tiCatalog_item_packet_code.dataValue;
	
	if(packet_require_yn == null || packet_require_yn == "" || packet_require_yn.toLocaleUpperCase() =='N')
	{
		tiCatalog_item_packet_code.enabled = false
	}
	else
	{
		tiCatalog_item_packet_code.enabled = true
	}

}
	