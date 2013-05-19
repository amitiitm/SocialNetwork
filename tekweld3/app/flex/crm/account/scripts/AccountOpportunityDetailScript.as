import model.GenModelLocator;
import crm.account.AccountModelLocator;

[Bindable]
private var __localModel:AccountModelLocator = (AccountModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance()

private function init():void
{
	dfClose_date.dataValue = ""
	
	tiCRM_account_id.dataValue = __localModel.account_id
}

override protected function resetObjectEventHandler():void
{
	dfClose_date.dataValue = ""
	
	tiCRM_account_id.dataValue = __localModel.account_id
}