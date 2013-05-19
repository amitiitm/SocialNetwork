import model.GenModelLocator;
import crm.account.AccountModelLocator;
import com.generic.events.DetailAddEditEvent;
import mx.controls.Alert;

[Bindable]
private var __localModel:AccountModelLocator = (AccountModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance()

private function init():void
{	
	tiCRM_account_id_activity.dataValue = __localModel.account_id
	
	dcCRM_contact_id_activity.filterKeyValue = tiCRM_account_id_activity.dataValue
}

override protected function resetObjectEventHandler():void
{	
	tiCRM_account_id_activity.dataValue = __localModel.account_id
}

protected override function retrieveRowEventHandler(event:DetailAddEditEvent):void
{
		var rowXml:XML	= event.rowXml;
		
	dcCRM_contact_id_activity.filterKeyValue = tiCRM_account_id_activity.dataValue;
	dcCRM_contact_id_activity.dataValue = rowXml["crm_contact_id"];

}