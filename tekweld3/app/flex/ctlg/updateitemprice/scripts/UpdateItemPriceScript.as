import business.events.InitializeDataEntryWithNoListEvent;

import com.generic.events.GenModuleEvent;

import ctlg.updateitemprice.UpdateItemPriceController;
import ctlg.updateitemprice.UpdateItemPriceModelLocator;
import ctlg.updateitemprice.UpdateItemPriceServices;
import ctlg.updateitemprice.components.UpdateItemPriceAddEdit;

import model.GenModelLocator;

import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:UpdateItemPriceModelLocator = new UpdateItemPriceModelLocator();

public function handleUpdateItemPriceAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new UpdateItemPriceController();
	__genModel.services = new UpdateItemPriceServices();
	__genModel.activeModelLocator = __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
    __localModel.documentObj.documentID = __genModel.applicationObject.selectedMenuItem.@document_id
    __localModel.documentObj.create_permission = __genModel.applicationObject.selectedMenuItem.@create_permission
    __localModel.documentObj.modify_permission = __genModel.applicationObject.selectedMenuItem.@modify_permission
    __localModel.documentObj.view_permission = __genModel.applicationObject.selectedMenuItem.@view_permission
    __localModel.documentObj.upload_permission = 'Y' // Later we set thru column value

	__localModel.addEditObj.addEditContainer = new UpdateItemPriceAddEdit;
    //__localModel.listObj.listGrid =.dgList;

	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeDataEntryWithNoListEvent();
	initializeEvent.dispatch();
}
