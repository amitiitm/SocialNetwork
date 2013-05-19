import puoi.purchasepeople.PurchasePeopleController;
import puoi.purchasepeople.PurchasePeopleModelLocator;
import puoi.purchasepeople.PurchasePeopleServices;
import puoi.purchasepeople.components.PurchasePeopleAddEdit;
import business.events.InitializeDataEntryEvent;
import com.generic.events.GenModuleEvent;
import model.GenModelLocator;
import mx.events.FlexEvent;
import business.events.InitializeImportEvent;

protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
protected var __localModel:PurchasePeopleModelLocator = new PurchasePeopleModelLocator();

public function handlePurchasePeopleAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new PurchasePeopleController();
	__genModel.services = new PurchasePeopleServices();
	__genModel.activeModelLocator = __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
    __localModel.documentObj.documentID = __genModel.applicationObject.selectedMenuItem.@document_id
    __localModel.documentObj.create_permission = __genModel.applicationObject.selectedMenuItem.@create_permission
    __localModel.documentObj.modify_permission = __genModel.applicationObject.selectedMenuItem.@modify_permission
    __localModel.documentObj.view_permission = __genModel.applicationObject.selectedMenuItem.@view_permission
    __localModel.documentObj.upload_permission = 'Y' // Later we set thru column value

	__localModel.addEditObj.addEditContainer = new PurchasePeopleAddEdit()
    __localModel.listObj.listGrid = listControlComponent.dgList;
    
    __localModel.importObj.container = new PurchasePeopleImport()
	vbImport.addChild(__localModel.importObj.container);

	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeDataEntryEvent();
	initializeEvent.dispatch();
	
	var initializeImportEvent:InitializeImportEvent
	initializeImportEvent	=	new InitializeImportEvent();
	initializeImportEvent.dispatch(); 
}
