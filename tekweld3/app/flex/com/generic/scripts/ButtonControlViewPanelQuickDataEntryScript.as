import business.events.*;
import model.GenModelLocator;

[Bindable]
public var isRecordViewOnly:Boolean;
[Bindable]
public var isAddPermission:String	=	"Y";
private var quickPreSaveEvent:QuickPreSaveEvent;		
					
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

public function btnAddClickHandler():void
{
	var addEvent:AddEvent	=			new AddEvent();
	addEvent.dispatch();
}			
public function btnSaveClickHandler():void
{
	quickPreSaveEvent = new QuickPreSaveEvent();
	quickPreSaveEvent.dispatch();
}		
private function btnCancelClickHandler():void
{
	var addEvent:AddEvent	=			new AddEvent();
	addEvent.dispatch();
}


