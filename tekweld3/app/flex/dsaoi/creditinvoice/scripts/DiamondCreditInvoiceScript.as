import business.events.InitializeDataEntryEvent;
import com.generic.events.GenModuleEvent;
import dsaoi.creditinvoice.DiamondCreditInvoiceController;
import dsaoi.creditinvoice.DiamondCreditInvoiceModelLocator;
import dsaoi.creditinvoice.DiamondCreditInvoiceServices;
import dsaoi.creditinvoice.components.DiamondCreditInvoiceAddEdit;
import model.GenModelLocator;
import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:DiamondCreditInvoiceModelLocator = new DiamondCreditInvoiceModelLocator();

public function handleDiamondCreditInvoiceAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new DiamondCreditInvoiceController();
	__genModel.services   = new DiamondCreditInvoiceServices();
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
 
	__localModel.addEditObj.addEditContainer = new DiamondCreditInvoiceAddEdit()
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
    __localModel.listObj.listGrid = listControlComponent.dgList;
	
	initializeEvent = new InitializeDataEntryEvent();
	initializeEvent.dispatch();
}
