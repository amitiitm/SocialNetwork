import business.events.InitializeDataEntryEvent;
import com.generic.events.GenModuleEvent;
import dsaoi.memoreturn.DiamondMemoReturnController;
import dsaoi.memoreturn.DiamondMemoReturnServices;
import dsaoi.memoreturn.components.DiamondMemoReturnAddEdit;
import dsaoi.memoreturn.DiamondMemoReturnModelLocator;
import model.GenModelLocator;
import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:DiamondMemoReturnModelLocator = new DiamondMemoReturnModelLocator();

public function handleDiamondMemoReturnAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new DiamondMemoReturnController();
	__genModel.services   = new DiamondMemoReturnServices();
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
 
	__localModel.addEditObj.addEditContainer = new DiamondMemoReturnAddEdit()
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
    __localModel.listObj.listGrid = listControlComponent.dgList;
	
	initializeEvent = new InitializeDataEntryEvent();
	initializeEvent.dispatch();
}
