import com.generic.events.AddEditEvent;
import com.generic.events.InboxEvent;

import model.GenModelLocator;

import mx.controls.Alert;

import prod.cut.CutModelLocator;



[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:CutModelLocator =  CutModelLocator(__genModel.activeModelLocator);

private function handleInboxItemFocusOut(event:InboxEvent):void
{
 	var oldValue:String = event.oldValues["cut_flag"].toString();

	if(event.newValues["select_yn"] == 'Y')
	{
		inbox.focusedRow["cut_flag"] = 'Y';
	}
	else
	{
		inbox.focusedRow["cut_flag"] = 'N';
	}  
		
}
override protected function preSaveEventHandler(event:AddEditEvent):int
{
	var retValue:int = 0;
	
	/*for(var i:int=0; i<inbox.dgDtl.dataProvider.length; i++)
	{
		if(inbox.dgDtl.dataProvider[i]["select_yn"] == "Y")
		{
			if(inbox.dgDtl.dataProvider[i]["indigo_code"] == '')
			{
				retValue = -1;
				Alert.show("Please Enter INDIGO #");
				break
			}						
		}	
	}*/

	return retValue;
}

