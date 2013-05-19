import crm.otheraddress.components.*;
import com.generic.events.AddEditEvent;
import model.GenModelLocator;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance() 

private function init():void
{
	dfDate_of_birth.dataValue = ""
	dfSPDate_of_birth.dataValue = ""
	dfDate_of_marraige.dataValue = ""
}

override protected function resetObjectEventHandler():void
{
	dfDate_of_birth.dataValue = ""
	dfSPDate_of_birth.dataValue = ""
	dfDate_of_marraige.dataValue = ""
	
//	tiCode.enabled = true;
}

override protected function retrieveRecordEventHandler(event:AddEditEvent):void 
{
	//tiCode.enabled = false;
}