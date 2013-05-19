import invn.category.ItemCategoryController;
import invn.category.ItemCategoryModelLocator;
import business.events.InitializeImportEvent;
import invn.category.ItemCategoryServices;
import invn.category.components.ItemCategoryAddEdit;
import business.events.InitializeDataEntryEvent;
import com.generic.events.GenModuleEvent;
import model.GenModelLocator;
import mx.events.FlexEvent;
import mx.controls.Alert;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:ItemCategoryModelLocator = new ItemCategoryModelLocator();

public function handleItemCategoryAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new ItemCategoryController();
	__genModel.services = new ItemCategoryServices();
	__genModel.activeModelLocator = __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
    __localModel.documentObj.documentID = __genModel.applicationObject.selectedMenuItem.@document_id
    __localModel.documentObj.create_permission = __genModel.applicationObject.selectedMenuItem.@create_permission
    __localModel.documentObj.modify_permission = __genModel.applicationObject.selectedMenuItem.@modify_permission
    __localModel.documentObj.view_permission = __genModel.applicationObject.selectedMenuItem.@view_permission
    __localModel.documentObj.upload_permission = 'Y' // Later we set thru column value

	__localModel.addEditObj.addEditContainer = new ItemCategoryAddEdit()
    __localModel.listObj.listGrid = listControlComponent.dgList;
    
    __localModel.importObj.container = new ItemCategoryImport()
	vbImport.addChild(__localModel.importObj.container);
    
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeDataEntryEvent();
	initializeEvent.dispatch();
	
	var initializeImportEvent:InitializeImportEvent
	initializeImportEvent	=	new InitializeImportEvent();
	initializeImportEvent.dispatch();
}
