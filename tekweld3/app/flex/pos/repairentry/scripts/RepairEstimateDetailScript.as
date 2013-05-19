import business.events.GetInformationEvent;
import com.generic.events.DetailAddEditEvent;
import com.generic.genclass.GenNumberFormatter;

import model.GenModelLocator;

import mx.rpc.IResponder;
import mx.controls.Alert

import pos.repairentry.RepairEntryModelLocator;

private var numericFormatter:GenNumberFormatter = 	new GenNumberFormatter();

private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __localModel:RepairEntryModelLocator = (RepairEntryModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

private function init():void
{
	numericFormatter.precision = 2;
	numericFormatter.rounding = "nearest";
}

private function estimateTypeChangeHandler():void 
{
	setEstimateLookUp(cbEstimate_type.dataValue.toString());
	dcItemId.dataValue = ''
	resetObjects();
}	

private function setEstimateLookUp(estimateType:String):void
{	
		switch(estimateType.toUpperCase())
	{
		case 'S':
						dcItemId.dataSourceName =	'DiamondLot' 
						dcItemId.dataProvider   = 	__genModel.lookupObj.diamondlot.children();	
						break;
		case 'L':
						dcItemId.dataSourceName	=	'Labor' 
						dcItemId.dataProvider	=	__genModel.lookupObj.labor.children();
						break;
		default :
						dcItemId.dataValue 		=	'I'
						dcItemId.dataSourceName	=	'Item' 
						dcItemId.dataProvider	=	__genModel.lookupObj.item.children();
						break;
	}
}

private function estimateCodeChangeHandler():void 
{
	setEstimateDetails(cbEstimate_type.dataValue.toString());
	setQty();
	//calculateTotal();
}

private function setEstimateDetails(estimateType:String):void
{
	if(dcItemId.dataValue != '')
	{
		switch(estimateType.toUpperCase())
		{
			case 'S':
							var callbacks:IResponder = new mx..rpc.Responder(getStoneDetailsHandler, null);
							getInformationEvent	=	new GetInformationEvent('diamondlotinfo', callbacks, dcItemId.dataValue);
							getInformationEvent.dispatch(); 
							break;
			case 'L':
							var callbacks:IResponder = new mx..rpc.Responder(getLaborDetailsHandler, null);
							getInformationEvent	=	new GetInformationEvent('labor', callbacks, dcItemId.dataValue);
							getInformationEvent.dispatch(); 
							break;
			default : 
							var callbacks:IResponder = new mx.rpc.Responder(getItemDetailsHandler, null);
							getInformationEvent	= new GetInformationEvent('iteminfo', callbacks, dcItemId.dataValue, __localModel.trans_date);
							getInformationEvent.dispatch(); 
							break;
		}
	}
	else
	{	
		resetObjects();	
	}	
}

private function getItemDetailsHandler(resultXml:XML):void
{
	tiDescription.dataValue =	resultXml.children()[0].name.toString();
	tiCost.dataValue		=	resultXml.children()[0].cost.toString();
	tiPrice.dataValue		=	resultXml.children()[0].price.toString();
}

private function getLaborDetailsHandler(resultXml:XML):void
{
	tiDescription.dataValue =	resultXml.children()[0].description.toString();
	tiCost.dataValue		=	resultXml.children()[0].cost.toString();
	tiPrice.dataValue		=	resultXml.children()[0].price.toString();

}
private function getStoneDetailsHandler(resultXml:XML):void
{	
	tiDescription.dataValue =	resultXml.children()[0].description.toString();
	tiCost.dataValue		=	resultXml.children()[0].cost_per_ct.toString();
	tiPrice.dataValue		=	resultXml.children()[0].price_per_ct.toString();
}

private function calculateTotal():void
{
	tiTotal_cost.dataValue = numericFormatter.format(Number(tiCost.dataValue) * Number(tiQty.dataValue));
	
	tiTotal_price.dataValue = numericFormatter.format(Number(tiPrice.dataValue) * Number(tiQty.dataValue));
}

private function resetObjects():void
{
	tiDescription.dataValue =	tiDescription.defaultValue;
	tiCost.dataValue		=	tiCost.defaultValue;
	tiPrice.dataValue		=	tiPrice.defaultValue;
}

private function setQty():void
{
	var _qty:Number	=	Number(tiQty.text)
	
		if (String(_qty) == 'NaN' || String(_qty) == '' || _qty == 0) 
		{
			tiQty.text = numericFormatter.format(String(1));
		}	
}

override protected function preSaveRowEventHandler(event:DetailAddEditEvent):int
{
	tiEstimate_type_desc.dataValue = cbEstimate_type.text
	return 0;
}