import business.events.InitializeDataEntryEvent;
import com.generic.events.GenModuleEvent;
import dpuoi.memoreturn.DiamPurchaseMemoReturnController;
import dpuoi.memoreturn.DiamPurchaseMemoReturnServices;
import dpuoi.memoreturn.components.DiamPurchaseMemoReturnAddEdit;
import dpuoi.memoreturn.DiamPurchaseMemoReturnModelLocator;
import model.GenModelLocator;
import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:DiamPurchaseMemoReturnModelLocator = new DiamPurchaseMemoReturnModelLocator();

public function handleDiamPurchaseMemoReturnAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new DiamPurchaseMemoReturnController();
	__genModel.services   = new DiamPurchaseMemoReturnServices();
	__genModel.activeModelLocator = __localModel;
	handleDrillDown();
}

public function handleCreationComplete(event:FlexEvent):void
{
    __localModel.documentObj.documentID = __genModel.applicationObject.selectedMenuItem.@document_id
    __localModel.documentObj.create_permission = __genModel.applicationObject.selectedMenuItem.@create_permission
    __localModel.documentObj.modify_permission = __genModel.applicationObject.selectedMenuItem.@modify_permission
    __localModel.documentObj.view_permission = __genModel.applicationObject.selectedMenuItem.@view_permission
    __localModel.documentObj.upload_permission = 'Y' // Later we set thru column value
 
	__localModel.addEditObj.addEditContainer = new DiamPurchaseMemoReturnAddEdit()
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
    __localModel.listObj.listGrid = listControlComponent.dgList;
	
	initializeEvent = new InitializeDataEntryEvent();
	initializeEvent.dispatch();
}
