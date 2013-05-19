import com.generic.events.InboxEvent;

import melt.sendremindercheckdeposit.SendReminderCheckDepositModelLocator;

import model.GenModelLocator;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:SendReminderCheckDepositModelLocator =  SendReminderCheckDepositModelLocator(__genModel.activeModelLocator);

private function handleInboxItemFocusOut(event:InboxEvent):void
{
 	var oldValue:String = event.oldValues["current_melting_stage_code"].toString();

	if(event.newValues["select_yn"] == 'Y')
	{
		if(inbox.focusedRow["firstdepositreminder"] != 'Y')
		{
			inbox.focusedRow["current_melting_stage_code"] = 'FIRSTDEPOSITREMINDER';	
		}
		else
		{
			inbox.focusedRow["current_melting_stage_code"] = 'SECONDDEPOSITREMINDER';
		}
	}
	else
	{
		inbox.focusedRow["current_melting_stage_code"] = oldValue;
	}  
}
