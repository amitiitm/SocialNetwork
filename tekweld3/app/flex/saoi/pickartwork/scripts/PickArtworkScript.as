import business.events.InitializeEditableListEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import saoi.pickartwork.PickArtworkController;
import saoi.pickartwork.PickArtworkModelLocator;
import saoi.pickartwork.PickArtworkServices;
import saoi.pickartwork.components.PickArtworkAddEdit;

import valueObjects.ModeVO;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:PickArtworkModelLocator = new PickArtworkModelLocator();

public function handlePickArtworkAcitve(event:GenModuleEvent):void
{
	__genModel.controller 			= 	new PickArtworkController();
	__genModel.services 			= 	new PickArtworkServices();
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
	__localModel.listObj.isfixedurl				= 'Y';
	__localModel.listObj.drilldown_component_code	= 'saoi/assignedartwork/components/AssignedArtwork.swf';

	__localModel.addEditObj.addEditContainer = new PickArtworkAddEdit()
    __localModel.listObj.listGrid = listControlComponent.dgList;
    
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	this.bcp.btnSave.visible	= false;
	this.bcp.btnSave.includeInLayout = false;
	this.bcp.btnPrint.visible	= false;
	this.bcp.btnPrint.includeInLayout = false;
	
	
	initializeEvent = new InitializeEditableListEvent();
	initializeEvent.dispatch();
}
