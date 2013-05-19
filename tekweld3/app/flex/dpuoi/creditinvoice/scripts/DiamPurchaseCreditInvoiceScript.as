import business.events.InitializeDataEntryEvent;
import com.generic.events.GenModuleEvent;
import dpuoi.creditinvoice.DiamPurchaseCreditInvoiceController;
import dpuoi.creditinvoice.DiamPurchaseCreditInvoiceModelLocator;
import dpuoi.creditinvoice.DiamPurchaseCreditInvoiceServices;
import dpuoi.creditinvoice.components.DiamPurchaseCreditInvoiceAddEdit;
import model.GenModelLocator;
import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:DiamPurchaseCreditInvoiceModelLocator = new DiamPurchaseCreditInvoiceModelLocator();

public function handleDiamPurchaseCreditInvoiceAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new DiamPurchaseCreditInvoiceController();
	__genModel.services   = new DiamPurchaseCreditInvoiceServices();
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
 
	__localModel.addEditObj.addEditContainer = new DiamPurchaseCreditInvoiceAddEdit()
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
    __localModel.listObj.listGrid = listControlComponent.dgList;
	
	initializeEvent = new InitializeDataEntryEvent();
	initializeEvent.dispatch();
}
