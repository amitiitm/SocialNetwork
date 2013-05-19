import com.generic.events.InboxEvent;
import melt.sendreminderoffer.SendReminderOfferModelLocator;
import model.GenModelLocator;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:SendReminderOfferModelLocator =  SendReminderOfferModelLocator(__genModel.activeModelLocator);

private function handleInboxItemFocusOut(event:InboxEvent):void
{
 	var oldValue:String = event.oldValues["current_melting_stage_code"].toString();

	if(event.newValues["select_yn"] == 'Y')
	{
		if(inbox.focusedRow["firstofferreminder"] != 'Y')
		{
			inbox.focusedRow["current_melting_stage_code"] = 'FIRSTOFFERREMINDER';	
		}
		else if(inbox.focusedRow["firstofferreminder"] == 'Y' && inbox.focusedRow["secondofferreminder"] != 'Y') 
		{
			inbox.focusedRow["current_melting_stage_code"] = 'SECONDOFFERREMINDER';
		}
		else
		{
			inbox.focusedRow["current_melting_stage_code"] = 'THIRDOFFERREMINDER';
		}
	}
	else
	{
		inbox.focusedRow["current_melting_stage_code"] = oldValue;
		inbox.focusedRow["remarks"] = '';
	}
}
