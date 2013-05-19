import business.events.GetInformationEvent;
import business.events.RecordStatusEvent;

import com.generic.events.AddEditEvent;
import com.generic.events.GenUploadButtonEvent;

import model.GenModelLocator;

import mx.controls.Alert;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var getInformationEvent:GetInformationEvent;

private function handleImportEvent(event:GenUploadButtonEvent):void
{
	tiXlsFile.text = event.fileName;

	var recordStatusEvent:RecordStatusEvent = new RecordStatusEvent("MODIFY");
	recordStatusEvent.dispatch();
}

private function handleDownloadCompleteEvent(event:GenUploadButtonEvent):void 
{
	if(event.downloadedObj != null &&  XML(event.downloadedObj).children().length() > 0)
	{
		dtlLine.rows = XML(event.downloadedObj);
	}	
}

override protected function retrieveRecordEventHandler(event:AddEditEvent):void
{
	var recordXml:XML	= event.recordXml;
	
	dtlLine.rows = recordXml;
	
	//Alert.show("Vivek : " + recordXml.toString())
	Alert.show("Price updated successfully...!");
}
	
private function handleSampleXLS():void
{
	var file_name:String = 'sample_item_upload.xls';
	var folderName:String = '/sampleformats/';
	var url:String = folderName + file_name;
	var request:URLRequest = new URLRequest(url);

    navigateToURL(request);
}
