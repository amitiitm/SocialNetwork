import business.events.InitializeEditableListEvent;

import com.generic.events.GenModuleEvent;

import melt.updatecommissionencashdate.UpdateCommissionEncashDateController;
import melt.updatecommissionencashdate.UpdateCommissionEncashDateModelLocator;
import melt.updatecommissionencashdate.UpdateCommissionEncashDateServices;
import melt.updatecommissionencashdate.components.UpdateCommissionEncashDateAddEdit;

import model.GenModelLocator;

import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:UpdateCommissionEncashDateModelLocator = new UpdateCommissionEncashDateModelLocator();

public function handleUpdateCommissionEncashDateAcitve(event:GenModuleEvent):void
{
	__genModel.controller 			= 	new UpdateCommissionEncashDateController();
	__genModel.services 			= 	new UpdateCommissionEncashDateServices();
	__genModel.activeModelLocator 	= __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.documentID 		= __genModel.applicationObject.selectedMenuItem.@document_id;
	__localModel.documentObj.create_permission 	= __genModel.applicationObject.selectedMenuItem.@create_permission;
	__localModel.documentObj.modify_permission 	= __genModel.applicationObject.selectedMenuItem.@modify_permission;
	__localModel.documentObj.view_permission 	= __genModel.applicationObject.selectedMenuItem.@view_permission;
	__localModel.documentObj.upload_permission 	= 'Y';

	__localModel.addEditObj.addEditContainer = new UpdateCommissionEncashDateAddEdit()
    __localModel.listObj.listGrid = listControlComponent.dgList;
    
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeEditableListEvent();
	initializeEvent.dispatch();
}
