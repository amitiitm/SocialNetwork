import business.events.InitializeDataEntryEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import saoi.salesquotation.SalesQuotationController;
import saoi.salesquotation.SalesQuotationModelLocator;
import saoi.salesquotation.SalesQuotationServices;
import saoi.salesquotation.components.SalesQuotationAddEdit;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:SalesQuotationModelLocator = new SalesQuotationModelLocator();

public function handleSalesQuotationAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new SalesQuotationController();
	__genModel.services = new SalesQuotationServices();
	__genModel.activeModelLocator = __localModel;
	
	handleDrillDown();
}

public function handleCreationComplete(event:FlexEvent):void
{
    __localModel.documentObj.documentID 			= __genModel.applicationObject.selectedMenuItem.@document_id
    __localModel.documentObj.create_permission 		= __genModel.applicationObject.selectedMenuItem.@create_permission
    __localModel.documentObj.modify_permission 		= __genModel.applicationObject.selectedMenuItem.@modify_permission
    __localModel.documentObj.view_permission 		= __genModel.applicationObject.selectedMenuItem.@view_permission
    __localModel.documentObj.upload_permission 		= 'Y' // Later we set thru column value
	
	__localModel.addEditObj.addEditContainer 		= new SalesQuotationAddEdit();
    __localModel.listObj.listGrid 					= listControlComponent.dgList;

	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeDataEntryEvent();
	initializeEvent.dispatch();
}
