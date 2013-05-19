import business.events.InitializeDataEntryEvent;

import com.generic.events.GenModuleEvent;

import cust.customerpaymentprofile.CustomerPaymentProfileController;
import cust.customerpaymentprofile.CustomerPaymentProfileModelLocator;
import cust.customerpaymentprofile.CustomerPaymentProfileServices;
import cust.customerpaymentprofile.components.CustomerPaymentProfileAddEdit;

import model.GenModelLocator;

import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:CustomerPaymentProfileModelLocator = new CustomerPaymentProfileModelLocator();

public function handleCustomerPaymentProfileAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new CustomerPaymentProfileController();
	__genModel.services   = new CustomerPaymentProfileServices();
	__genModel.activeModelLocator = __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
    __localModel.documentObj.documentID = __genModel.applicationObject.selectedMenuItem.@document_id
    __localModel.documentObj.create_permission = __genModel.applicationObject.selectedMenuItem.@create_permission
    __localModel.documentObj.modify_permission = __genModel.applicationObject.selectedMenuItem.@modify_permission
    __localModel.documentObj.view_permission = __genModel.applicationObject.selectedMenuItem.@view_permission
    __localModel.documentObj.upload_permission = 'Y' // Later we set thru column value
 
	__localModel.addEditObj.addEditContainer = new CustomerPaymentProfileAddEdit()
	
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
    __localModel.listObj.listGrid = listControlComponent.dgList;
	
	initializeEvent = new InitializeDataEntryEvent();
	initializeEvent.dispatch();
}
