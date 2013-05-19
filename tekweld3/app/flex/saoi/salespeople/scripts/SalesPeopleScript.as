import business.events.InitializeDataEntryEvent;
import business.events.InitializeImportEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import saoi.salespeople.SalesPeopleController;
import saoi.salespeople.SalesPeopleModelLocator;
import saoi.salespeople.SalesPeopleServices;
import saoi.salespeople.components.SalesPeopleAddEdit;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:SalesPeopleModelLocator = new SalesPeopleModelLocator();

public function handleSalesPeopleAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new SalesPeopleController();
	__genModel.services   = new SalesPeopleServices();
	__genModel.activeModelLocator = __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
    __localModel.documentObj.documentID = __genModel.applicationObject.selectedMenuItem.@document_id
    __localModel.documentObj.create_permission = __genModel.applicationObject.selectedMenuItem.@create_permission
    __localModel.documentObj.modify_permission = __genModel.applicationObject.selectedMenuItem.@modify_permission
    __localModel.documentObj.view_permission = __genModel.applicationObject.selectedMenuItem.@view_permission
    __localModel.documentObj.upload_permission = 'Y' // Later we set thru column value
 
	__localModel.addEditObj.addEditContainer = new SalesPeopleAddEdit();
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	 __localModel.importObj.container = new SalesPeopleImport()
	vbImport.addChild(__localModel.importObj.container);	
	
    __localModel.listObj.listGrid = listControlComponent.dgList;
	
	initializeEvent = new InitializeDataEntryEvent();
	initializeEvent.dispatch();
	
	var initializeImportEvent:InitializeImportEvent
	initializeImportEvent	=	new InitializeImportEvent();
	initializeImportEvent.dispatch(); 
}
