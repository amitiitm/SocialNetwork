import com.generic.events.AddEditEvent;
import model.GenModelLocator;

import business.events.GetInformationEvent;
import mx.controls.Alert;
import mx.rpc.IResponder;

[Bindable]
public var __genModel:GenModelLocator = GenModelLocator.getInstance();
public var bankChargeAcctCode:String;
public var bankChargeAcctId:String;

private var getInformationEvent:GetInformationEvent;

private function init():void
{
	getAccountPeriod();
	getBankChargeAccount();
}

private function getAccountPeriod():void
{
	if(dfTrans_date.text != '' && dfTrans_date.text != null)
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(getAccountPeriodHandler, null);
		
		getInformationEvent	=	new GetInformationEvent('accountperiod',callbacks, dfTrans_date.text);
		getInformationEvent.dispatch(); 
	}
}

private function getAccountPeriodHandler(resultXml:XML):void
{
	dcAccount_period_code.dataValue		=	resultXml.child('code');
	dcAccount_period_code.labelValue	=	resultXml.child('code');
}

private function getBankChargeAccount():void
{
	var callbacks:IResponder = new mx.rpc.Responder(getBankChargeAccountHandler, null);
	getInformationEvent = new GetInformationEvent('bank_check_info', callbacks, '');
	getInformationEvent.dispatch();	
}

private function getBankChargeAccountHandler(resultXml:XML):void
{
	bankChargeAcctCode	=	resultXml.children().child('bank_charge_account_code').toString();
	bankChargeAcctId	=	resultXml.children().child('bank_charge_account_id').toString();
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
	else if(dcAccount_Id.text != '' && dcAccount_Id.text != null && cbAccount_Type.dataValue == 'G')
	{
		var callbacks:IResponder = new mx.rpc.Responder(GLAccountDetailsHandler, null);
		getInformationEvent = new GetInformationEvent('paymentbank', callbacks, new GenDateField().currentDate(), dcAccount_Id.dataValue);
		getInformationEvent.dispatch();
	}
}

private function accountDetailsHandler(resultXml:XML):void
{
	tiPayTo.text			=	resultXml.children().child('name').toString()
	dcAccount_Id.labelValue	=	resultXml.children().child('code').toString()
	dcAccount_Id.dataValue	=	resultXml.children().child('id').toString()
}

private function GLAccountDetailsHandler(resultXml:XML):void
{
	tiPayTo.text			=	resultXml.children().child('bank_name').toString()
	dcAccount_Id.labelValue	=	resultXml.children().child('bank_code').toString()
	dcAccount_Id.dataValue	=	resultXml.children().child('bank_id').toString()
}

private function accountTypeChangeEvent():void
{
	setAccountLookUp(cbAccount_Type.dataValue.toString());
	dcAccount_Id.dataValue	=	'';
	dcAccount_Id.labelValue	=	'';
	tiPayTo.text	=	'';
}

private function setAccountLookUp(accountType:String):void
{
	switch(accountType.toUpperCase())
	{
		 case 'C':
		 		dcAccount_Id.dataSourceName	=	'CustomerWholesale'
		 		dcAccount_Id.minimumChar	=	__genModel.masterData.child('lookup').customerwholesale.value
				dcAccount_Id.toolTip		=	'Customer #'
		        
		        break;
		case 'V':
		        dcAccount_Id.dataSourceName	=	'Vendor'
				dcAccount_Id.minimumChar	=	__genModel.masterData.child('lookup').vendor.value
				dcAccount_Id.toolTip		=	'Vendor #'	
		        
		        break;
		case 'G':
				dcAccount_Id.dataSourceName	=	'GLAccount'
				dcAccount_Id.minimumChar	=	__genModel.masterData.child('lookup').glaccount.value
				dcAccount_Id.toolTip		=	'GLAccount #'	
		        
		        break;                    
		default:
        		dcAccount_Id.dataSourceName	=	'CustomerWholesale'
				dcAccount_Id.minimumChar	=	__genModel.masterData.child('lookup').customerwholesale.value
				dcAccount_Id.toolTip		=	'Customer #'
		        
		        break;
	}
}

private function refTransNoChangeEvent():void
{
	if(tiRrf_trans_no.text != '' && tiRrf_trans_no.text != null)
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(resultHandler, null);
	
		getInformationEvent	=	new GetInformationEvent('void_bounce_info', callbacks, cbRef_trans_type.dataValue, tiRrf_trans_no.dataValue,'','','T');
		getInformationEvent.dispatch(); 
	}	
}

private function checkNoChangeEvent():void
{
	if(tiCheck_no.text != '' && tiCheck_no.text != null)
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(resultHandler, null);
	
		getInformationEvent	=	new GetInformationEvent('void_bounce_info', callbacks, cbRef_trans_type.dataValue,'',dcBank_Id.dataValue,tiCheck_no.dataValue,'C');
		getInformationEvent.dispatch(); 
	}	
}

private function resultHandler(resultXml:XML):void
{
	if(resultXml.children().length() > 0)
	{
		tiRrf_trans_no.dataValue 	=	resultXml.children().child('trans_no').toString();
		tiRef_trans_bk.dataValue 	=	resultXml.children().child('trans_bk').toString();
		dfRef_trans_date.dataValue	= 	resultXml.children().child('trans_date').toString();
		dcBank_Id.dataValue			=	resultXml.children().child('bank_id').toString();
		dcBank_Id.labelValue		=	resultXml.children().child('bank_code').toString();
		tiBank_code.dataValue		=	resultXml.children().child('bank_code').toString();
		dcAccount_Id.dataValue		=	resultXml.children().child('account_id').toString();
		dcAccount_Id.labelValue		=	resultXml.children().child('account_code').toString();
		tiAccount_code.dataValue	=	resultXml.children().child('account_code').toString();
		tiCheck_no.dataValue		=	resultXml.children().child('check_no').toString();
		dfCheck_date.dataValue		=	resultXml.children().child('check_date').toString();
		cbAccount_Type.dataValue	=	resultXml.children().child('account_flag').toString();
		
		if(cbRef_trans_type.dataValue.toUpperCase() == 'DEPS')
		{
			tiAmt.dataValue		 	=	resultXml.children().child('credit_amt').toString();
			tiDebitAmt.dataValue	= 	resultXml.children().child('credit_amt').toString();
			tiCreditAmt.dataValue 	= 	'0.00';
			tiTransType.dataValue	=	'PAYM';
		}
		else 
		{
			tiAmt.dataValue			=	resultXml.children().child('debit_amt').toString();
			tiCreditAmt.dataValue 	= 	resultXml.children().child('debit_amt').toString();
			tiDebitAmt.dataValue 	= 	'0.00';
			tiTransType.dataValue	=	'DEPS';
		}
	
		AccountIdChangeEvent()
	}
	else
	{
		Alert.show('no record found !')
	}
}

private function  voidBounceChangeHandler():void
{
	if(cbVoidBounceCheck.dataValue.toUpperCase() == 'V')
	{
		dcBank_charges_acct_id.dataValue = '';
		dcBank_charges_acct_id.labelValue = '';
		tiBank_charges_acct_code.dataValue = '';

		dcBank_charges_acct_id.enabled = false;
		tiBankChargesAmt.enabled = false;
		tiBankChargesAmt.dataValue = '0.00';
		vbBankCharges.enabled = false;
	}
	else
	{
		dcBank_charges_acct_id.enabled = true;
		tiBankChargesAmt.enabled = true;
		dcBank_charges_acct_id.dataValue = bankChargeAcctId;
		dcBank_charges_acct_id.labelValue = bankChargeAcctCode;
		tiBank_charges_acct_code.dataValue = bankChargeAcctCode;
		vbBankCharges.enabled = true;
	}
}
 
private function refTypeChangeHandler():void
{
		tiRrf_trans_no.dataValue 	=	'';
		tiRef_trans_bk.dataValue 	=	'';
		dfRef_trans_date.dataValue	= 	dfRef_trans_date.defaultValue;
		dcAccount_Id.dataValue		=	'';
		dcAccount_Id.labelValue		=	'';
		tiAccount_code.dataValue	=	'';
		tiCheck_no.dataValue		=	'';
		tiPayTo.dataValue			=	'';
		dfCheck_date.dataValue		=	dfCheck_date.defaultValue;
		cbAccount_Type.dataValue	=	'C';
		
		tiAmt.dataValue		 		=	'0.00';
		tiDebitAmt.dataValue		= 	'0.00';
		tiCreditAmt.dataValue 		= 	'0.00';
		
		tiTransType.dataValue		=	'';	

}
 
override protected function retrieveRecordEventHandler(event:AddEditEvent):void
{
	var resultXml:XML = event.recordXml;
	
	if(cbRef_trans_type.dataValue.toUpperCase() == 'DEPS')
	{
		tiAmt.dataValue	  =	 resultXml.children().child('debit_amt').toString();
	}
	else 
	{
		tiAmt.dataValue	  =	 resultXml.children().child('credit_amt').toString();
	}
	
	voidBounceChangeHandler();
}

override protected function resetObjectEventHandler():void
{
	getAccountPeriod();
	tiAmt.dataValue	= '0.00'
	voidBounceChangeHandler();
	refTypeChangeHandler();
	getBankChargeAccount();
}
