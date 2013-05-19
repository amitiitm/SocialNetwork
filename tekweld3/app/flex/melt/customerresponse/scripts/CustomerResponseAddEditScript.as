import com.generic.events.InboxEvent;

import melt.customerresponse.CustomerResponseModelLocator;

import model.GenModelLocator;


[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:CustomerResponseModelLocator =  CustomerResponseModelLocator(__genModel.activeModelLocator);

private function handleInboxItemFocusOut(event:InboxEvent):void
{
 	var oldValue:String = event.oldValues["current_melting_stage_code"].toString();

	if(event.newValues["select_yn"] == 'Y')
	{
		if(event.object.id == 'accept_yn')
		{
			inbox.focusedRow["noresponse_yn"] = "";
			
			if(event.newValues["accept_yn"] == 'Y')
			{
				inbox.focusedRow["current_melting_stage_code"] = 'CUSTOMERRESPONSE_ACCEPT';
				inbox.focusedRow["reject_yn"] = "";
			}
			else
			{
				inbox.focusedRow["current_melting_stage_code"] = 'CUSTOMERRESPONSE_REJECT';
				inbox.focusedRow["reject_yn"] = "Y";
				inbox.focusedRow["accept_yn"] = "";
			} 
		}
		else if(event.object.id == 'reject_yn')
		{
			inbox.focusedRow["noresponse_yn"] = "";
			
			if(event.newValues["reject_yn"] == 'Y')
			{
				inbox.focusedRow["current_melting_stage_code"] = 'CUSTOMERRESPONSE_REJECT';
				inbox.focusedRow["accept_yn"] = "";
			}
			else
			{
				inbox.focusedRow["current_melting_stage_code"] = 'CUSTOMERRESPONSE_ACCEPT';
				inbox.focusedRow["accept_yn"] = "Y";
				inbox.focusedRow["reject_yn"] = "";
			} 
		}
		else if(event.object.id == 'select_yn')
		{
			inbox.focusedRow["current_melting_stage_code"] = 'CUSTOMERRESPONSE_NORESPONSE';
			inbox.focusedRow["accept_yn"] = "";
			inbox.focusedRow["reject_yn"] = "";
			inbox.focusedRow["noresponse_yn"] = "Y";
		}
		else if(event.object.id == 'noresponse_yn')
		{
			if(event.newValues["noresponse_yn"] == "Y")
			{
				inbox.focusedRow["current_melting_stage_code"] = 'CUSTOMERRESPONSE_NORESPONSE';
				inbox.focusedRow["accept_yn"] = "";
				inbox.focusedRow["reject_yn"] = "";	
			}
			else
			{
				inbox.focusedRow["noresponse_yn"] = "";
				inbox.focusedRow["accept_yn"] = "";
				inbox.focusedRow["reject_yn"] = "";	
				inbox.focusedRow["current_melting_stage_code"] = oldValue;
			}
		}
	}
	else
	{
		inbox.focusedRow["accept_yn"] = "";
		inbox.focusedRow["reject_yn"] = "";
		inbox.focusedRow["noresponse_yn"] = "";
		
		inbox.focusedRow["current_melting_stage_code"] = oldValue;
		inbox.focusedRow["customer_comments"] = '';
	}  
	
}
