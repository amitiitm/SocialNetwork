import business.events.InitializeDataEntryEvent;
import com.generic.events.GenModuleEvent;
import dpuoi.invoice.DiamPurchaseInvoiceController;
import dpuoi.invoice.DiamPurchaseInvoiceModelLocator;
import dpuoi.invoice.DiamPurchaseInvoiceServices;
import dpuoi.invoice.components.DiamPurchaseInvoiceAddEdit;
import model.GenModelLocator;
import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:DiamPurchaseInvoiceModelLocator = new DiamPurchaseInvoiceModelLocator();

public function handleDiamPurchaseInvoiceAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new DiamPurchaseInvoiceController();
	__genModel.services   = new DiamPurchaseInvoiceServices();
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
 
	__localModel.addEditObj.addEditContainer = new DiamPurchaseInvoiceAddEdit()
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
    __localModel.listObj.listGrid = listControlComponent.dgList;
	
	initializeEvent = new InitializeDataEntryEvent();
	initializeEvent.dispatch();
}
