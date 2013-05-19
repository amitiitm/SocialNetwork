import business.events.GetInformationEvent;

import com.generic.events.AddEditEvent;
import com.generic.events.InboxEvent;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.core.Application;
import mx.managers.CursorManager;
import mx.rpc.IResponder;

import saoi.sendforestimation.SendForEstimationModelLocator;



[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:SendForEstimationModelLocator =  SendForEstimationModelLocator(__genModel.activeModelLocator);

private function handleInboxItemFocusOut(event:InboxEvent):void
{
	var colName:String;
	var rowIndex:int;
	colName = event.object.id
	rowIndex = event.currentTarget.editBarRowPosition;
	
	if(event.newValues["select_yn"] == 'Y')
	{
		inbox.focusedRow["send_for_estimation_flag"] = 'Y';
	}
	else
	{
		inbox.focusedRow["send_for_estimation_flag"] = 'N';
	}
	
	if(colName == "vendor_code")
	{
		if(event.object.text != null && event.object.text != '')
		{
			inbox.focusedRow["vendor_id"]	 = event.object.dataValue;
			inbox.focusedRow["vendor_code"]	 = event.object.labelValue;
		}
		else
		{
			inbox.focusedRow["vendor_id"]	 = ''
			inbox.focusedRow["vendor_code"]	 = ''
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
			if(inbox.dgDtl.dataProvider[i]["vendor_id"] == '')
			{
				retValue = -1;
				Alert.show("Please Enter Vendor");
				break
			}						
		}	
	}
	return retValue;
}
