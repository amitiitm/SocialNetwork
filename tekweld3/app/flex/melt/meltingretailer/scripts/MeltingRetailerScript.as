import business.events.InitializeDataEntryEvent;
import com.generic.events.GenModuleEvent;
import melt.meltingretailer.MeltingRetailerController;
import melt.meltingretailer.MeltingRetailerModelLocator;
import melt.meltingretailer.MeltingRetailerServices;
import melt.meltingretailer.components.MeltingRetailerAddEdit;

import model.GenModelLocator;

import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:MeltingRetailerModelLocator = new MeltingRetailerModelLocator();

public function handleMeltingRetailerAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new MeltingRetailerController();
	__genModel.services = new MeltingRetailerServices();
	__genModel.activeModelLocator = __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
    __localModel.documentObj.documentID = __genModel.applicationObject.selectedMenuItem.@document_id
    __localModel.documentObj.create_permission = __genModel.applicationObject.selectedMenuItem.@create_permission
    __localModel.documentObj.modify_permission = __genModel.applicationObject.selectedMenuItem.@modify_permission
    __localModel.documentObj.view_permission = __genModel.applicationObject.selectedMenuItem.@view_permission
    __localModel.documentObj.upload_permission = 'Y' // Later we set thru column value

	__localModel.addEditObj.addEditContainer = new MeltingRetailerAddEdit()
    __localModel.listObj.listGrid = listControlComponent.dgList;
    
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeDataEntryEvent();
	initializeEvent.dispatch();
}
