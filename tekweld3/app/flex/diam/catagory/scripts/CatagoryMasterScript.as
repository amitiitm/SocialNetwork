import business.events.InitializeDataEntryEvent;
import business.events.InitializeImportEvent;
import com.generic.events.GenModuleEvent;
import diam.catagory.CatagoryMasterController;
import diam.catagory.CatagoryMasterModelLocator;
import diam.catagory.CatagoryMasterServices;
import diam.catagory.components.CatagoryMasterAddEdit;
import model.GenModelLocator;
import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:CatagoryMasterModelLocator = new CatagoryMasterModelLocator();

public function handleCatagoryMasterAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new CatagoryMasterController();
	__genModel.services   = new CatagoryMasterServices();
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
 
	__localModel.addEditObj.addEditContainer = new CatagoryMasterAddEdit()
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
    __localModel.listObj.listGrid = listControlComponent.dgList;
    
    __localModel.importObj.container = new CatagoryMasterImport()
	vbImport.addChild(__localModel.importObj.container);
	
	initializeEvent = new InitializeDataEntryEvent();
	initializeEvent.dispatch();
	
	var initializeImportEvent:InitializeImportEvent
	initializeImportEvent	=	new InitializeImportEvent();
	initializeImportEvent.dispatch();
}
