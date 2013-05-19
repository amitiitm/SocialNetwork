import business.events.InitializeDataEntryEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import prod.padfilmjob.PadFilmJobController;
import prod.padfilmjob.PadFilmJobModelLocator;
import prod.padfilmjob.PadFilmJobServices;
import prod.padfilmjob.components.PadFilmJobAddEdit;

import valueObjects.ModeVO;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:PadFilmJobModelLocator = new PadFilmJobModelLocator();

public function handlePadFilmJobAcitve(event:GenModuleEvent):void
{
	__genModel.controller 			= new PadFilmJobController();
	__genModel.services 			= new PadFilmJobServices();
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
	
	__localModel.addEditObj.addEditContainer = new PadFilmJobAddEdit();
    __localModel.listObj.listGrid = listControlComponent.dgList;
	
	
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	this.bcpDataEntry.btnAdd.visible 			= false;
	this.bcpList.btnAdd.visible 				= false;
	this.bcpDataEntry.btnPrint.visible 			= false;
	this.bcpList.btnPrint.visible 				= false;
	
	//this.bcpDataEntry.btnSave.visible 			= false;
	//this.vsButtonControlPanel.selectedIndex 	= 0;
	//this.vsViews.selectedIndex 					= 0;
	initializeEvent = new InitializeDataEntryEvent();
	initializeEvent.dispatch();
}
