import com.generic.events.AddEditEvent;
import model.GenModelLocator;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

private function setMemoTerm():void
{
	dcMemo_term_code.dataValue = dcInvoice_term_code.dataValue;
	dcMemo_term_code.labelValue = dcInvoice_term_code.labelValue;
}
override protected function retrieveRecordEventHandler(event:AddEditEvent):void
{
	//tiCode.enabled = false;
}

override protected function resetObjectEventHandler():void
{
	//tiCode.enabled = true;
}
override protected function copyRecordCompleteEventHandler():void
{
	tiCode.dataValue	=	''; 
}