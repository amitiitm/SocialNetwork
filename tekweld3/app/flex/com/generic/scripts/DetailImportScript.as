import business.events.DetailImportCloseEvent;
import business.events.InitializeDetailImportEvent;

import model.GenModelLocator;

[Bindable]
private var __genModel:GenModelLocator;
private var initializeDetailImportEvent:InitializeDetailImportEvent;
[Bindable]
public var uploadServiceID:String = "";
[Bindable]
public var downloadedRootNode:String = "";
private function creationCompleteHandler():void
{
	/*  we have done this functionalaliy in DetaiEditCommand because checkbox were not getting selected in detail window
	   reason:- creationcomplete of checkbox were executing after setting the data.
	
	__genModel = GenModelLocator.getInstance();
	vbAddEdit.addChild(__genModel.activeModelLocator.detailEditObj.detailEditContainer);*/
	
	this.setFocus();
	
	initializeDetailImportEvent = new InitializeDetailImportEvent();
	initializeDetailImportEvent.dispatch(); 
}

private function closeHandler():void
{
	var detailImportCloseEvent:DetailImportCloseEvent	=	new DetailImportCloseEvent();
	detailImportCloseEvent.dispatch();
}
// ActionScript file
