import flash.events.MouseEvent;
import model.GenModelLocator;
import mx.controls.Alert;
import mx.managers.PopUpManager;

[Bindable]
public var heading:String;

private function init():void
{
	this.x = (this.screen.width - this.width) / 3;
	this.y =  (this.screen.height - this.height) / 3;
}

private function btnSaveClickHandler():void
{
	btnUpdate.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
	PopUpManager.removePopUp(this);	
}

private function btnCancelClickHandler():void
{
	PopUpManager.removePopUp(this);
}


