import business.events.InitializeDataEntryEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import saoi.assignedartwork.AssignedArtworkController;
import saoi.assignedartwork.AssignedArtworkModelLocator;
import saoi.assignedartwork.AssignedArtworkServices;
import saoi.assignedartwork.components.AssignedArtworkAddEdit;

import valueObjects.ModeVO;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:AssignedArtworkModelLocator = new AssignedArtworkModelLocator();

public function handleAssignedArtworkAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new AssignedArtworkController();
	__genModel.services = new AssignedArtworkServices();
	__genModel.activeModelLocator = __localModel;
	
	handleDrillDown();
}

public function handleCreationComplete(event:FlexEvent):void
{	
	__localModel.documentObj.selectedMode		=	ModeVO.LIST_MODE;
    __localModel.documentObj.documentID			= __genModel.applicationObject.selectedMenuItem.@document_id
    __localModel.documentObj.create_permission 	= __genModel.applicationObject.selectedMenuItem.@create_permission
    __localModel.documentObj.modify_permission	= __genModel.applicationObject.selectedMenuItem.@modify_permission
    __localModel.documentObj.view_permission 	= __genModel.applicationObject.selectedMenuItem.@view_permission
    __localModel.documentObj.upload_permission 	= 'Y' // Later we set thru column value
	
	__localModel.addEditObj.addEditContainer = new AssignedArtworkAddEdit()
    __localModel.listObj.listGrid = listControlComponent.dgList;
	
	
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	this.bcpDataEntry.btnAdd.visible 			= false;
	this.bcpList.btnAdd.visible 				= false;
	
	initializeEvent = new InitializeDataEntryEvent();
	initializeEvent.dispatch();
}
