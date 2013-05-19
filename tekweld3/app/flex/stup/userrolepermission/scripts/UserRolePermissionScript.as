import business.events.InitializeDataEntryWithNoListEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import stup.userrolepermission.UserRolePermissionController;
import stup.userrolepermission.UserRolePermissionModelLocator;
import stup.userrolepermission.UserRolePermissionServices;
import stup.userrolepermission.components.UserRolePermissionAddEdit;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:UserRolePermissionModelLocator = new UserRolePermissionModelLocator();

public function handleUserRolePermissionAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new UserRolePermissionController();
	__genModel.services = new UserRolePermissionServices();
	__genModel.activeModelLocator = __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.documentID = __genModel.applicationObject.selectedMenuItem.@document_id;
	__localModel.documentObj.create_permission = __genModel.applicationObject.selectedMenuItem.@create_permission;
	__localModel.documentObj.modify_permission = __genModel.applicationObject.selectedMenuItem.@modify_permission;
	__localModel.documentObj.view_permission = __genModel.applicationObject.selectedMenuItem.@view_permission;
	__localModel.documentObj.upload_permission = 'Y';

	__localModel.addEditObj.addEditContainer = new UserRolePermissionAddEdit();
    
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeDataEntryWithNoListEvent();
	initializeEvent.dispatch();
}
