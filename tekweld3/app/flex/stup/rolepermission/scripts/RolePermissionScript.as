import business.events.InitializeDataEntryWithNoListEvent;

import com.generic.events.GenModuleEvent;

import stup.rolepermission.RolePermissionController;
import stup.rolepermission.RolePermissionModelLocator;
import stup.rolepermission.RolePermissionServices;
import stup.rolepermission.components.RolePermissionAddEdit;

import model.GenModelLocator;

import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:RolePermissionModelLocator = new RolePermissionModelLocator();

public function handleRolePermissionAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new RolePermissionController();
	__genModel.services = new RolePermissionServices();
	__genModel.activeModelLocator = __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
    __localModel.documentObj.documentID = __genModel.applicationObject.selectedMenuItem.@document_id
    __localModel.documentObj.create_permission = __genModel.applicationObject.selectedMenuItem.@create_permission
    __localModel.documentObj.modify_permission = __genModel.applicationObject.selectedMenuItem.@modify_permission
    __localModel.documentObj.view_permission = __genModel.applicationObject.selectedMenuItem.@view_permission
    __localModel.documentObj.upload_permission = 'Y' // Later we set thru column value

	__localModel.addEditObj.addEditContainer = new RolePermissionAddEdit;
    //__localModel.listObj.listGrid =.dgList;

	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeDataEntryWithNoListEvent();
	initializeEvent.dispatch();
}
