import business.events.InitializeQuickDataEntryEvent;
import business.events.QuickAddRecordCloseEvent;
import model.GenModelLocator;

[Bindable]
private var __genModel:GenModelLocator;
private var initializeQuickDataEntryEvent:InitializeQuickDataEntryEvent;

private function creationCompleteHandler():void
{
	initializeQuickDataEntryEvent = new InitializeQuickDataEntryEvent();
	initializeQuickDataEntryEvent.dispatch(); 
}

private function closeHandler():void
{
	var quickAddRecordCloseEvent:QuickAddRecordCloseEvent	=	new QuickAddRecordCloseEvent();
	quickAddRecordCloseEvent.dispatch();
}
