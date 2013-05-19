import com.generic.events.AddEditEvent;

import model.GenModelLocator;

import mx.controls.Alert;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

private function setDescription():void
{
		tiDescription.text = dcbFrom_unit.selectedLabel+' TO '+dcbTo_unit.selectedLabel;
}
override protected function resetObjectEventHandler():void
{
		setDescription();
}
override protected function retrieveRecordEventHandler(event:AddEditEvent):void
{
	
}
