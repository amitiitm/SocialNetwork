import business.events.GetInformationEvent;

import model.GenModelLocator;

import mx.rpc.IResponder;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

private function setCustomerInfo():void
{
	if(dcCustomer_Code.dataValue != "" && dcCustomer_Code.dataValue != null)
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(customerDetailsHandler, null);
		
		var getInformationEvent:GetInformationEvent	=	new GetInformationEvent('customerdetail', callbacks, dcCustomer_Code.dataValue, "I");
		getInformationEvent.dispatch();  
	}
	
}
private function customerDetailsHandler(resultXml:XML):void
{
	tiCustomer_code.text	= 	resultXml.children().child('code').toString()
	tiCustomer_name.text	=	resultXml.children().child('name').toString()
}