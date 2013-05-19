import business.events.InitializeDataEntryEvent;
import com.generic.events.GenModuleEvent;
import model.GenModelLocator;
import mx.events.FlexEvent;
import puoi.purchasecreditinvoice.PurchaseCreditInvoiceController;
import puoi.purchasecreditinvoice.PurchaseCreditInvoiceModelLocator;
import puoi.purchasecreditinvoice.PurchaseCreditInvoiceServices;
import puoi.purchasecreditinvoice.components.PurchaseCreditInvoiceAddEdit;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:PurchaseCreditInvoiceModelLocator = new PurchaseCreditInvoiceModelLocator();

public function handlePurchaseCreditInvoiceAcitve(event:GenModuleEvent):void
{
	__genModel.controller 			= 	new PurchaseCreditInvoiceController();
	__genModel.services   			=	new PurchaseCreditInvoiceServices();
	__genModel.activeModelLocator 	= 	__localModel;
	handleDrillDown();
}

public function handleCreationComplete(event:FlexEvent):void
{
    __localModel.documentObj.documentID = __genModel.applicationObject.selectedMenuItem.@document_id
    __localModel.documentObj.create_permission = __genModel.applicationObject.selectedMenuItem.@create_permission
    __localModel.documentObj.modify_permission = __genModel.applicationObject.selectedMenuItem.@modify_permission
    __localModel.documentObj.view_permission = __genModel.applicationObject.selectedMenuItem.@view_permission
    __localModel.documentObj.upload_permission = 'Y' // Later we set thru column value
 
	__localModel.addEditObj.addEditContainer = new PurchaseCreditInvoiceAddEdit()
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
    __localModel.listObj.listGrid = listControlComponent.dgList;
	
	initializeEvent = new InitializeDataEntryEvent();
	initializeEvent.dispatch();
}
