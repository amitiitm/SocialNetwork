import com.generic.events.AddEditEvent;
import com.generic.events.InboxEvent;

import melt.calculateoffer.CalculateOfferModelLocator;

import model.GenModelLocator;

import mx.controls.Alert;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:CalculateOfferModelLocator =  CalculateOfferModelLocator(__genModel.activeModelLocator)

private function handleInboxItemFocusOut(event:InboxEvent):void
{
 	var oldValue:String = event.oldValues["current_melting_stage_code"].toString();

	if(event.newValues["select_yn"] == 'Y')
	{
		inbox.focusedRow["current_melting_stage_code"] = 'CALCULATEOFFER';
	}
	else
	{
		inbox.focusedRow["current_melting_stage_code"] = oldValue;
	}  
}

override protected function preSaveEventHandler(event:AddEditEvent):int
{
	var retValue:int = 0;
	
	for(var i:int=0; i<inbox.dgDtl.dataProvider.length; i++)
	{
		if(inbox.dgDtl.dataProvider[i]["select_yn"] == "Y")
		{
			if(inbox.dgDtl.dataProvider[i]["offer_amt"] == '0.0')
			{
				retValue = -1;
				Alert.show("Please Calculate Offer first");
				break
			}						
		}	
	}

	return retValue;
}