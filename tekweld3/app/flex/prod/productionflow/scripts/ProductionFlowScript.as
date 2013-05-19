import business.events.InitializeDataEntryWithNoListEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import prod.productionflow.ProductionFlowController;
import prod.productionflow.ProductionFlowServices;
import prod.productionflow.components.ProductionFlowAddEdit;

import saoi.orderflow.OrderFlowModelLocator;

protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
protected var __localModel:OrderFlowModelLocator = new OrderFlowModelLocator();

public function handleProductionFlowAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new ProductionFlowController();
	__genModel.services = new ProductionFlowServices();
	__genModel.activeModelLocator = __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.documentID = __genModel.applicationObject.selectedMenuItem.@document_id;
	__localModel.documentObj.create_permission = __genModel.applicationObject.selectedMenuItem.@create_permission;
	__localModel.documentObj.modify_permission = __genModel.applicationObject.selectedMenuItem.@modify_permission;
	__localModel.documentObj.view_permission = __genModel.applicationObject.selectedMenuItem.@view_permission;
	__localModel.documentObj.upload_permission = 'Y';

	__localModel.addEditObj.addEditContainer = new ProductionFlowAddEdit();
    
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeDataEntryWithNoListEvent();
	initializeEvent.dispatch();
}
