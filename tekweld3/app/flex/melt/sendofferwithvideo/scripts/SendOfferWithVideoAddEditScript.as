import com.generic.events.AddEditEvent;
import com.generic.events.InboxEvent;

import melt.sendofferwithvideo.SendOfferWithVideoModelLocator;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.events.CloseEvent;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:SendOfferWithVideoModelLocator =  SendOfferWithVideoModelLocator(__genModel.activeModelLocator);
[Bindable]
private var retValue:int

private function handleInboxItemFocusOut(event:InboxEvent):void
{
 	var oldValue:String = event.oldValues["current_melting_stage_code"].toString();

	if(event.newValues["select_yn"] == 'Y')
	{
		inbox.focusedRow["current_melting_stage_code"] = 'SENDOFFERWITHVIDEO';
	}
	else
	{
		inbox.focusedRow["current_melting_stage_code"] = oldValue;
	}  
}



