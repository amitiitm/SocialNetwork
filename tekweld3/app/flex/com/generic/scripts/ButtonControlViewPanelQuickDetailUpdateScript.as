import business.events.*;
import model.GenModelLocator;

private var quickDetailUpdatePreSaveEvent:QuickDetailUpdatePreSaveEvent;		
					
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

public function btnSaveClickHandler():void
{
	quickDetailUpdatePreSaveEvent = new QuickDetailUpdatePreSaveEvent();
	quickDetailUpdatePreSaveEvent.dispatch();
}		

private function btnCancelClickHandler():void
{
	var addEvent:AddEvent =	new AddEvent();
	addEvent.dispatch();
}
