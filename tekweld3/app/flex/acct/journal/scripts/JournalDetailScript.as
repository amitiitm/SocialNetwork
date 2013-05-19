import acct.journal.JournalModelLocator;

import business.events.GetInformationEvent;

import com.generic.events.DetailAddEditEvent;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.rpc.IResponder;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
private var __localModel:JournalModelLocator = (JournalModelLocator)(GenModelLocator.getInstance().activeModelLocator);

private function handleGLAccountItemChanged():void
{
	if(tiGlAccount.text != '' && tiGlAccount.text != null)
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(bankChangeEventHandler, null);
	
		var getInformationEvent:GetInformationEvent	=	new GetInformationEvent('paymentbank', callbacks, new GenDateField().currentDate(), tiGlAccount.dataValue);
		getInformationEvent.dispatch(); 
	}
}

private function bankChangeEventHandler(resultXml:XML):void
{
	tiGlName.dataValue	=	resultXml.children().child('bank_name').toString();
	tiGlCode.dataValue	=	resultXml.children().child('bank_code').toString();
}

private function creditAmtFocusOutHandler():void
{
	if(Number(tiCredit_amt.text) > 0)
	{
		tiDebit_amt.text	=	"0.00";
	}
}
private function debitAmtFocusOutHandler():void
{
	if(Number(tiDebit_amt.text) > 0)
	{
		tiCredit_amt.text	=	"0.00";
	}
}

override protected function retrieveRowEventHandler(event:DetailAddEditEvent):void
{
	//handleGLAccountItemChanged();
}