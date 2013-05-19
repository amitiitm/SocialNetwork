import business.events.InitializeDataEntryEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import saoi.artworkapprovedcustomermanual.ArtworkApprovedCustomerManualController;
import saoi.artworkapprovedcustomermanual.ArtworkApprovedCustomerManualModelLocator;
import saoi.artworkapprovedcustomermanual.ArtworkApprovedCustomerManualServices;
import saoi.artworkapprovedcustomermanual.components.ArtworkApprovedCustomerManualAddEdit;

import valueObjects.ModeVO;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:ArtworkApprovedCustomerManualModelLocator = new ArtworkApprovedCustomerManualModelLocator();

public function handleArtworkApprovedCustomerManualAcitve(event:GenModuleEvent):void
{
	__genModel.controller 			= new ArtworkApprovedCustomerManualController();
	__genModel.services 			= new ArtworkApprovedCustomerManualServices();
	__genModel.activeModelLocator 	= __localModel;
	
	handleDrillDown();
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.selectedMode		=	ModeVO.LIST_MODE;
    __localModel.documentObj.documentID = __genModel.applicationObject.selectedMenuItem.@document_id
    __localModel.documentObj.create_permission = __genModel.applicationObject.selectedMenuItem.@create_permission
    __localModel.documentObj.modify_permission = __genModel.applicationObject.selectedMenuItem.@modify_permission
    __localModel.documentObj.view_permission = __genModel.applicationObject.selectedMenuItem.@view_permission
    __localModel.documentObj.upload_permission = 'Y' // Later we set thru column value
	
	__localModel.addEditObj.addEditContainer = new ArtworkApprovedCustomerManualAddEdit();
    __localModel.listObj.listGrid = listControlComponent.dgList;
	
	
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	this.bcpDataEntry.btnAdd.visible 			= false;
	this.bcpList.btnAdd.visible 				= false;
	//this.vsButtonControlPanel.selectedIndex 	= 0;
	//this.vsViews.selectedIndex 					= 0;
	initializeEvent = new InitializeDataEntryEvent();
	initializeEvent.dispatch();
}
