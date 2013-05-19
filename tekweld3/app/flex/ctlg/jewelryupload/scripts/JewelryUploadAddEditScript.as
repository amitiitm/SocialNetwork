import business.events.RecordStatusEvent;

import com.generic.events.GenUploadButtonEvent;

import mx.core.Application;
import mx.managers.CursorManager;

private var recordStatusEvent:RecordStatusEvent;

private function handleUploadEvent(event:GenUploadButtonEvent):void
{
	CursorManager.setBusyCursor();
	Application.application.enabled = false;

	tiFileName.text = event.fileName;
}

private function handleDownloadCompleteEvent(event:GenUploadButtonEvent):void
{
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;

	

	if(event.downloadedObj != null &&  XML(event.downloadedObj).children().length() > 0)
	{
		dtlLine.rows	=	XML(event.downloadedObj);
		recordStatusEvent = new	RecordStatusEvent("MODIFY")
		recordStatusEvent.dispatch()
	}
	
}

private function handleSampleXLS():void
{
	var file_name:String = 'sample_jewelry_upload_format.xls';
	var folderName:String = '/sampleformats/';
	var url:String = folderName + file_name;
	var request:URLRequest = new URLRequest(url);

    navigateToURL(request);
}