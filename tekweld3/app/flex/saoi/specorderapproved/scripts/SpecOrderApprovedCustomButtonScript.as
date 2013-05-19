import business.events.PreSaveEvent;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.events.CloseEvent;

private var __genModel:GenModelLocator = GenModelLocator.getInstance();

public function btnSaveClickHandler():void
{
	Alert.show("Are you sure to Approve the Order?","Approved Order",Alert.OK | Alert.CANCEL,this,alertListener,null,Alert.OK)
}	

private function alertListener(event:CloseEvent):void
{
	switch (event.detail)
	{
		case Alert.OK:
			var preSaveEvent:PreSaveEvent = new PreSaveEvent();
			preSaveEvent.dispatch();
		break;
		case Alert.CANCEL:
			
		break;
	}
}
	