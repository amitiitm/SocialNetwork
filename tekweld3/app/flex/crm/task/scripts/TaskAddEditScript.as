import model.GenModelLocator;
import com.generic.events.AddEditEvent;
import mx.controls.Alert;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance()

private function init():void
{
	dfStart_date.dataValue = ""
	dfEnd_date.dataValue = ""
	dfDue_date.dataValue = ""
}

private function handleAccountChange():void
{
		dcCRM_contact_id.filterKeyValue = dcCRM_account_id.dataValue
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


override protected function retrieveRecordEventHandler(event:AddEditEvent):void
{
	var recordXml:XML	= event.recordXml;
			
	dcCRM_contact_id.filterKeyValue = dcCRM_account_id.dataValue;
	dcCRM_contact_id.dataValue = recordXml.children()["crm_contact_id"];
	Alert.show(recordXml.children()["crm_contact_id"].toString())
}

override protected function resetObjectEventHandler():void
{
	dfStart_date.dataValue = ""
	dfEnd_date.dataValue = ""
	dfDue_date.dataValue = ""
	
	dcCRM_contact_id.filterKeyValue = "";
}