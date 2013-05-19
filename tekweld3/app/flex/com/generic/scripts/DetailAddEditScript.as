import business.events.SaveImportedXMLEvent;
import business.events.SaveRowEvent;

import com.generic.events.DetailAddEditEvent;

import mx.controls.Alert;
import mx.events.FlexEvent;

private var saveRowEvent:SaveRowEvent;
private var saveImportedXMLEvent:SaveImportedXMLEvent;

private var _rowInfo:XML = null;
[Bindable]
public function set rowInfo(aXML:XML):void
{
	_rowInfo	=	aXML;
	dispatchEvent(new DetailAddEditEvent('parentNotificationEvent',aXML) );
}
public function get rowInfo():XML
{
	return _rowInfo;
}			
protected function handleDetailEditPreinitialize(event:FlexEvent):void 
{
	this.addEventListener(DetailAddEditEvent.RETRIEVE_ROW_END_EVENT, retrieveRowEvent);
	this.addEventListener(DetailAddEditEvent.RESET_OBJECT_EVENT, resetObjectEvent);
	this.addEventListener(DetailAddEditEvent.PRE_SAVE_ROW_EVENT, preSaveRowEvent);
	this.addEventListener(DetailAddEditEvent.DOWNLOAD_COMPLETE_EVENT, downloadCompleteEvent);
	this.addEventListener(DetailAddEditEvent.PRE_SAVE_IMPORTED_XML_EVENT, preSaveImportedXMLEvent);
	
}
/* jeetu 11 nov 2010 called from DetailEditVO setNull()*/
public function removeEventListnerFromComponent():void
{
	this.removeEventListener(DetailAddEditEvent.RETRIEVE_ROW_END_EVENT, retrieveRowEvent);
	this.removeEventListener(DetailAddEditEvent.RESET_OBJECT_EVENT, resetObjectEvent);
	this.removeEventListener(DetailAddEditEvent.PRE_SAVE_ROW_EVENT, preSaveRowEvent);
	this.removeEventListener(DetailAddEditEvent.DOWNLOAD_COMPLETE_EVENT, downloadCompleteEvent)
	
}
private function retrieveRowEvent(event:DetailAddEditEvent):void
{
	retrieveRowEventHandler(event);
}

private function resetObjectEvent(event:DetailAddEditEvent):void
{
	resetObjectEventHandler();
}

private function preSaveRowEvent(event:DetailAddEditEvent):void
{
	if(preSaveRowEventHandler(event)==	0)
	{
		saveRowEvent	=	new SaveRowEvent();
		saveRowEvent.dispatch();
		//call save commanmd
	}
	
}
private function downloadCompleteEvent(event:DetailAddEditEvent):void
{
	downloadCompleteEventHandler(event);
}
private function preSaveImportedXMLEvent(event:DetailAddEditEvent):void
{
	if(preSaveImportedXMLEventHandler(event)==	0)
	{
		saveImportedXMLEvent	=	new SaveImportedXMLEvent();
		saveImportedXMLEvent.dispatch();
		//call save commanmd
	}	
}
protected function resetObjectEventHandler():void
{
	// Override in Decendents.	
}

protected function retrieveRowEventHandler(event:DetailAddEditEvent):void
{
	// Override in Decendents.
}

protected function preSaveRowEventHandler(event:DetailAddEditEvent):int
{
	return 0;
	// Override in Decendents if required.
}
protected function downloadCompleteEventHandler(event:DetailAddEditEvent):void
{
	// Override in Decendents if required.
}
protected function preSaveImportedXMLEventHandler(event:DetailAddEditEvent):int
{
	return 0;
	// Override in Decendents if required.
}