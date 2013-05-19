import vend.category.VendorCategoryController;
import vend.category.VendorCategoryModelLocator;
import business.events.InitializeImportEvent;
import vend.category.VendorCategoryServices;
import vend.category.components.VendorCategoryAddEdit;
import business.events.InitializeDataEntryEvent;
import com.generic.events.GenModuleEvent;
import model.GenModelLocator;
import mx.controls.Alert;
import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:VendorCategoryModelLocator = new VendorCategoryModelLocator();

public function handleVendorCategoryAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new VendorCategoryController();
	__genModel.services = new VendorCategoryServices();
	__genModel.activeModelLocator = __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
    __localModel.documentObj.documentID = __genModel.applicationObject.selectedMenuItem.@document_id
    __localModel.documentObj.create_permission = __genModel.applicationObject.selectedMenuItem.@create_permission
    __localModel.documentObj.modify_permission = __genModel.applicationObject.selectedMenuItem.@modify_permission
    __localModel.documentObj.view_permission = __genModel.applicationObject.selectedMenuItem.@view_permission
    __localModel.documentObj.upload_permission = 'Y' // Later we set thru column value

	__localModel.addEditObj.addEditContainer = new VendorCategoryAddEdit()
    __localModel.listObj.listGrid = listControlComponent.dgList;
    
     __localModel.importObj.container = new VendorCategoryImport()
	vbImport.addChild(__localModel.importObj.container);	
    
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeDataEntryEvent();
	initializeEvent.dispatch();
	
	var initializeImportEvent:InitializeImportEvent
	initializeImportEvent	=	new InitializeImportEvent();
	initializeImportEvent.dispatch(); 
}
