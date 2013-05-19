import business.events.InitializeDataEntryEvent;

import com.generic.events.GenModuleEvent;

import melt.printcommissioncheck.PrintCommissionCheckController;
import melt.printcommissioncheck.PrintCommissionCheckModelLocator;
import melt.printcommissioncheck.PrintCommissionCheckServices;
import melt.printcommissioncheck.components.PrintCommissionCheckAddEdit;

import model.GenModelLocator;

import mx.events.FlexEvent;

import valueObjects.ModeVO;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:PrintCommissionCheckModelLocator = new PrintCommissionCheckModelLocator();

public function handlePrintCommissionCheckAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new PrintCommissionCheckController();
	__genModel.services   = new PrintCommissionCheckServices();
	__genModel.activeModelLocator = __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.selectedMode	=	ModeVO.LIST_MODE;
    __localModel.documentObj.documentID = __genModel.applicationObject.selectedMenuItem.@document_id
    __localModel.documentObj.create_permission = __genModel.applicationObject.selectedMenuItem.@create_permission
    __localModel.documentObj.modify_permission = __genModel.applicationObject.selectedMenuItem.@modify_permission
    __localModel.documentObj.view_permission = __genModel.applicationObject.selectedMenuItem.@view_permission
    __localModel.documentObj.upload_permission = 'Y' // Later we set thru column value
 
	__localModel.addEditObj.addEditContainer = new PrintCommissionCheckAddEdit();
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
    __localModel.listObj.listGrid = listControlComponent.dgList;
	
	initializeEvent = new InitializeDataEntryEvent();
	initializeEvent.dispatch();
}
