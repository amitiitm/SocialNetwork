import business.events.GetInformationEvent;

import com.generic.customcomponents.GenDateField;

import model.GenModelLocator;

import mx.rpc.IResponder;

[Bindable]
private var __genModel:GenModelLocator	=	GenModelLocator.getInstance();

private function GLAccountFocusOutHandler():void
{
	if(tiGlAccount.text != '' && tiGlAccount.text != null)
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(bankChangeEventHandler, null);
	
		var getInformationEvent:GetInformationEvent	=	new GetInformationEvent('depositbank', callbacks, new GenDateField().currentDate(), tiGlAccount.dataValue);
		getInformationEvent.dispatch(); 
	}
}

private function bankChangeEventHandler(resultXml:XML):void
{
	tiGlName.dataValue	=	resultXml.children().child('bank_name').toString();
	tiGlCode.dataValue	=	resultXml.children().child('bank_code').toString();
}