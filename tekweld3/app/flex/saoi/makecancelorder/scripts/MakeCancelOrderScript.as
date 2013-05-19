import business.events.InitializeEditableListEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import saoi.makecancelorder.InboxDrilldownMakeCancelOrder;
import saoi.makecancelorder.MakeCancelOrderController;
import saoi.makecancelorder.MakeCancelOrderModelLocator;
import saoi.makecancelorder.MakeCancelOrderServices;
import saoi.makecancelorder.components.MakeCancelOrderAddEdit;
import saoi.qcorder.InboxDrilldownQcOrder;
import saoi.qcorder.QcOrderController;
import saoi.qcorder.QcOrderModelLocator;
import saoi.qcorder.QcOrderServices;
import saoi.qcorder.components.QcOrderAddEdit;

import valueObjects.ModeVO;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:MakeCancelOrderModelLocator = new MakeCancelOrderModelLocator();

public function handleMakeCancelOrderAcitve(event:GenModuleEvent):void
{
	__genModel.controller 			= 	new MakeCancelOrderController();
	__genModel.services 			= 	new MakeCancelOrderServices();
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
	
	__localModel.listObj.idrilldown				= new InboxDrilldownMakeCancelOrder();
	__localModel.addEditObj.addEditContainer 	= new MakeCancelOrderAddEdit();
    __localModel.listObj.listGrid = listControlComponent.dgList;
 
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	this.bcp.btnPrint.visible	= false;
	this.bcp.btnSave.toolTip	= 'Cancel';
	this.bcp.btnPrint.includeInLayout = false;
	initializeEvent = new InitializeEditableListEvent();
	initializeEvent.dispatch();
}
