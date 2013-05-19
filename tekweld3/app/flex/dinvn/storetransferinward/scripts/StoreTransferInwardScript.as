import business.events.InitializeEditableListEvent;
import com.generic.events.GenModuleEvent;
import dinvn.storetransferinward.StoreTransferInwardController;
import dinvn.storetransferinward.StoreTransferInwardModelLocator;
import dinvn.storetransferinward.StoreTransferInwardServices;
import dinvn.storetransferinward.components.StoreTransferInwardAddEdit;
import model.GenModelLocator;
import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:StoreTransferInwardModelLocator = new StoreTransferInwardModelLocator();

public function handleStoreTransferInwardAcitve(event:GenModuleEvent):void
{
	__genModel.controller 			= 	new StoreTransferInwardController();
	__genModel.services 			= 	new StoreTransferInwardServices();
	__genModel.activeModelLocator 	= __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.documentID 		= __genModel.applicationObject.selectedMenuItem.@document_id;
	__localModel.documentObj.create_permission 	= __genModel.applicationObject.selectedMenuItem.@create_permission;
	__localModel.documentObj.modify_permission 	= __genModel.applicationObject.selectedMenuItem.@modify_permission;
	__localModel.documentObj.view_permission 	= __genModel.applicationObject.selectedMenuItem.@view_permission;
	__localModel.documentObj.upload_permission 	= 'Y';

	__localModel.addEditObj.addEditContainer = new StoreTransferInwardAddEdit()
    __localModel.listObj.listGrid = listControlComponent.dgList;
    
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeEditableListEvent();
	initializeEvent.dispatch();
}
