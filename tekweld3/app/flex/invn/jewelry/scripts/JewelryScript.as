import invn.jewelry.JewelryController;
import invn.jewelry.JewelryModelLocator;
import invn.jewelry.JewelryServices;
import invn.jewelry.components.JewelryAddEdit;
import business.events.InitializeDataEntryEvent;
import com.generic.events.GenModuleEvent;
import model.GenModelLocator;
import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
protected var __localModel:JewelryModelLocator = new JewelryModelLocator();

public function handleJewelryAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new JewelryController();
	__genModel.services = new JewelryServices();
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

	__localModel.addEditObj.addEditContainer = new JewelryAddEdit()
    __localModel.listObj.listGrid = listControlComponent.dgList;

	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeDataEntryEvent();
	initializeEvent.dispatch();
}
