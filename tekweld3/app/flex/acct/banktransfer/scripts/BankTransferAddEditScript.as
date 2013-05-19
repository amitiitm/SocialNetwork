import business.events.GetInformationEvent;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.formatters.NumberFormatter;
import mx.rpc.IResponder;

[Bindable]
private var __genModel:GenModelLocator	=	GenModelLocator.getInstance();
private var getInformationEvent:GetInformationEvent;
private var _numericFormatter:NumberFormatter = new NumberFormatter();

private function init():void
{
	getAccountPeriod();
}

private function getAccountPeriod():void
{
	if(dfTrans_date.text != '' && dfTrans_date.text != null)
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(getAccountPeriodHandler, null);
		
		getInformationEvent	=	new GetInformationEvent('accountperiod', callbacks, dfTrans_date.text);
		getInformationEvent.dispatch(); 
		
	}
}

private function getAccountPeriodHandler(resultXml:XML):void
{
	dcAccount_period_code.dataValue		=	resultXml.child('code');
	dcAccount_period_code.labelValue	=	resultXml.child('code');
}

private function bankChangeEvent():void
{
	if(dcAccount_Id.text != '' && dcAccount_Id.text != null)
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(bankChangeEventHandler, null);
	
		getInformationEvent	=	new GetInformationEvent('transferbank', callbacks, dfTrans_date.text, dcAccount_Id.dataValue);
		getInformationEvent.dispatch(); 
	}	
}

private function bankChangeEventHandler(resultXml:XML):void
{	
	tiAccount_code.dataValue		=	resultXml.children().child('bank_code').toString();
	dcAccount_Id.labelValue			=	resultXml.children().child('bank_code').toString();
	dcAccount_Id.dataValue			=	resultXml.children().child('bank_id').toString();
	tiFromBank_name.dataValue		=	resultXml.children().child('bank_name').toString();
	tiCheck_no.dataValue			=	resultXml.children().child('check_no').toString();
	cbPayment_type.dataValue		=	resultXml.children().child('payment_type').toString();
}

private function AccountIdChangeEvent():void
{
	if(dcBank_Id.text != '' && dcBank_Id.text != null)
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(AccountIdChangeEventHandler, null);
	
		getInformationEvent	=	new GetInformationEvent('depositbank', callbacks, dfTrans_date.text, dcBank_Id.dataValue);
		getInformationEvent.dispatch(); 
	}	
}

private function AccountIdChangeEventHandler(resultXml:XML):void
{
	tiBank_code.dataValue		=	resultXml.children()[0]['bank_code'].toString();
	dcBank_Id.labelValue		=	resultXml.children()[0]['bank_code'].toString();	
	dcBank_Id.dataValue			=	resultXml.children()[0]['bank_id'].toString(); 
	tiInToBank_name.dataValue	=	resultXml.children()[0]['bank_name'].toString();	
}

override protected function resetObjectEventHandler():void   //on add buttton press,
{
	getAccountPeriod();
}
