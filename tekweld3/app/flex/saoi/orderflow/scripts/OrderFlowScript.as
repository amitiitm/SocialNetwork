import business.events.InitializeDataEntryWithNoListEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import saoi.orderflow.OrderFlowController;
import saoi.orderflow.OrderFlowModelLocator;
import saoi.orderflow.OrderFlowServices;
import saoi.orderflow.components.OrderFlowAddEdit;

protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
protected var __localModel:OrderFlowModelLocator = new OrderFlowModelLocator();

public function handleOrderFlowAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new OrderFlowController();
	__genModel.services = new OrderFlowServices();
	__genModel.activeModelLocator = __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.documentID = __genModel.applicationObject.selectedMenuItem.@document_id;
	__localModel.documentObj.create_permission = __genModel.applicationObject.selectedMenuItem.@create_permission;
	__localModel.documentObj.modify_permission = __genModel.applicationObject.selectedMenuItem.@modify_permission;
	__localModel.documentObj.view_permission = __genModel.applicationObject.selectedMenuItem.@view_permission;
	__localModel.documentObj.upload_permission = 'Y';

	__localModel.addEditObj.addEditContainer = new OrderFlowAddEdit();
    
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeDataEntryWithNoListEvent();
	initializeEvent.dispatch();
}
