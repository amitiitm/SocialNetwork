import business.events.InitializeQuickDetailUpdateEvent;
import business.events.QuickDetailUpdateCloseEvent;
import model.GenModelLocator;

[Bindable]
private var __genModel:GenModelLocator;
private var initializeQuickDetailUpdateEvent:InitializeQuickDetailUpdateEvent;

private function creationCompleteHandler():void
{
	initializeQuickDetailUpdateEvent = new InitializeQuickDetailUpdateEvent();
	initializeQuickDetailUpdateEvent.dispatch(); 
}

private function closeHandler():void
{
	var quickDetailUpdateCloseEvent:QuickDetailUpdateCloseEvent	=	new QuickDetailUpdateCloseEvent();
	quickDetailUpdateCloseEvent.dispatch();
}
