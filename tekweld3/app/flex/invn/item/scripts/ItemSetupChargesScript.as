import business.events.GetInformationEvent;

import com.generic.customcomponents.GenDateField;

import model.GenModelLocator;

import mx.core.Application;
import mx.managers.CursorManager;
import mx.rpc.IResponder;
import mx.rpc.Responder;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

private   function setItemDetail():void
{
	if(dcItem.text != '' && dcItem.text != null)
	{
		
		CursorManager.setBusyCursor();
		Application.application.enabled	= false;
		
		var callbacks:IResponder					= new mx.rpc.Responder(getItemDetailsHandler, null);
		var getInformationEvent:GetInformationEvent = new GetInformationEvent('iteminfo', callbacks, dcItem.dataValue, new GenDateField().currentDate());
		getInformationEvent.dispatch()
			
		
	} 
	else
	{
		tiPrice.dataValue = '';
		taDescription.dataValue = '';
		tiSetupItemCode.dataValue     	= '';
		tiCatalog_item_name.dataValue		= ''
		cbUnit.dataValue	  = ''; 
		setItemCost();
	}
	
	
}

private function getItemDetailsHandler(resultXml:XML):void
{
	CursorManager.removeBusyCursor();
	Application.application.enabled	= true;
	
	var cost:String 				= resultXml.children().child('cost').toString()
	var description:String			= resultXml.children().child('name').toString()
	var code :String      			= resultXml.children().child('store_code').toString()	
	var name:String      			= resultXml.children().child('name').toString()
	var unit:String		 			= resultXml.children().child('unit').toString()
	
	tiPrice.dataValue 				= getRushCharges(code,Number(cost)).toString();
	taDescription.dataValue 		= description;
	tiSetupItemCode.dataValue   = code;
	tiCatalog_item_name.dataValue   = name;
	cbUnit.dataValue	  			= unit;
	
	setItemCost();
}

private function getRushCharges(itemCode:String,baseAmount:Number):Number
{
	if(itemCode=='RUSHDAY1')
	{
		return (baseAmount*35.00)/100.00;
	}
	else if(itemCode=='RUSHDAY2')
	{
		return (baseAmount*25.00)/100.00;
	}
	else
	return baseAmount;
}


private function setItemCost():void
{
	tiCost.dataValue = (Number(tiPrice.dataValue)*Number(tiQuantity.dataValue)).toString();
}
