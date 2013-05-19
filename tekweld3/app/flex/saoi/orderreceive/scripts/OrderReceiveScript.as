import business.events.InitializeDataEntryEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import saoi.orderreceive.OrderReceiveController;
import saoi.orderreceive.OrderReceiveModelLocator;
import saoi.orderreceive.OrderReceiveServices;
import saoi.orderreceive.components.OrderReceiveAddEdit;
import saoi.salesorder.components.SalesOrderAddEdit;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:OrderReceiveModelLocator = new OrderReceiveModelLocator();

public function handleOrderReceiveAcitve(event:GenModuleEvent):void
{
	__genModel.controller 			= new OrderReceiveController();
	__genModel.services 			= new OrderReceiveServices();
	__genModel.activeModelLocator	= __localModel;
	
	handleDrillDown();
}

public function handleCreationComplete(event:FlexEvent):void
{
    __localModel.documentObj.documentID = __genModel.applicationObject.selectedMenuItem.@document_id
    __localModel.documentObj.create_permission = __genModel.applicationObject.selectedMenuItem.@create_permission
    __localModel.documentObj.modify_permission = __genModel.applicationObject.selectedMenuItem.@modify_permission
    __localModel.documentObj.view_permission = __genModel.applicationObject.selectedMenuItem.@view_permission
    __localModel.documentObj.upload_permission = 'Y' // Later we set thru column value
	
	__localModel.addEditObj.addEditContainer = new OrderReceiveAddEdit()
    __localModel.listObj.listGrid = listControlComponent.dgList;

	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeDataEntryEvent();
	initializeEvent.dispatch();
}
