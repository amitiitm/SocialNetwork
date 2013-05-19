import business.events.RecordStatusEvent;

import com.generic.events.GenUploadButtonEvent;

import flash.events.MouseEvent;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.managers.PopUpManager;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var recordStatusEvent:RecordStatusEvent;
[Bindable]
public var heading:String;

private function init():void
{
	this.x = (this.screen.width - this.width) / 3;
	this.y =  (this.screen.height - this.height) / 3;
}
private function handleUploadEvent(event:GenUploadButtonEvent):void
{
	tiImageName.text = event.fileName;
}
public function cmbTemplateChangeHandler():void
{
	switch(cmbTemplateType.selectedItem.code.toString())
	{
		case 'textimg':
			vbText.percentWidth		=	100;
			vbText.percentHeight	=	100;
			vbText.visible	=	true;
					
		break;
		case 'img':
			vbText.width	=	0;
			vbText.height	=	0;
			vbText.visible	=	false;
		break;	
	}
}
private function btnSaveClickHandler():void
{
	if(tiTabName.text != '')
	{
		btnUpdate.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		PopUpManager.removePopUp(this);
	}
	else
	{
		Alert.show('Tab Name can not be blank...');
	}
}
private function btnCancelClickHandler():void
{
	PopUpManager.removePopUp(this);
}
// ActionScript file
