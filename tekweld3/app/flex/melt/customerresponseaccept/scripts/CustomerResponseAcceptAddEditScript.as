import com.generic.events.InboxEvent;

import melt.customerresponseaccept.CustomerResponseAcceptModelLocator;

import model.GenModelLocator;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:CustomerResponseAcceptModelLocator =  CustomerResponseAcceptModelLocator(__genModel.activeModelLocator);


private function handleInboxItemFocusOut(event:InboxEvent):void
{
 	var oldValue:String = event.oldValues["current_melting_stage_code"].toString();

	 if(event.newValues["select_yn"] == 'Y')
	{
		inbox.focusedRow["current_melting_stage_code"] = 'CUSTOMERRESPONSE_ACCEPT';
		
	}
	else
	{
		inbox.focusedRow["current_melting_stage_code"] = oldValue;
	}  
}
