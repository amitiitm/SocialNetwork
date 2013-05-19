import business.events.InitializeDataEntryEvent;
import business.events.InitializeImportEvent;

import com.generic.events.GenModuleEvent;

import cust.customer.CustomerMasterController;
import cust.customer.CustomerMasterModelLocator;
import cust.customer.CustomerMasterServices;
import cust.customer.components.CustomerMasterAddEdit;
import cust.quickcustomer.QuickCustomerMasterController;
import cust.quickcustomer.QuickCustomerMasterModelLocator;
import cust.quickcustomer.QuickCustomerMasterServices;

import model.GenModelLocator;

import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:QuickCustomerMasterModelLocator = new QuickCustomerMasterModelLocator();

public function handleQuickCustomerMasterAcitve(event:GenModuleEvent):void
{
	__genModel.controller 			= new QuickCustomerMasterController();
	__genModel.services   			= new QuickCustomerMasterServices();
	__genModel.activeModelLocator 	= __localModel;
	handleDrillDown();
}

public function handleCreationComplete(event:FlexEvent):void
{
    __localModel.documentObj.documentID = __genModel.applicationObject.selectedMenuItem.@document_id
    __localModel.documentObj.create_permission = __genModel.applicationObject.selectedMenuItem.@create_permission
    __localModel.documentObj.modify_permission = __genModel.applicationObject.selectedMenuItem.@modify_permission
    __localModel.documentObj.view_permission = __genModel.applicationObject.selectedMenuItem.@view_permission
    __localModel.documentObj.upload_permission = 'Y' // Later we set thru column value
 
	__localModel.addEditObj.addEditContainer = new QuickCustomerMasterAddEdit()
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
    __localModel.listObj.listGrid = listControlComponent.dgList;
	
	  __localModel.importObj.container = new QuickCustomerMasterImport()
	vbImport.addChild(__localModel.importObj.container);
	
	initializeEvent = new InitializeDataEntryEvent();
	initializeEvent.dispatch();
	
	var initializeImportEvent:InitializeImportEvent
	initializeImportEvent	=	new InitializeImportEvent();
	initializeImportEvent.dispatch(); 
}
