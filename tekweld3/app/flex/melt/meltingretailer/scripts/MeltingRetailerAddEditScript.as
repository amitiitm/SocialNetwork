import com.generic.events.AddEditEvent;
import com.generic.events.GenUploadButtonEvent;

import model.GenModelLocator;


[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

private function handleThumnailEvent(event:GenUploadButtonEvent):void
{
	tiLogoFileName.text = event.fileName;
}

private function handleThumnailEvent2(event:GenUploadButtonEvent):void
{
	tiLogoFileName2.text = event.fileName;
}

override protected function retrieveRecordEventHandler(event:AddEditEvent):void
{
	tiCode.enabled = false;
}

override protected function resetObjectEventHandler():void
{
	tiCode.enabled = true;
}
