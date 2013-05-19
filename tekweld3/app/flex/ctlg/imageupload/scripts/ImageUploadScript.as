import business.events.InitializeDataEntryWithNoListEvent;
import com.generic.events.GenModuleEvent;
import ctlg.imageupload.ImageUploadController;
import ctlg.imageupload.ImageUploadModelLocator;
import ctlg.imageupload.ImageUploadServices;

import model.GenModelLocator;

import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:ImageUploadModelLocator = new ImageUploadModelLocator();

public function handleImageUploadAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new ImageUploadController();
	__genModel.services = new ImageUploadServices();
	__genModel.activeModelLocator = __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.documentID = __genModel.applicationObject.selectedMenuItem.@document_id;
	__localModel.documentObj.create_permission = __genModel.applicationObject.selectedMenuItem.@create_permission;
	__localModel.documentObj.modify_permission = __genModel.applicationObject.selectedMenuItem.@modify_permission;
	__localModel.documentObj.view_permission = __genModel.applicationObject.selectedMenuItem.@view_permission;
	__localModel.documentObj.upload_permission = 'Y';

	__localModel.addEditObj.addEditContainer = new ImageUploadAddEdit();
    
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeDataEntryWithNoListEvent();
	initializeEvent.dispatch();
}
