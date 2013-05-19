import business.events.InsertRowEvent;
import business.events.PreSaveImportedXMLEvent;
import business.events.RecordStatusEvent;

import com.generic.events.DetailAddEditEvent;
import com.generic.events.GenUploadButtonEvent;

import model.GenModelLocator;

import mx.core.Application;
import mx.core.Container;
import mx.managers.CursorManager;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
public var importedXml:XML;
[Bindable]
public var uploadServiceID:String = "";
[Bindable]
public var downloadedRootNode:String = "";

public function btnSaveClickHandler():void
{
	var preSaveImportedXMLEvent:PreSaveImportedXMLEvent = new PreSaveImportedXMLEvent();
	preSaveImportedXMLEvent.dispatch();
}		

public function btnCancelClickHandler():void
{
	tiFileName.text	=	'';
	var insertRowEvent:InsertRowEvent = new InsertRowEvent();
	insertRowEvent.dispatch()
}		

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
	
	
	importedXml	=	new XML(<rows/>)
	if(event.downloadedObj != null &&  XML(event.downloadedObj).children().length() > 0)
	{
		importedXml	=	XML(event.downloadedObj);
		var recordStatusEvent:RecordStatusEvent = new	RecordStatusEvent("MODIFY")
		recordStatusEvent.dispatch()
	}
	var detailAddEditContainer:Container = __genModel.activeModelLocator.detailEditObj.detailEditContainer
	detailAddEditContainer.dispatchEvent(new DetailAddEditEvent(DetailAddEditEvent.DOWNLOAD_COMPLETE_EVENT,importedXml));
	
}