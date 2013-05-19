// ActionScript file
import mx.controls.Alert;
import mx.managers.PopUpManager;

[Bindable]
private var itemsXml:XML

private function creationCompleteHandler():void
{
	this.x 		=  (this.screen.width - this.width) / 3
	this.y 		=  (this.screen.height - this.height) / 3	
}
[Bindable]
public function set Items(itemsXml:XML):void
{
	itemsXml	=	itemsXml
	tlItemList.dataProvider	=	itemsXml.children();
	
}
[Bindable]
public function get Items():XML
{
	return itemsXml;
}

private function closeHandler():void
{
	PopUpManager.removePopUp(this);
}