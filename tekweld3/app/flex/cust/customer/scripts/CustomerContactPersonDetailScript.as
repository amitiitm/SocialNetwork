import com.generic.events.DetailAddEditEvent;

import crm.account.AccountModelLocator;

import cust.customer.CustomerMasterModelLocator;

import model.GenModelLocator;

import mx.controls.Alert;

[Bindable]
private var __localModel:CustomerMasterModelLocator = (CustomerMasterModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance()

private function init():void
{
	//dfDate_of_birth.dataValue = ""
	//dfDate_of_marraige.dataValue = ""
	
	tiCustomer_id.dataValue = __localModel.customer_id
}

override protected function resetObjectEventHandler():void
{
	//dfDate_of_birth.dataValue = ""
	//dfDate_of_marraige.dataValue = ""
	
	//tiCode.enabled = true;
	tiCustomer_id.dataValue = __localModel.customer_id
}


override protected function retrieveRowEventHandler(event:DetailAddEditEvent):void
{
	/*var _resultXml:XML = event.rowXml

	if(_resultXml["id"].toString() > 0)
	{
		tiCode.enabled = false;
	}*/
}
private function setBillingAddress():void
{
	if(cbCopyBillingAddress.dataValue=='Y')
	{
		tiAddress_1.dataValue 		= 	__localModel.billing_address.address1 ;
		tiAddress_2.dataValue		= 	__localModel.billing_address.address2;
		tiCity.dataValue			=	__localModel.billing_address.city;
		tiState.dataValue			=   __localModel.billing_address.state;
		tiZip.dataValue				=	__localModel.billing_address.zip;
		tiCountry.dataValue			=	__localModel.billing_address.country;
		tiBusiness_phone.dataValue	=	__localModel.billing_address.phone1;
		tiManager_phone.dataValue	=	__localModel.billing_address.phone2;
		tiFax.dataValue				= 	__localModel.billing_address.fax;
	}
	
}
private function setPrimaryAddress():void
{
	if(cbCopyPrimaryAddress.dataValue=='Y')
	{
		tiSecondaryAddress_name.dataValue	= tiAddress_name.dataValue;
		tiSecondaryAddress1.dataValue		= tiAddress_1.dataValue;
		tiSecondaryAddress2.dataValue		= tiAddress_2.dataValue;
		tiSecondaryCity.dataValue			= tiCity.dataValue;
		tiSecondaryCountry.dataValue		= tiCountry.dataValue;
		tiSecondaryState.dataValue			= tiState.dataValue;
		tiSecondaryZip.dataValue			= tiZip.dataValue;
		tiSecFax.dataValue					= tiFax.dataValue;
		tiSecEmail.dataValue				= tiEmail.dataValue;
		tiSecCell.dataValue					= tiCell_phone.dataValue;
		tiSecPhone.dataValue				= tiBusiness_phone.dataValue;
	}
}