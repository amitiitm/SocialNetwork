// ActionScript file
import flash.events.Event;

import mx.controls.Alert;
import mx.controls.TextInput;
import mx.managers.PopUpManager;

[Bindable]
public var tiSelectedTemplate:TextInput = new TextInput();

private function init():void
{
	this.x = (this.screen.width - this.width) / 3
	this.y =  (this.screen.height - this.height) / 3
}
private function templateClickHandler(event:Event):void
{
	if(event.currentTarget.name.toString()	!=	tiSelectedTemplate.text)
	{
		switch(event.currentTarget.name.toString())
		{
			case 't13':
					template13.source			=	"com/generic/assets/template13Selected.png";
					template1.source			=	"com/generic/assets/template1.png";
					tiSelectedTemplate.text		=	't13';
			break;
			case 't1':
					template1.source			=	"com/generic/assets/template1Selected.png";
					template13.source			=	"com/generic/assets/template13.png";
					tiSelectedTemplate.text		=	't1';
			break;
			
			default: Alert.show('new template click handler ');
		}
		
	}
}
public function setSelectedLayout(selectedLayout:String):void
{
	switch(selectedLayout)
	{
		case 't13':
				template13.source			=	"com/generic/assets/template13Selected.png";
				tiSelectedTemplate.text		=	't13';
		break;
		case 't1':
				template1.source			=	"com/generic/assets/template1Selected.png";
				tiSelectedTemplate.text		=	't1';
		break;
		
		default: Alert.show('selectedLayout doesnot exist');
	}
		
}
private function btnInstallClickHandler():void
{
	PopUpManager.removePopUp(this);
}
private function btnCancelClickHandler():void
{
	PopUpManager.removePopUp(this);
}
