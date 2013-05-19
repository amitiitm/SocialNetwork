import business.events.InitializeDataEntryWithNoListEvent;

import com.generic.events.GenModuleEvent;

import melt.exportwebsitecustomerdata.ExportWebsiteCustomerDataController;
import melt.exportwebsitecustomerdata.ExportWebsiteCustomerDataModelLocator;
import melt.exportwebsitecustomerdata.ExportWebsiteCustomerDataServices;
import melt.exportwebsitecustomerdata.components.ExportWebsiteCustomerDataAddEdit;

import model.GenModelLocator;

import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:ExportWebsiteCustomerDataModelLocator = new ExportWebsiteCustomerDataModelLocator();

public function handleExportWebsiteCustomerDataAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new ExportWebsiteCustomerDataController();
	__genModel.services = new ExportWebsiteCustomerDataServices();
	__genModel.activeModelLocator = __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.documentID = __genModel.applicationObject.selectedMenuItem.@document_id;
	__localModel.documentObj.create_permission = __genModel.applicationObject.selectedMenuItem.@create_permission;
	__localModel.documentObj.modify_permission = __genModel.applicationObject.selectedMenuItem.@modify_permission;
	__localModel.documentObj.view_permission = __genModel.applicationObject.selectedMenuItem.@view_permission;
	__localModel.documentObj.upload_permission = 'Y';

	__localModel.addEditObj.addEditContainer = new ExportWebsiteCustomerDataAddEdit();
    
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeDataEntryWithNoListEvent();
	initializeEvent.dispatch();
}
