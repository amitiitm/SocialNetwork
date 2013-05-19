import business.events.RecordStatusEvent;
import com.generic.events.AddEditEvent;
import com.generic.events.GenUploadButtonEvent;
import model.GenModelLocator;

[Bindable]
public var __genModel:GenModelLocator = GenModelLocator.getInstance();

override protected function retrieveRecordEventHandler(event:AddEditEvent):void
{
	tiCode.enabled	=	false;
	tiCompany_name.text = __genModel.user.organization_name.toString();
	
}

override protected function resetObjectEventHandler():void
{
	tiCode.enabled	=	true;
	tiCompany_name.text = __genModel.user.organization_name.toString();
}

private function handleThumnailEvent(event:GenUploadButtonEvent):void
{
	tiLogo.text = event.fileName;
	var recordStatusEvent:RecordStatusEvent = new RecordStatusEvent("MODIFY")
	recordStatusEvent.dispatch();
}

private function handleBusinessCardEvent(event:GenUploadButtonEvent):void
{
	tiBusiness_card.text = event.fileName;
	var recordStatusEvent:RecordStatusEvent = new RecordStatusEvent("MODIFY")
	recordStatusEvent.dispatch();
}

override protected function copyRecordCompleteEventHandler():void
{
	tiCode.dataValue	=	'';
}
