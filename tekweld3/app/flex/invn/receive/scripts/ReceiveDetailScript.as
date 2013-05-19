import business.events.GetInformationEvent;

import com.generic.events.DetailAddEditEvent;

import invn.receive.ReceiveModelLocator;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.formatters.NumberFormatter;
import mx.rpc.IResponder;

private var numericFormatter:NumberFormatter = new NumberFormatter();
private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __localModel:ReceiveModelLocator = (ReceiveModelLocator)(GenModelLocator.getInstance().activeModelLocator);
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
	tiItem_amt.text = numericFormatter.format(Number(tiQty.text) * Number(tiPrice.text));
}

private function itemAmountChangeHandler():void
{
	// on changing item amount we are calculating price and net amount
	if(Number(tiQty.text) > 0)
	{
		tiPrice.text = numericFormatter.format(Number(tiItem_amt.text)/ Number(tiQty.text));
	}
	else
	{
		tiQty.text = tiQty.defaultValue;
		Alert.show('Item Qty cannot be 0');
	}
}

private function getPacketDetails():void
{
	if(tiCatalog_item_packet_code.text != '')
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
	if(dcItemId.text != '' && dcItemId.text != null)
	{
		var callbacks:IResponder = new mx.rpc.Responder(getItemDetailsHandler, null);

		getInformationEvent = new GetInformationEvent('iteminfo', callbacks, dcItemId.dataValue, __localModel.trans_date);
		getInformationEvent.dispatch(); 
	}
	else
	{
		resetOtherValues();

		tiPrice.text = tiPrice.defaultValue;
		// tiDiscount_per.text = tiDiscount_per.defaultValue;
		// tiDiscount_amt.text = tiDiscount_amt.defaultValue;
		cbItem_type.dataValue = cbItem_type.defaultValue;
		tiItemDescription.text = tiItemDescription.defaultValue;
		tiImage_thumnail.text = tiImage_thumnail.defaultValue;
		// tiTaxable.text = tiTaxable.defaultValue;
		tiCatalog_item_packet_code.text = "";
		tiCatalog_item_packet_id.text = "";
	}
}

public function getItemDetailsHandler(resultXml:XML):void
{
	var packet_require_yn:String;

	resetOtherValues();
	
	tiItemCode.dataValue	=	resultXml.children()[0].store_code.toString();
	dcItemId.labelValue		=	resultXml.children()[0].store_code.toString();
	dcItemId.dataValue		=	resultXml.children()[0].catalog_item_id.toString();
	
	tiPrice.text = resultXml.children()[0].price.toString();
	cbItem_type.dataValue = resultXml.children()[0].item_type.toString();
	tiItemDescription.text = resultXml.children()[0].name.toString();
	tiImage_thumnail.text = resultXml.children()[0].image_thumnail.toString();
	// tiTaxable.text =	resultXml.children()[0].taxable.toString();
	
	packet_require_yn = resultXml.children()[0].packet_require_yn.toString();

	tiCatalog_item_packet_code.text = "";
	tiCatalog_item_packet_id.text = "";

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
		tiPrice.dataValue = resultXml.children()[0].price.toString();
		cbItem_type.dataValue = resultXml.children()[0].item_type.toString();
		tiItemDescription.dataValue = resultXml.children()[0].name.toString();
		tiImage_thumnail.dataValue = resultXml.children()[0].image_thumnail.toString();
		// tiTaxable.dataValue = resultXml.children()[0].taxable.toString();
		tiPacket_require_yn.dataValue = resultXml.children()[0].packet_require_yn.toString();
		
		tiQty.dataValue = "1";
		tiQty.enabled = false;
	}
	else
	{
		tiCatalog_item_packet_id.dataValue = tiCatalog_item_packet_id.defaultValue;
		tiCatalog_item_packet_code.dataValue = tiCatalog_item_packet_code.defaultValue;

		tiQty.enabled = true;
	}

	calculateNetAmount();
}

private function resetOtherValues():void
{
	tiItem_amt.text = tiItem_amt.defaultValue;
	tiQty.text = tiQty.defaultValue;	
}

override protected function resetObjectEventHandler():void
{
	tiQty.enabled = true;
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

	if(catalog_item_packet_code == null || catalog_item_packet_code == "")
	{
		tiQty.enabled = true;
	}
	else
	{
		tiQty.enabled = false;
	}
}
