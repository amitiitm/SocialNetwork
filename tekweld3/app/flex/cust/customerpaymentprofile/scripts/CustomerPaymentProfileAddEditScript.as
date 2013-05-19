import com.generic.events.AddEditEvent;

import crm.otheraddress.components.*;

import model.GenModelLocator;

import mx.controls.Alert;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance() 

private function init():void
{
}

override protected function resetObjectEventHandler():void
{
	dcCustomer_id.enabled   = true;
	if(__genModel.objectFromQuickAdd.children().length()>0)
	{
		dcCustomer_id.dataValue   = __genModel.objectFromQuickAdd.children()[0].toString();   // customer_id
		dcCustomer_id.labelValue  = __genModel.objectFromQuickAdd.children()[1].toString();		// customer_code
		tiCustomerCode.dataValue  = __genModel.objectFromQuickAdd.children()[1].toString();		// customer_code
	}
}

override protected function retrieveRecordEventHandler(event:AddEditEvent):void 
{
	//tiCode.enabled = false;
	dcCustomer_id.enabled   = false;
	
	var recordXml:XML		= event.recordXml.copy();
	var alert_msg:String	= recordXml.children()[0].message.toString();
	Alert.show(alert_msg);
	
}
	