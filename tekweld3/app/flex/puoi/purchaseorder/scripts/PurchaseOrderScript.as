import business.events.InitializeDataEntryEvent;
import business.events.InitializeImportEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import puoi.purchaseorder.PurchaseOrderController;
import puoi.purchaseorder.PurchaseOrderModelLocator;
import puoi.purchaseorder.PurchaseOrderServices;
import puoi.purchaseorder.components.PurchaseOrderAddEdit;
import puoi.purchaseorder.components.PurchaseOrderImport;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:PurchaseOrderModelLocator = new PurchaseOrderModelLocator();

public function handlePurchaseOrderAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new PurchaseOrderController();
	__genModel.services = new PurchaseOrderServices();
	__genModel.activeModelLocator = __localModel;
	handleDrillDown();
}

public function handleCreationComplete(event:FlexEvent):void
{
    __localModel.documentObj.documentID = __genModel.applicationObject.selectedMenuItem.@document_id
    __localModel.documentObj.create_permission = __genModel.applicationObject.selectedMenuItem.@create_permission
    __localModel.documentObj.modify_permission = __genModel.applicationObject.selectedMenuItem.@modify_permission
    __localModel.documentObj.view_permission = __genModel.applicationObject.selectedMenuItem.@view_permission
    __localModel.documentObj.upload_permission = 'Y' // Later we set thru column value
	
	__localModel.addEditObj.addEditContainer = new PurchaseOrderAddEdit()
    __localModel.listObj.listGrid 			 = listControlComponent.dgList;

	__localModel.importObj.container = new PurchaseOrderImport()
	vbImport.addChild(__localModel.importObj.container);	
	
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeDataEntryEvent();
	initializeEvent.dispatch();
	
	var initializeImportEvent:InitializeImportEvent
	initializeImportEvent	=	new InitializeImportEvent();
	initializeImportEvent.dispatch(); 
}
