import business.events.QuickDetailUpdateSaveRecordEvent;
import business.events.QuickSaveRecordEvent;
import business.events.SaveRecordEvent;

import com.generic.events.AddEditEvent;
import com.generic.events.FetchRecordEvent;
import com.generic.events.QuickAddEvent;
import com.generic.events.QuickDetailUpdateEvent;

import mx.events.FlexEvent;

private var saveRecordEvent:SaveRecordEvent;

[Bindable]
protected var record:XML = new XML();		
			
protected function handleAddEditPreinitialize(event:FlexEvent):void 
{
	this.addEventListener(AddEditEvent.RETRIEVE_RECORD_END_EVENT, retrieveRecordEvent)
	this.addEventListener(AddEditEvent.RESET_OBJECT_EVENT, resetObjectEvent)
	this.addEventListener(AddEditEvent.PRE_SAVE_EVENT, preSaveEvent)
	this.addEventListener(FetchRecordEvent.SELECTCOMPLETE_EVENT, fetchRecordSelectCompleteEvent)
	this.addEventListener(FetchRecordEvent.FETCHWINDOWCANCEL_EVENT, fetchRecordWindowCloseEvent)
	this.addEventListener(QuickAddEvent.QUICK_PRE_SAVE_EVENT, quickPreSaveEvent)
	this.addEventListener(AddEditEvent.COPY_RECORD_COMPLETE_EVENT, copyRecordCompleteEvent)
	//VD 03 Oct 2011
	this.addEventListener(QuickDetailUpdateEvent.QUICK_DETAIL_UPDATE_PRE_SAVE_EVENT, quickDetailUpdatePreSaveEvent)
}

/* jeetu 11 nov 2010 called from AddEditVO setNull() */
public function removeEventListnerFromComponent():void 
{
	this.removeEventListener(AddEditEvent.RETRIEVE_RECORD_END_EVENT, retrieveRecordEvent)
	this.removeEventListener(AddEditEvent.RESET_OBJECT_EVENT, resetObjectEvent)
	this.removeEventListener(AddEditEvent.PRE_SAVE_EVENT, preSaveEvent)
	this.removeEventListener(FetchRecordEvent.SELECTCOMPLETE_EVENT, fetchRecordSelectCompleteEvent)
	this.removeEventListener(FetchRecordEvent.FETCHWINDOWCANCEL_EVENT, fetchRecordWindowCloseEvent)
	this.removeEventListener(QuickAddEvent.QUICK_PRE_SAVE_EVENT, quickPreSaveEvent)
	this.removeEventListener(AddEditEvent.COPY_RECORD_COMPLETE_EVENT, copyRecordCompleteEvent)
	//VD 03 Oct 2011
	this.removeEventListener(QuickDetailUpdateEvent.QUICK_DETAIL_UPDATE_PRE_SAVE_EVENT, quickDetailUpdatePreSaveEvent)
}

private function retrieveRecordEvent(event:AddEditEvent):void
{
	focusManager.activate();
	retrieveRecordEventHandler(event);
}

private function resetObjectEvent(event:AddEditEvent):void
{
	focusManager.activate();
	resetObjectEventHandler();
}

private function preSaveEvent(event:AddEditEvent):void
{
	if(preSaveEventHandler(event)==	0)
	{
		saveRecordEvent	=	new SaveRecordEvent();
		saveRecordEvent.dispatch();
		//call save commanmd
	}
	
}

private function quickPreSaveEvent(event:QuickAddEvent):void
{
	if(preSaveEventHandler(event)==	0)
	{
		var quickSaveRecordEvent:QuickSaveRecordEvent;
		quickSaveRecordEvent	=	new QuickSaveRecordEvent();
		quickSaveRecordEvent.dispatch();
		//call save commanmd
	}	
}

//VD 03 Oct 2011
private function quickDetailUpdatePreSaveEvent(event:QuickDetailUpdateEvent):void
{
	if(preSaveEventHandler(event)==	0)
	{
		var quickDetailUpdateSaveRecordEvent:QuickDetailUpdateSaveRecordEvent;
		quickDetailUpdateSaveRecordEvent	=	new QuickDetailUpdateSaveRecordEvent();
		quickDetailUpdateSaveRecordEvent.dispatch();
	}	
}

private function fetchRecordSelectCompleteEvent(event:FetchRecordEvent):void
{
	fetchRecordSelectCompleteEventHandler(event);
}

private function fetchRecordWindowCloseEvent(event:FetchRecordEvent):void
{
	fetchRecordWindowCloseEventHandler(event);
}

private function copyRecordCompleteEvent(event:AddEditEvent):void
{
	copyRecordCompleteEventHandler();
}	

protected function resetObjectEventHandler():void
{
	// Override in Decendents.	
}

protected function retrieveRecordEventHandler(event:AddEditEvent):void
{
	// Override in Decendents.
}

protected function preSaveEventHandler(event:AddEditEvent):int
{
	return 0;
	// Override in Decendents if required.
}

protected function fetchRecordSelectCompleteEventHandler(event:FetchRecordEvent):void
{
	// Override in Decendents if required.
}

protected function fetchRecordWindowCloseEventHandler(event:FetchRecordEvent):void
{
	// Override in Decendents if required.
}

protected function copyRecordCompleteEventHandler():void
{
	// Override in Decendents if required.
}
