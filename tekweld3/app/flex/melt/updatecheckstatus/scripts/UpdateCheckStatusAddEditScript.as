import com.generic.customcomponents.GenDateField;
import com.generic.events.AddEditEvent;
import com.generic.events.InboxEvent;

import melt.updatecheckstatus.UpdateCheckStatusModelLocator;

import model.GenModelLocator;

import mx.controls.Alert;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:UpdateCheckStatusModelLocator  =  UpdateCheckStatusModelLocator(__genModel.activeModelLocator);

private function handleInboxItemFocusOut(event:InboxEvent):void
{
 	var oldValue:String = event.oldValues["current_melting_stage_code"].toString();
	var oldDate:String = event.oldValues["check_encashed_date"].toString();
	var currentDt:String = event.newValues["check_encashed_date"].toString();
	
	if(event.newValues["select_yn"] == 'Y')
	{
		inbox.focusedRow["current_melting_stage_code"] = 'UPDATECHECKSTATUS';
		
		
		if(event.newValues["check_encashed_date"] == '')
		{
			inbox.focusedRow["check_encashed_date"] = new GenDateField().currentDate();
		}
	}
	else
	{
		inbox.focusedRow["current_melting_stage_code"] = oldValue;
		
		if(oldDate != currentDt)
		{
			inbox.focusedRow["check_encashed_date"] = oldDate;
		}
	}  
}

override protected function preSaveEventHandler(event:AddEditEvent):int
{
	var retValue:int = 0;
	
	for(var i:int=0; i<inbox.dgDtl.dataProvider.length; i++)
	{
		if(inbox.dgDtl.dataProvider[i]["select_yn"] == "Y")
		{
			if(inbox.dgDtl.dataProvider[i]["check_encashed_date"] == "")
			{
				retValue = -1;
				Alert.show("Please enter Encashed Date !!")
				break
			}						
		}	
	}

	return retValue;
}
