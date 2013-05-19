import acct.custinvoice.CustomerInvoiceController;
import acct.custinvoice.CustomerInvoiceModelLocator;
import acct.custinvoice.CustomerInvoiceServices;
import acct.custinvoice.components.CustomerInvoiceAddEdit;
import acct.custinvoice.components.CustomerInvoiceImport;

import business.events.InitializeDataEntryEvent;
import business.events.InitializeImportEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:CustomerInvoiceModelLocator = new CustomerInvoiceModelLocator();

public function handleCustomerInvoiceAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new CustomerInvoiceController();
	__genModel.services   = new CustomerInvoiceServices();
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
 
   __localModel.importObj.container = new CustomerInvoiceImport();
	vbImport.addChild(__localModel.importObj.container);
	
	__localModel.addEditObj.addEditContainer = new CustomerInvoiceAddEdit()
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
    __localModel.listObj.listGrid = listControlComponent.dgList;
	
	initializeEvent = new InitializeDataEntryEvent();
	initializeEvent.dispatch();

	var initializeImportEvent:InitializeImportEvent
	initializeImportEvent	=	new InitializeImportEvent();
	initializeImportEvent.dispatch(); 	
}
