import business.events.InitializeDataEntryWithNoListEvent;

import com.generic.events.GenModuleEvent;

import ctlg.customerservices.CustomerServicesController;
import ctlg.customerservices.CustomerServicesModelLocator;
import ctlg.customerservices.CustomerServicesServices;
import ctlg.customerservices.components.CustomerServicesAddEdit;

import model.GenModelLocator;

import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:CustomerServicesModelLocator = new CustomerServicesModelLocator();

public function handleCustomerServicesAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new CustomerServicesController();
	__genModel.services = new CustomerServicesServices();
	__genModel.activeModelLocator = __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.documentID = __genModel.applicationObject.selectedMenuItem.@document_id;
	__localModel.documentObj.create_permission = __genModel.applicationObject.selectedMenuItem.@create_permission;
	__localModel.documentObj.modify_permission = __genModel.applicationObject.selectedMenuItem.@modify_permission;
	__localModel.documentObj.view_permission = __genModel.applicationObject.selectedMenuItem.@view_permission;
	__localModel.documentObj.upload_permission = 'Y';

	__localModel.addEditObj.addEditContainer = new CustomerServicesAddEdit();
    
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeDataEntryWithNoListEvent();
	initializeEvent.dispatch();
}
