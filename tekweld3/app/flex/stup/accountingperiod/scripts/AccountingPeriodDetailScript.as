import com.generic.events.DetailAddEditEvent;
import model.GenModelLocator;
import stup.accountingperiod.AccountingPeriodModelLocator;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
private var __localModel:AccountingPeriodModelLocator = (AccountingPeriodModelLocator)(GenModelLocator.getInstance().activeModelLocator);

override protected function retrieveRowEventHandler(event:DetailAddEditEvent):void
{
	tiCode.enabled = false;
}

override protected function resetObjectEventHandler():void
{
	tiCode.enabled = true;
}
