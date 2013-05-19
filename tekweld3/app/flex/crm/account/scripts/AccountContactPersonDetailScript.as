import com.generic.events.DetailAddEditEvent;

import crm.account.AccountModelLocator;

import model.GenModelLocator;
import mx.controls.Alert

[Bindable]
private var __localModel:AccountModelLocator = (AccountModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance()

private function init():void
{
	dfDate_of_birth.dataValue = ""
	dfDate_of_marraige.dataValue = ""
	
	tiCRM_account_id.dataValue = __localModel.account_id
}

override protected function resetObjectEventHandler():void
{
	dfDate_of_birth.dataValue = ""
	dfDate_of_marraige.dataValue = ""
	
	//tiCode.enabled = true;
	tiCRM_account_id.dataValue = __localModel.account_id
}


override protected function retrieveRowEventHandler(event:DetailAddEditEvent):void
{
	/*var _resultXml:XML = event.rowXml

	if(_resultXml["id"].toString() > 0)
	{
		tiCode.enabled = false;
	}*/
}