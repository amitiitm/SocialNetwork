import com.generic.events.AddEditEvent;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.events.IndexChangedEvent;

import stup.reportwriter.ReportWriterModelLocator;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
 
[Bindable]
private var __reportModel:ReportWriterModelLocator = (ReportWriterModelLocator)(GenModelLocator.getInstance().activeModelLocator);

private function handleTabChange(event:IndexChangedEvent):void
{
	if(event.newIndex == 1)
	{
		__reportModel.columnList = dtlColumns.dataValue;
	}	
}

override protected function retrieveRecordEventHandler(event:AddEditEvent):void  //after save and prev,next,.....
{
	__reportModel.columnList = dtlColumns.dataValue;
}

private function changeHandler():void
{
	
	if(cbDrillDownColumn.selected && cbFixedUrl.selected)
	{
		lblDoc_id.visible = true;
		dcDoc_id.visible = true;
	}
	else
	{
		dcDoc_id.visible  = false;
		lblDoc_id.visible = false;
	}
}
override protected function copyRecordCompleteEventHandler():void
{
	tiCode.dataValue	=	'';
	
}