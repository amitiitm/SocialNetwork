import com.generic.events.AddEditEvent;
import model.GenModelLocator;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

override protected function retrieveRecordEventHandler(event:AddEditEvent):void
{
	tiYear.enabled = false;
}

override protected function resetObjectEventHandler():void
{
	tiYear.enabled = true;
}

override protected function copyRecordCompleteEventHandler():void
{
	tiYear.dataValue	=	'';
}