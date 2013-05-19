import com.generic.events.DetailAddEditEvent;

import model.GenModelLocator;
import crm.account.AccountModelLocator;
import mx.controls.Alert;

[Bindable]
private var __localModel:AccountModelLocator = (AccountModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance()


private function init():void
{
	dfStart_date.dataValue = ""
	dfEnd_date.dataValue = ""
	dfDue_date.dataValue = ""
	tiCRM_account_id.dataValue = __localModel.account_id
	
	dcCRM_contact_id.filterKeyValue = tiCRM_account_id.dataValue
}

private function handleReminderChange(event:Event):void
{
	if(cbReminder_flag.selected)
	{
		dfReminder_date_time.text = dfReminder_date_time.currentDate();
		dfReminder_date_time.enabled = true
	}
	else
	{
		dfReminder_date_time.text = ''
		dfReminder_date_time.enabled = false
	}
} 


protected override function retrieveRowEventHandler(event:DetailAddEditEvent):void
{
		var rowXml:XML	= event.rowXml;
	dcCRM_contact_id.filterKeyValue = tiCRM_account_id.dataValue;
	dcCRM_contact_id.dataValue =  rowXml["crm_contact_id"];
}

override protected function resetObjectEventHandler():void
{
	dfStart_date.dataValue = ""
	dfEnd_date.dataValue = ""
	dfDue_date.dataValue = ""
	
	tiCRM_account_id.dataValue = __localModel.account_id
}


