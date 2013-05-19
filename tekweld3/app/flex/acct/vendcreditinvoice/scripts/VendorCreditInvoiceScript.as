import acct.vendcreditinvoice.VendorCreditInvoiceController;
import acct.vendcreditinvoice.VendorCreditInvoiceModelLocator;
import acct.vendcreditinvoice.VendorCreditInvoiceServices;
import acct.vendcreditinvoice.components.VendorCreditInvoiceAddEdit;
import acct.vendcreditinvoice.components.VendorCreditInvoiceImport;

import business.events.InitializeDataEntryEvent;
import business.events.InitializeImportEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:VendorCreditInvoiceModelLocator = new VendorCreditInvoiceModelLocator()

public function handleVendorCreditInvoiceAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new VendorCreditInvoiceController();
	__genModel.services   = new VendorCreditInvoiceServices();
	__genModel.activeModelLocator = __localModel;
	handleDrillDown();
}

public function handleCreationComplete(event:FlexEvent):void
{
    __localModel.documentObj.documentID 		= __genModel.applicationObject.selectedMenuItem.@document_id
    __localModel.documentObj.create_permission 	= __genModel.applicationObject.selectedMenuItem.@create_permission
    __localModel.documentObj.modify_permission 	= __genModel.applicationObject.selectedMenuItem.@modify_permission
    __localModel.documentObj.view_permission 	= __genModel.applicationObject.selectedMenuItem.@view_permission
    __localModel.documentObj.upload_permission 	= 'Y' // Later we set thru column value
 
 
 
   __localModel.importObj.container = new VendorCreditInvoiceImport();
	vbImport.addChild(__localModel.importObj.container);
	
	__localModel.addEditObj.addEditContainer = new VendorCreditInvoiceAddEdit()
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
    __localModel.listObj.listGrid = listControlComponent.dgList;

	initializeEvent = new InitializeDataEntryEvent();
	initializeEvent.dispatch();
	
	var initializeImportEvent:InitializeImportEvent
	initializeImportEvent	=	new InitializeImportEvent();
	initializeImportEvent.dispatch(); 
}
