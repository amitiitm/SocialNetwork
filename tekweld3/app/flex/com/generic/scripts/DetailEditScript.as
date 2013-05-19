import business.events.DetailEditCloseEvent;
import business.events.InitializeDetailEditEvent;

import com.generic.events.DetailAddEditEvent;

import flash.display.Stage;
import flash.events.KeyboardEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

[Bindable]
private var __genModel:GenModelLocator;
[Bindable]
private var rowInfo:XML = null;
private var initializeDetailEditEvent:InitializeDetailEditEvent;

private function handlePreinitialize(event:FlexEvent):void
{
	this.addEventListener(DetailAddEditEvent.PARENT_NOTIFICATION_EVENT, handleParentNotification);
}
private function creationCompleteHandler():void
{
	/*  we have done this functionalaliy in DetaiEditCommand because checkbox were not getting selected in detail window
	   reason:- creationcomplete of checkbox were executing after setting the data.
	
	__genModel = GenModelLocator.getInstance();
	vbAddEdit.addChild(__genModel.activeModelLocator.detailEditObj.detailEditContainer);*/
	this.setFocus();
	initializeDetailEditEvent = new InitializeDetailEditEvent();
	initializeDetailEditEvent.dispatch(); 
}

private function closeHandler():void
{
	var detailEditCloseEvent:DetailEditCloseEvent	=	new DetailEditCloseEvent();
	detailEditCloseEvent.dispatch();
}
private function handleParentNotification(event:DetailAddEditEvent):void
{
	rowInfo	=	event.rowXml;
}
private function detailKeyDownHandler(event:KeyboardEvent):void
{
	//it is needed otherwise keydown at application level will also work.
	var char:String 		= 	String.fromCharCode(event.charCode).toUpperCase();
	
	
	if(event.ctrlKey &&  char != 'V')
	{
		bcp.shortcutKeyHandler(event)	;
		
		event.stopImmediatePropagation();
		event.stopPropagation();
	}
	//event.preventDefault();
	//event.stopImmediatePropagation();
	//event.stopPropagation();
}