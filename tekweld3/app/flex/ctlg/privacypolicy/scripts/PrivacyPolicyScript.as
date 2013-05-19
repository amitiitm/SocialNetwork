import business.events.InitializeDataEntryWithNoListEvent;

import com.generic.events.GenModuleEvent;

import ctlg.privacypolicy.PrivacyPolicyController;
import ctlg.privacypolicy.PrivacyPolicyModelLocator;
import ctlg.privacypolicy.PrivacyPolicyServices;
import ctlg.privacypolicy.components.PrivacyPolicyAddEdit;

import model.GenModelLocator;

import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:PrivacyPolicyModelLocator = new PrivacyPolicyModelLocator();

public function handlePrivacyPolicyAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new PrivacyPolicyController();
	__genModel.services = new PrivacyPolicyServices();
	__genModel.activeModelLocator = __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.documentID = __genModel.applicationObject.selectedMenuItem.@document_id;
	__localModel.documentObj.create_permission = __genModel.applicationObject.selectedMenuItem.@create_permission;
	__localModel.documentObj.modify_permission = __genModel.applicationObject.selectedMenuItem.@modify_permission;
	__localModel.documentObj.view_permission = __genModel.applicationObject.selectedMenuItem.@view_permission;
	__localModel.documentObj.upload_permission = 'Y';

	__localModel.addEditObj.addEditContainer = new PrivacyPolicyAddEdit();
    
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeDataEntryWithNoListEvent();
	initializeEvent.dispatch();
}
