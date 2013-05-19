import business.events.InitializeEditableListEvent;

import com.generic.events.GenModuleEvent;

import melt.sendofferwithvideo.SendOfferWithVideoController;
import melt.sendofferwithvideo.SendOfferWithVideoModelLocator;
import melt.sendofferwithvideo.SendOfferWithVideoServices;
import melt.sendofferwithvideo.components.SendOfferCustomButton;
import melt.sendofferwithvideo.components.SendOfferWithVideoAddEdit;

import model.GenModelLocator;

import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:SendOfferWithVideoModelLocator = new SendOfferWithVideoModelLocator();

public function handleSendOfferWithVideoAcitve(event:GenModuleEvent):void
{
	__genModel.controller 			= 	new SendOfferWithVideoController();
	__genModel.services 			= 	new SendOfferWithVideoServices();
	__genModel.activeModelLocator 	= __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.documentID 		= __genModel.applicationObject.selectedMenuItem.@document_id;
	__localModel.documentObj.create_permission 	= __genModel.applicationObject.selectedMenuItem.@create_permission;
	__localModel.documentObj.modify_permission 	= __genModel.applicationObject.selectedMenuItem.@modify_permission;
	__localModel.documentObj.view_permission 	= __genModel.applicationObject.selectedMenuItem.@view_permission;
	__localModel.documentObj.upload_permission 	= 'Y';

	__localModel.addEditObj.addEditContainer = new SendOfferWithVideoAddEdit()
    __localModel.listObj.listGrid = listControlComponent.dgList;
    
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	customBar = new SendOfferCustomButton();
	
	initializeEvent = new InitializeEditableListEvent();
	initializeEvent.dispatch();
}
