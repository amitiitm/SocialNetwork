import com.generic.events.InboxEvent;

import melt.customerresponsereject.CustomerResponseRejectModelLocator;

import model.GenModelLocator;


[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:CustomerResponseRejectModelLocator =  CustomerResponseRejectModelLocator(__genModel.activeModelLocator);

private function handleInboxItemFocusOut(event:InboxEvent):void
{
 	var oldValue:String = event.oldValues["current_melting_stage_code"].toString();

	if(event.newValues["select_yn"] == 'Y')
	{
		if(event.object.id == 'noresponse_yn')
		{
			if(event.newValues["noresponse_yn"] == 'Y')
			{
				inbox.focusedRow["current_melting_stage_code"] = 'CUSTOMERRESPONSE_NORESPONSE';
				inbox.focusedRow["reject_yn"] = "";
			}
			else
			{
				inbox.focusedRow["current_melting_stage_code"] = 'CUSTOMERRESPONSE_REJECT';
				inbox.focusedRow["reject_yn"] = "Y";
				inbox.focusedRow["noresponse_yn"] = "";
			} 
		}
		else if(event.object.id == 'reject_yn')
		{
			if(event.newValues["reject_yn"] == 'Y')
			{
				inbox.focusedRow["current_melting_stage_code"] = 'CUSTOMERRESPONSE_REJECT';
				inbox.focusedRow["noresponse_yn"] = "";
			}
			else
			{
				inbox.focusedRow["current_melting_stage_code"] = 'CUSTOMERRESPONSE_NORESPONSE';
				inbox.focusedRow["reject_yn"] = "";
				inbox.focusedRow["noresponse_yn"] = "Y";
			} 
		}
		else if(event.object.id == 'select_yn')
		{
			inbox.focusedRow["current_melting_stage_code"] = 'CUSTOMERRESPONSE_NORESPONSE';
			inbox.focusedRow["reject_yn"] = "";
			inbox.focusedRow["noresponse_yn"] = "Y";
		}
	}
	else
	{
		inbox.focusedRow["reject_yn"] = "";
		inbox.focusedRow["noresponse_yn"] = "";
		inbox.focusedRow["current_melting_stage_code"] = oldValue;
	}  
	
	
}
