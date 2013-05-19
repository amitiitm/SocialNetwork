import com.generic.customcomponents.GenDateField;
import com.generic.events.AddEditEvent;
import com.generic.events.InboxEvent;

import melt.updatecommissionencashdate.UpdateCommissionEncashDateModelLocator;

import model.GenModelLocator;

import mx.controls.Alert;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:UpdateCommissionEncashDateModelLocator  =  UpdateCommissionEncashDateModelLocator(__genModel.activeModelLocator);


private function handleInboxItemFocusOut(event:InboxEvent):void
{
 	var oldValue:String = event.oldValues["current_melting_stage_code"].toString();
	var oldDate:String = event.oldValues["encash_commission_date"].toString();
	var currentDt:String = event.newValues["encash_commission_date"].toString();	
	
	

	if(event.newValues["select_yn"] == 'Y')
	{
		inbox.focusedRow["current_melting_stage_code"] = 'ENCASHCOMMISSIONCHECK';
		
		if(event.newValues["encash_commission_date"] == '')
		{
			inbox.focusedRow["encash_commission_date"] = new GenDateField().currentDate();
		}
	}
	else
	{
		inbox.focusedRow["current_melting_stage_code"] = oldValue;
		
		if(oldDate != currentDt)
		{
			inbox.focusedRow["encash_commission_date"] = oldDate;
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
			if(inbox.dgDtl.dataProvider[i]["encash_commission_date"] == "")
			{
				retValue = -1;
				Alert.show("Please enter Encashed Date !!")
				break
			}						
		}	
	}

	return retValue;
}
