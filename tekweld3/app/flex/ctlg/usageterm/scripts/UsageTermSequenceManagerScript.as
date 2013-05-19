import mx.managers.PopUpManager;

private function init():void
{
	this.x = (this.screen.width - this.width) / 3;
	this.y =  (this.screen.height - this.height) / 3;
}

private function btnCancelClickHandler():void
{
	PopUpManager.removePopUp(this);
}