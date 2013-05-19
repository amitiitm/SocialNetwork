import acct.vendinvoice.VendorInvoiceController;
import acct.vendinvoice.VendorInvoiceModelLocator;
import acct.vendinvoice.VendorInvoiceServices;
import acct.vendinvoice.components.VendorInvoiceAddEdit;
import acct.vendinvoice.components.VendorInvoiceImport;

import business.events.InitializeDataEntryEvent;
import business.events.InitializeImportEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:VendorInvoiceModelLocator = new VendorInvoiceModelLocator();

public function handleVendorInvoiceAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new VendorInvoiceController();
	__genModel.services   = new VendorInvoiceServices();
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
 

   __localModel.importObj.container = new VendorInvoiceImport();
	vbImport.addChild(__localModel.importObj.container);
	
	__localModel.addEditObj.addEditContainer = new VendorInvoiceAddEdit()
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
    __localModel.listObj.listGrid = listControlComponent.dgList;
	
	initializeEvent = new InitializeDataEntryEvent();
	initializeEvent.dispatch();
	
	var initializeImportEvent:InitializeImportEvent
	initializeImportEvent	=	new InitializeImportEvent();
	initializeImportEvent.dispatch(); 
}
