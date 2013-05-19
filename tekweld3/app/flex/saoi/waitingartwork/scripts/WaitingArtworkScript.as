import business.events.InitializeEditableListEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import saoi.waitingartwork.InboxDrilldownWaitingArtwork;
import saoi.waitingartwork.WaitingArtworkController;
import saoi.waitingartwork.WaitingArtworkModelLocator;
import saoi.waitingartwork.WaitingArtworkServices;
import saoi.waitingartwork.components.WaitingArtworkAddEdit;

import valueObjects.ModeVO;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:WaitingArtworkModelLocator = new WaitingArtworkModelLocator();

public function handleWaitingArtworkAcitve(event:GenModuleEvent):void
{
	__genModel.controller 			= 	new WaitingArtworkController();
	__genModel.services 			= 	new WaitingArtworkServices();
	__genModel.activeModelLocator 	= __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.selectedMode		=	ModeVO.LIST_MODE;
	__localModel.documentObj.documentID 		= __genModel.applicationObject.selectedMenuItem.@document_id;
	__localModel.documentObj.create_permission 	= __genModel.applicationObject.selectedMenuItem.@create_permission;
	__localModel.documentObj.modify_permission 	= __genModel.applicationObject.selectedMenuItem.@modify_permission;
	__localModel.documentObj.view_permission 	= __genModel.applicationObject.selectedMenuItem.@view_permission;
	__localModel.documentObj.upload_permission 	= 'Y';
	__localModel.listObj.isdrilldownrow			= 'Y';
	__localModel.listObj.isObjectFromDrillDown	= 'Y';
	
	__localModel.listObj.idrilldown				= new InboxDrilldownWaitingArtwork();
	__localModel.addEditObj.addEditContainer 	= new WaitingArtworkAddEdit()
	__localModel.listObj.listGrid = listControlComponent.dgList;
	
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	this.bcp.btnSave.visible	= false;
	this.bcp.btnSave.includeInLayout = false;
	this.bcp.btnPrint.visible	= false;
	this.bcp.btnPrint.includeInLayout = false;
	initializeEvent = new InitializeEditableListEvent();
	initializeEvent.dispatch();
}
