import business.events.*;

import com.generic.events.GenModuleEvent;
import com.generic.genclass.ShortCut;

import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import model.GenModelLocator;

private var preSaveEvent:PreSaveEvent;
private var saveRecordEvent:SaveRecordEvent;	
private var refreshEvent:RefreshEvent;		

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();


public function btnSaveClickHandler():void
{
	preSaveEvent = new PreSaveEvent();
	preSaveEvent.dispatch();
}		
public function btnRefreshClickHandler():void
{
	refreshEvent = new RefreshEvent();
	refreshEvent.dispatch();
} 		
public function shortcutKeyHandler(event:GenModuleEvent):void
{
	var char:String 		= String.fromCharCode(KeyboardEvent(event.keyBoardEvent).charCode).toUpperCase();
	var keyCode:int 		= 	KeyboardEvent(event.keyBoardEvent).keyCode;
	var isShiftKey:Boolean	=	KeyboardEvent(event.keyBoardEvent).shiftKey;
	
	if(ShortCut.isSave(event.keyBoardEvent,btnSave))
	{
		btnSave.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}
	else if(ShortCut.isReferesh(event.keyBoardEvent,btnRefresh))
	{
		btnRefresh.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}
}
	
	
 
	

	
	
	
	
	
	

