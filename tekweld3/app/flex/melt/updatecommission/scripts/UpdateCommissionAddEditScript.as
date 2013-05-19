import com.generic.events.InboxEvent;

import melt.updatecommission.UpdateCommissionModelLocator;

import model.GenModelLocator;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:UpdateCommissionModelLocator  =  UpdateCommissionModelLocator(__genModel.activeModelLocator);

private function handleInboxItemFocusOut(event:InboxEvent):void
{
 	var oldValue:String = event.oldValues["current_melting_stage_code"].toString();

	if(event.newValues["select_yn"] == 'Y')
	{
		inbox.focusedRow["current_melting_stage_code"] = 'UPDATECOMMISSION';
		
	}
	else
	{
		inbox.focusedRow["current_melting_stage_code"] = oldValue;
	}  
}
