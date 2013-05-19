

import business.events.InitializeEditableListEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import saoi.specorderapproved.SpecOrderApprovedController;
import saoi.specorderapproved.SpecOrderApprovedDrilldown;
import saoi.specorderapproved.SpecOrderApprovedModelLocator;
import saoi.specorderapproved.SpecOrderApprovedServices;
import saoi.specorderapproved.components.SpecOrderApprovedAddEdit;
import saoi.specorderapproved.components.SpecOrderApprovedCustomButton;

import valueObjects.ModeVO;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:SpecOrderApprovedModelLocator = new SpecOrderApprovedModelLocator();

public function handleSpecOrderApprovedAcitve(event:GenModuleEvent):void
{
	__genModel.controller 			= 	new SpecOrderApprovedController();
	__genModel.services 			= 	new SpecOrderApprovedServices();
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
	//__localModel.listObj.isObjectFromDrillDown	= 'Y';
	
	__localModel.listObj.idrilldown				= new SpecOrderApprovedDrilldown();
	__localModel.addEditObj.addEditContainer 	= new SpecOrderApprovedAddEdit()
    __localModel.listObj.listGrid = listControlComponent.dgList;
 
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	customBar			 = new SpecOrderApprovedCustomButton();
	this.bcp.btnPrint.visible	= false;
	this.bcp.btnPrint.includeInLayout = false;
	initializeEvent = new InitializeEditableListEvent();
	initializeEvent.dispatch();
}
