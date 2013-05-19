import business.events.InitializeDataEntryEvent;
import com.generic.events.GenModuleEvent;
import model.GenModelLocator;
import mx.events.FlexEvent;
import saoi.salescreditinvoice.SalesCreditInvoiceController;
import saoi.salescreditinvoice.SalesCreditInvoiceModelLocator;
import saoi.salescreditinvoice.SalesCreditInvoiceServices;
import saoi.salescreditinvoice.components.SalesCreditInvoiceAddEdit;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:SalesCreditInvoiceModelLocator = new SalesCreditInvoiceModelLocator();

public function handleSalesCreditInvoiceAcitve(event:GenModuleEvent):void
{
	__genModel.controller 			= 	new SalesCreditInvoiceController();
	__genModel.services   			=	new SalesCreditInvoiceServices();
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
 
	__localModel.addEditObj.addEditContainer = new SalesCreditInvoiceAddEdit()
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
    __localModel.listObj.listGrid = listControlComponent.dgList;
	
	initializeEvent = new InitializeDataEntryEvent();
	initializeEvent.dispatch();
}
