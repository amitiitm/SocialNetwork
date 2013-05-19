import com.generic.events.InboxEvent;

import melt.verifycheckstatus.VerifyCheckStatusModelLocator;

import model.GenModelLocator;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:VerifyCheckStatusModelLocator  =  VerifyCheckStatusModelLocator(__genModel.activeModelLocator);

private function handleInboxItemFocusOut(event:InboxEvent):void
{
 	var oldValue:String = event.oldValues["current_melting_stage_code"].toString();

	if(event.newValues["select_yn"] == 'Y')
	{
		inbox.focusedRow["encashed_check"] = 'Y'
		inbox.focusedRow["current_melting_stage_code"] = 'VERIFYCHECK';
	}
	else
	{
		inbox.focusedRow["encashed_check"] = 'N'
		inbox.focusedRow["current_melting_stage_code"] = oldValue;
	}  
}
