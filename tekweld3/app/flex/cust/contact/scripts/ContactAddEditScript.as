import crm.otheraddress.components.*;
import com.generic.events.AddEditEvent;
import model.GenModelLocator;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance() 

private function init():void
{
	//dfDate_of_birth.dataValue = ""
	//dfSPDate_of_birth.dataValue = ""
	//dfDate_of_marraige.dataValue = ""
}

override protected function resetObjectEventHandler():void
{
	//dfDate_of_birth.dataValue = ""
	//dfSPDate_of_birth.dataValue = ""
	//dfDate_of_marraige.dataValue = ""
	
//	tiCode.enabled = true;
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
		