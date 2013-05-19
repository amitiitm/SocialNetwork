import business.events.GetInformationEvent;

import com.generic.customcomponents.GenDateField;

import model.GenModelLocator;

import mx.rpc.IResponder;
import mx.rpc.Responder;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

private function handleAssemble_item_id():void
{
	if(dcAssemble_item_id.text != '' && dcAssemble_item_id.text != null) 
	{
		var callbacks:IResponder = new mx.rpc.Responder(getItemDetailsHandler, null);
		
		var getInformationEvent:GetInformationEvent = new GetInformationEvent('iteminfo', callbacks, dcAssemble_item_id.dataValue, new GenDateField().currentDate());
		getInformationEvent.dispatch(); 
		
	} 
	else
	{
		tiPrice.dataValue = '';
		taDescription.dataValue = '';
		tiCatalog_item_code.dataValue     = '';
		tiCatalog_item_name.dataValue		= '';
		cbUnit.dataValue     = '';
		
		setItemCost();
	}
	
	
}

private function getItemDetailsHandler(resultXml:XML):void
{
	var cost:String			 = 	resultXml.children().child('cost').toString()
	var description:String 	 = 	resultXml.children().child('name').toString()
	var code :String      	 = 	resultXml.children().child('store_code').toString()	
	var name:String      	 = 	resultXml.children().child('name').toString()
	var unit:String      	 = 	resultXml.children().child('unit').toString()
	
	tiPrice.dataValue = cost;
	taDescription.dataValue = description;
	tiCatalog_item_code.dataValue     = code;
	tiCatalog_item_name.dataValue     = name;
	cbUnit.dataValue     = unit;
	
	setItemCost();
	
}

private function setItemCost():void
{
	tiCost.dataValue = (Number(tiPrice.dataValue)*Number(tiQuantity.dataValue)).toString();
}