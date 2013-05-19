import business.events.GetInformationEvent;

import com.generic.events.AddEditEvent;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.formatters.NumberFormatter;
import mx.rpc.IResponder;

private var getInformationEvent:GetInformationEvent;
private var _numericFormatter:NumberFormatter = new NumberFormatter();

[Bindable]
private var __genModel:GenModelLocator	=	GenModelLocator.getInstance();

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
	if(dcBank_Id.text != '' && dcBank_Id.text != null)
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(bankChangeEventHandler, null);
		
		getInformationEvent	=	new GetInformationEvent('paymentbank', callbacks, dfTrans_date.text, dcBank_Id.dataValue);
		getInformationEvent.dispatch(); 
	}
}

private function bankChangeEventHandler(resultXml:XML):void
{
	tiBank_name.dataValue		=	resultXml.children().child('bank_name').toString();
	tiBank_code.dataValue		= 	resultXml.children().child('bank_code').toString();
	dcBank_Id.labelValue		= 	resultXml.children().child('bank_code').toString();
	dcBank_Id.dataValue			= 	resultXml.children().child('bank_id').toString();
	tiCheck_no.text				=	resultXml.children().child('check_no').toString();
	cbPayment_type.dataValue	=	resultXml.children().child('payment_type').toString();
}

private function handlePaymentTypeChange():void
{
	if(dcBank_Id.text != '' &&  dcBank_Id.text != null)
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(paymentTypeChangeResultHandler, null);
		getInformationEvent	=	new GetInformationEvent('paymenttypechange', callbacks, dcBank_Id.dataValue , cbPayment_type.dataValue);
		getInformationEvent.dispatch();	
	}
}

private function paymentTypeChangeResultHandler(resultXml:XML):void
{
	tiCheck_no.text	=	resultXml.children().child('check_no').toString();
}

private function accountTypeChangeEvent():void
{
	setAccountLookUp(cbAccount_Type.dataValue.toString());
	dcAccount_Id.dataValue	=	'';
	dcAccount_Id.labelValue	=	'';
	tiPayTo.text	=	'';
}

private function AccountIdChangeEvent():void
{
	if(dcAccount_Id.text != '' && dcAccount_Id.text != null && cbAccount_Type.dataValue == 'V')
	{
		var callbacks:IResponder = new mx.rpc.Responder(accountDetailsHandler, null);
		getInformationEvent = new GetInformationEvent('vendorinfo', callbacks, dcAccount_Id.dataValue);
		getInformationEvent.dispatch();	
		
	}	
	else if(dcAccount_Id.text != '' && dcAccount_Id.text != null && cbAccount_Type.dataValue == 'C')
	{
		var callbacks:IResponder = new mx.rpc.Responder(accountDetailsHandler, null);
		getInformationEvent = new GetInformationEvent('customerdetail', callbacks, dcAccount_Id.dataValue);
		getInformationEvent.dispatch();
	}
}

private function accountDetailsHandler(resultXml:XML):void
{
	tiPayTo.text			=	resultXml.children().child('name').toString()
	dcAccount_Id.labelValue	=	resultXml.children().child('code').toString()
	dcAccount_Id.dataValue	=	resultXml.children().child('id').toString()
}

private function setAccountLookUp(accountType:String):void
{
	if(accountType.toUpperCase() != 'G')
	{
		if(paymentDtl.dgDtl.rows.children().length() > 0)
		{
			for(var i:int=paymentDtl.dgDtl.rows.children().length() - 1; i >= 0; i--)
			{
				paymentDtl.deleteRow(i);
			}
		}
	}
	
	switch(accountType.toUpperCase())
	{
		 case 'C':
		 		dcAccount_Id.dataSourceName	=	'CustomerWholesale'
		 		dcAccount_Id.minimumChar	=	__genModel.masterData.child('lookup').customerwholesale.value
				dcAccount_Id.toolTip		=	'Customer #'
		 		paymentDtl.enabled	=	false;
		 		dcAccount_Id.enabled	=	true;
		        
		        break;
		case 'V':
		        dcAccount_Id.dataSourceName	=	'Vendor'
		        dcAccount_Id.minimumChar	=	__genModel.masterData.child('lookup').vendor.value
				dcAccount_Id.toolTip		=	'Vendor #'	
		        paymentDtl.enabled	=	false;
		        dcAccount_Id.enabled	=	true;
		        
		        break;
		case 'G':
		        paymentDtl.enabled	=	true;
		        dcAccount_Id.enabled	=	false;
		        
		        break;                    
		default:
        		dcAccount_Id.dataSourceName	=	'CustomerWholesale'
        		dcAccount_Id.minimumChar	=	__genModel.masterData.child('lookup').customerwholesale.value
				dcAccount_Id.toolTip		=	'Customer #'
		 		paymentDtl.enabled	=	false;
		 		dcAccount_Id.enabled	=	true;
		        
		        break;
	}
}

override protected function preSaveEventHandler(event:AddEditEvent):int
{
	if(cbAccount_Type.dataValue.toString().toUpperCase()!="G")
	{
		if(dcAccount_Id.text == '' || dcAccount_Id.text == null)
		{
			Alert.show('Account # is required');
			return 1;
		} 
		
		paymentDtl.dgDtl.rows  = new XML('<' + paymentDtl.rootNode + '/>');
	}
	else
	{
		_numericFormatter.precision	=	2;
		_numericFormatter.rounding	=	"nearest";
		_numericFormatter.useThousandsSeparator	=	false;

		var i:int;
		var debitSum:Number	=	0.00;
		var rows:XML;
		rows	=	paymentDtl.dgDtl.rows
		for(i=0; i< rows.children().length(); i++)
		{
			debitSum	=	debitSum	+ Number(rows.children()[i].debit_amt)
		}
		
		if(Number(_numericFormatter.format(debitSum))	==	Number(tiDebitAmt.text))
		{
			return 0
		}
		else
		{
			Alert.show('Amount must equal to the total debit Amount');
			return 1;
		}
	}
	
	return 0;
}

override protected function retrieveRecordEventHandler(event:AddEditEvent):void  //after save and prev,next,.....
{
	setAccountLookUp(event.recordXml.children().child('account_flag').toString());
	
	dcAccount_Id.dataValue	= 	event.recordXml.children().child('account_id').toString()
	dcAccount_Id.labelValue	=	event.recordXml.children().child('account_code').toString()
	dcAccount_Id.enabled		= 	false;
			
	cbAccount_Type.enabled	=	false;
	
}

override protected function resetObjectEventHandler():void   //on add buttton press,
{
	cbAccount_Type.enabled	=	true;
	dcAccount_Id.enabled	=	true;
	accountTypeChangeEvent(); 
	getAccountPeriod();
}
