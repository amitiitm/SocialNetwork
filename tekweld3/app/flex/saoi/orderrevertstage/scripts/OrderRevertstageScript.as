import business.events.InitializeDataEntryEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import saoi.orderrevertstage.OrderRevertstageController;
import saoi.orderrevertstage.OrderRevertstageModelLocator;
import saoi.orderrevertstage.OrderRevertstageServices;
import saoi.orderrevertstage.components.OrderRevertstageAddEdit;

import valueObjects.ModeVO;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:OrderRevertstageModelLocator = new OrderRevertstageModelLocator();

public function handleOrderRevertstageAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new OrderRevertstageController();
	__genModel.services = new OrderRevertstageServices();
	__genModel.activeModelLocator = __localModel;
	
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
	
	__localModel.addEditObj.addEditContainer = new OrderRevertstageAddEdit();
    __localModel.listObj.listGrid = listControlComponent.dgList;
	
	
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	this.bcpDataEntry.btnAdd.visible 			= false;
	this.bcpList.btnAdd.visible 				= false;
	initializeEvent = new InitializeDataEntryEvent();
	initializeEvent.dispatch();
}
