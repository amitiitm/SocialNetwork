import acct.journal.JournalModelLocator;

import business.events.GetInformationEvent;

import com.generic.events.AddEditEvent;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.formatters.NumberFormatter;
import mx.rpc.IResponder;

private var _numericFormatter:NumberFormatter = new NumberFormatter();
private var getInformationEvent:GetInformationEvent;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
private var __localModel:JournalModelLocator = (JournalModelLocator)(GenModelLocator.getInstance().activeModelLocator);

private function init():void
{
	_numericFormatter.precision	=	2;
	_numericFormatter.rounding	=	"nearest";
	_numericFormatter.useThousandsSeparator	=	false;
	
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

private function isTotalEqual():Boolean
{
	var i:int;
	var debitSum:Number	=	0.00;
	var creditSum:Number	=	0.00;
	var rows:XML;
	rows	=	journalDtl.dgDtl.rows
	
	for(i=0; i< rows.children().length(); i++)
	{
		debitSum	=	debitSum	+ Number(rows.children()[i].debit_amt)
		creditSum	=	creditSum	+ Number(rows.children()[i].credit_amt)
	}
	
	if(_numericFormatter.format(debitSum) == _numericFormatter.format(creditSum))
	{
		return true;	
	}
	
	return false;
}

override protected function preSaveEventHandler(event:AddEditEvent):int
{
	
	
	if(isTotalEqual())
	{
		return 0;
	}
	else
	{
		Alert.show('Debit Amount should equal to the Credit Amount');
		return 1;
	}
	return 0;
	
}

override protected function retrieveRecordEventHandler(event:AddEditEvent):void  //after save and prev,next,.....
{
	calculateAmount() 
}

override protected function resetObjectEventHandler():void   //on add buttton press,
{
	getAccountPeriod();
	calculateAmount()
}

private function calculateAmount():void
{
	var _debitAmount:Number = 0.00;
	var _creditAmount:Number = 0.00;
		
	for(var i:int = 0; i < journalDtl.dgDtl.dataProvider.length; i++)
	{
		_debitAmount 	= _debitAmount + (Number)(journalDtl.dgDtl.dataProvider[i].debit_amt);
		_creditAmount 	= _creditAmount + (Number)(journalDtl.dgDtl.dataProvider[i].credit_amt);
	}
		
	tiTotal_debit_amt.dataValue	=	_numericFormatter.format(String(_debitAmount));	
	tiTotal_credit_amt.dataValue = 	_numericFormatter.format(String(_creditAmount));
	
 	__localModel.total_debit_amt	=	tiTotal_debit_amt.dataValue;
 	__localModel.total_credit_amt	=	tiTotal_credit_amt.dataValue;
}
