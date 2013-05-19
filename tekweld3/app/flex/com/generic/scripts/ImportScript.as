import business.events.SaveImportRecordEvent;
import com.generic.events.ImportEvent;
import mx.events.FlexEvent;

private var saveImportRecordEvent:SaveImportRecordEvent;

	
			
protected function handleImportPreinitialize(event:FlexEvent):void 
{
	this.addEventListener(ImportEvent.RETRIEVE_RECORD_END_EVENT, retrieveRecordEvent)
	this.addEventListener(ImportEvent.RESET_OBJECT_EVENT, resetObjectEvent)
	this.addEventListener(ImportEvent.PRE_SAVE_EVENT, preSaveEvent)
	this.addEventListener(ImportEvent.DOWNLOAD_COMPLETE_EVENT, downloadCompleteEvent);
}

/* jeetu 11 nov 2010 called from ImportVO setNull() */
public function removeEventListnerFromComponent():void 
{
	this.removeEventListener(ImportEvent.RETRIEVE_RECORD_END_EVENT, retrieveRecordEvent)
	this.removeEventListener(ImportEvent.RESET_OBJECT_EVENT, resetObjectEvent)
	this.removeEventListener(ImportEvent.PRE_SAVE_EVENT, preSaveEvent)
	this.removeEventListener(ImportEvent.DOWNLOAD_COMPLETE_EVENT, downloadCompleteEvent)
}
private function retrieveRecordEvent(event:ImportEvent):void
{
	retrieveRecordEventHandler(event);
}

private function resetObjectEvent(event:ImportEvent):void
{
	resetObjectEventHandler();
}

private function preSaveEvent(event:ImportEvent):void
{
	if(preSaveEventHandler(event)==	0)
	{
		saveImportRecordEvent	=	new SaveImportRecordEvent();
		saveImportRecordEvent.dispatch();
		//call save commanmd
	}
	
}
private function downloadCompleteEvent(event:ImportEvent):void
{
	downloadCompleteEventHandler(event);
}
protected function resetObjectEventHandler():void
{
	// Override in Decendents.	
}

protected function retrieveRecordEventHandler(event:ImportEvent):void
{
	// Override in Decendents.
}

protected function preSaveEventHandler(event:ImportEvent):int
{
	return 0;
	// Override in Decendents if required.
}
protected function downloadCompleteEventHandler(event:ImportEvent):void
{
	// Override in Decendents if required.
}