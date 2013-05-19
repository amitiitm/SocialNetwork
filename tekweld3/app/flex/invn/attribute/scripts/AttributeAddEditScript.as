
import com.generic.events.AddEditEvent;

import invn.attribute.AttributeModelLocator;

import model.GenModelLocator;

import mx.controls.Alert;
 
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:AttributeModelLocator = (AttributeModelLocator)(GenModelLocator.getInstance().activeModelLocator);


override protected function retrieveRecordEventHandler(event:AddEditEvent):void 
{
	tiCode.enabled = false;
}

override protected function resetObjectEventHandler():void
{
	tiCode.enabled = true;
}
override protected function preSaveEventHandler(event:AddEditEvent):int
{
	return 0;
}
override protected function copyRecordCompleteEventHandler():void
{
	resetOptionsValues();
}

private function resetOptionsValues():void
{
	var rowsXml:XML		= dtlValue.dgDtl.rows.copy();
	for(var i:int=0;i<rowsXml.children().length();i++)
	{
		rowsXml.children()[i].catalog_attribute_id   = '';
	}
	dtlValue.dgDtl.rows  = rowsXml;
}
    
       


